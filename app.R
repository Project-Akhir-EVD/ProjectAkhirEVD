library(shinythemes)
library(shinyWidgets)
library(shiny)
library(shinydashboard)
library(DT)
library(tidyverse)
library(rhandsontable)
library(data.table)
library(googleVis)
library(ggplot2)
library(plotly)
library(shinyjs)
library(colourpicker)

ui <- shinyUI(
  navbarPage(
    title = "Plot Pencar dan Korelasi",
    tabPanel(
      title = "Summary",
      sidebarLayout(
        sidebarPanel(
          fluidRow(
            column(6, selectInput(inputId = "data", label = "Pilih Data",
                                  choices = c("Data Disediakan", "Input Mandiri"))
            ),
            column(6, conditionalPanel(
              condition = "input.data == 'Data Disediakan'",
              selectInput(inputId = 'pilih_dataset',
                          label = "Pilihan Data",
                          choices = c("cars", "women", "rock", "pressure"))
            )),
            column(6, conditionalPanel(
              condition = "input.data == 'Input Mandiri'",
              fileInput(inputId = 'pilih_file', 
                        label = 'Pilih CSV File',
                        accept = c('text/csv', 'text/comma-separated-values,text/plain', '.csv'))
            ))
          ),
          fluidRow(
            DT::dataTableOutput("show_tbl", width = "100%")
          ),
          br(),
          fluidRow(
            column(6, uiOutput('iv')), 
            column(6, uiOutput('dv'))
          ),
          selectInput(inputId = "korelasi", "Korelasi Statistik", choices = c("Korelasi Pearson", "Korelasi Spearman", "Kendalls Tau")),
          fluidRow(
            column(6, checkboxInput(inputId = "linear", label = "Tren Lurus/Linear")), 
            column(6, checkboxInput(inputId = "smooth", label = "Tren Pemulusan"))
          ),
          fluidRow(
            column(6, selectInput(inputId = "bentuk", label = "Pilih Bentuk Plot Pencar",
                                  choices = c("persegi", "lingkaran", "segitiga", "belah ketupat"))
            )),
          tags$b("Pilih Warna:"),
          fluidRow(
            column(width = 4, colourInput("col_dot", "Plot Pencar", "black", showColour = "background")),
            column(width = 4, colourInput("col_ln", "Tren Linear", "blue", showColour = "background")),
            column(width = 4, colourInput("col_smt", "Tren Pemulusan", "red", showColour = "background"))
          ),
          textInput("judul", strong("Masukkan Judul"), "Plot Pencar")
        ),
        mainPanel(
          fluidRow(
            h3("Deskripsi Data")
          ),
          fluidRow(
            tableOutput(outputId = "summary")
          ),
          fluidRow(
            h3("Plot Pencar")
          ),
          fluidRow(
            plotlyOutput(outputId = "scatter")
          ),
          fluidRow(
            h3("Korelasi Statistik")
          ),
          fluidRow(
            tableOutput(outputId = "korelasi.statistik")
          )
        )
      )
    )
    ,
    tabPanel(
      title = "Informasi",
      
      # Pilih Data
      conditionalPanel(
        condition = "input.data == 'Input Mandiri'",
        includeMarkdown("Inf/pilihdata.md")
      ),
      # Pilih Data
      conditionalPanel(
        condition = "input.data == 'Data Disediakan'",
        includeMarkdown("Inf/pilihdata.md")
      ),
      # Dataset Cars
      conditionalPanel(
        condition = "input.pilih_dataset == 'cars'",
        includeMarkdown("Inf/mtcars.md")
      ),
      # Dataset Women
      conditionalPanel(
        condition = "input.pilih_dataset == 'women'",
        includeMarkdown("Inf/women.md")
      ),
      # Dataset Rock
      conditionalPanel(
        condition = "input.pilih_dataset == 'rock'",
        includeMarkdown("Inf/rock.md")
      ),
      # Dataset Pressure
      conditionalPanel(
        condition = "input.pilih_dataset == 'pressure'",
        includeMarkdown("Inf/pressure.md")
      ),
      # Dataset Korelasi Pearson
      conditionalPanel(
        condition = "input.korelasi == 'Korelasi Pearson'",
        includeMarkdown("Inf/pearson.md")
      ),
      # Dataset Korelasi Spearmen
      conditionalPanel(
        condition = "input.korelasi == 'Korelasi Spearman'",
        includeMarkdown("Inf/spearman.md")
        #        tags$figure(
        #          tags$img(
        #            src = "Inf/spearman.png",
        #            width = 600
        #            )
        #          )
      ),
      # Dataset Korelasi Spearmen
      conditionalPanel(
        condition = "input.korelasi == 'Kendalls Tau'",
        includeMarkdown("Inf/taukendalls.md")
      )
    )
  )
)


createRegressionPlot <- function(data, var_x, var_y, lab_x, lab_y, show_reg_line, show_smooth_line, smoothness = 0.5, judul=NULL, bentuk=16, col_dot="black", col_ln="blue", col_smt="red") {
  lm_model <- lm(formula = paste(var_y, "~", var_x), data = data)
  p <- ggplot(data, aes_string(x = var_x, y = var_y)) + 
    xlab(lab_x) + 
    ylab(lab_y) +
    geom_point(shape=bentuk, fill=col_dot, color=col_dot) + 
    theme_minimal() + 
    labs(title = judul)
  if (show_reg_line) {
    p <- p + geom_smooth(method = "lm", se = FALSE, color = col_ln)
  }
  if (show_smooth_line) {
    p <- p + geom_smooth(method = "loess", se = FALSE, color = col_smt, span = smoothness)
  }
  return(p)
}


server <- function(input, output){
  options(shiny.maxRequestSize=1*1024^2) 
  
  chosendata <- reactive({
    switch(input$pilih_dataset,
           "cars" = mtcars,
           "women" = women, 
           "rock" = rock,
           "pressure" = pressure)
  })
  
  filedata <- reactive({
    inFile <- input$pilih_file
    ext <- tools::file_ext(inFile$datapath)
    req(inFile)
    validate(need(ext == "csv", "Silakan upload csv file"))
    readData <- read.csv(inFile$datapath, header = TRUE)
    readData
  })
  
  myData <- reactive({
    req(input$data)
    if(input$data == "Data Disediakan"){
      return(as.data.frame(chosendata()))
    }
    else if(input$data == "Input Mandiri"){
      return(as.data.frame(filedata()))
    }
  })
  
  output$show_tbl = DT::renderDataTable(head(myData()),
                                        options = list(scrollX = TRUE, searching = FALSE, paging = FALSE, info=FALSE))
  
  output$iv <- renderUI({
    selectInput(inputId = 'iv', label = h5('Variabel Independen'), 
                choices = names(myData()))
  })
  
  output$dv <- renderUI({
    selectInput(inputId = 'dv', label = h5('Variabel Dependen'), 
                choices = names(myData()))
  })
  
  output$summary <- renderTable({
    if (!is.null(input$iv) && !is.null(input$dv) && is.numeric(myData()[, input$iv]) && is.numeric(myData()[, input$dv])) {
      data.frame(
        peubah = c(input$iv, input$dv),
        n = c(length(myData()[, input$iv]), length(myData()[, input$dv])),
        mean = c(mean(myData()[, input$iv], na.rm = TRUE), mean(myData()[, input$dv], na.rm = TRUE)),
        ragam = c(var(myData()[, input$iv], na.rm = TRUE), var(myData()[, input$dv], na.rm = TRUE)),
        min = c(min(myData()[, input$iv], na.rm = TRUE), min(myData()[, input$dv], na.rm = TRUE)),
        median = c(median(myData()[, input$iv], na.rm = TRUE), median(myData()[, input$dv], na.rm = TRUE)),
        max = c(max(myData()[, input$iv], na.rm = TRUE), max(myData()[, input$dv], na.rm = TRUE))
      )
    } else {
      data.frame(peubah = character(0), n = numeric(0), mean = numeric(0), ragam = numeric(0), min = numeric(0), median = numeric(0), max = numeric(0))
    }
  })
  
  output$korelasi.statistik <- renderTable({
    if (!is.null(input$iv) && !is.null(input$dv) && is.numeric(myData()[, input$iv]) && is.numeric(myData()[, input$dv])) {
      correlation_method <- switch(input$korelasi,
                                   "Korelasi Pearson" = cor(myData()[,input$iv], myData()[,input$dv], method = "pearson"),
                                   "Korelasi Spearman" = cor(myData()[,input$iv], myData()[,input$dv], method = "spearman"),
                                   "Kendalls Tau" = cor(myData()[,input$iv], myData()[,input$dv], method = "kendall"))
      data.frame(metode = input$korelasi, korelasi = correlation_method)
    } else {
      data.frame(metode = character(0), korelasi = numeric(0))
    }
  })
  
  bentuk <- reactive({
    switch(input$bentuk,
           "persegi" = 15,
           "lingkaran" = 16, 
           "segitiga" = 17,
           "belah ketupat" = 18)
  })
  
  output$scatter <- renderPlotly({
    if (!is.null(input$iv) && !is.null(input$dv) && is.numeric(myData()[, input$iv]) && is.numeric(myData()[, input$dv])) {
      x <- myData()[, input$iv]
      y <- myData()[, input$dv]
      a <- input$col_dot 
      b <- input$col_ln
      c <- input$col_smt
      titel <- input$judul
      bentuk <- bentuk()
      dataa <- data.frame(x = x, y = y)
      ggplotly(createRegressionPlot(data = dataa, var_x = "x", var_y = "y", lab_x = input$iv, lab_y = input$dv, show_reg_line = input$linear, show_smooth_line = input$smooth, judul=titel, bentuk=bentuk, col_dot=a, col_ln=b, col_smt=c))
    }
  })
}

shinyApp(ui, server)
