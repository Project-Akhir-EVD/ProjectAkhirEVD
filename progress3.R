library(shinythemes)
library(shinyWidgets)
library(shiny)
library(shinydashboard)
library(shinysky)
library(DT)
library(tidyverse)
library(rhandsontable)
library(data.table)
library(googleVis)
library(ggplot2)
library(plotly)  # Ensure plotly library is loaded

ui <- shinyUI(
  navbarPage(
    title = "Plot Pencar dan Korelasi",
    tabPanel(
      title = "Plot Pencar dan Korelasi",
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
          fluidRow(
            column(6, uiOutput('iv')), 
            column(6, uiOutput('dv'))
          ),
          selectInput(inputId = "korelasi", "Korelasi Statistik", choices = c("Korelasi Pearson", "Korelasi Spearman", "Kendalls Tau")),
          checkboxInput(inputId = "smooth", label = "Tren Pemulusan"),
          checkboxInput(inputId = "linear", label = "Tren Lurus/Linear"),
          checkboxInput(inputId = "pindah", label = "Memindahkan Data"),
          checkboxInput(inputId = "hapus", label = "Menghapus Data"),
          checkboxInput(inputId = "edit", label = "Mengubah Judul")
        ),
        mainPanel(
          fluidRow(
            tableOutput(outputId = "summary")
          ),
          fluidRow(
            plotlyOutput(outputId = "scatter")  # Use plotlyOutput for plotly
          ),
          fluidRow(
            tableOutput(outputId = "korelasi.statistik")
          )
        )
      )
    ),
    tabPanel(
      title = "Distribusi Bootstrap"
    ),
    tabPanel(
      title = "Distribusi Permutasi"
    )
  )
)

server <- function(input, output){
  myData <- reactive({
    req(input$data)
    if(input$data == "Data Disediakan"){
      chosendata <- reactive({
        switch(input$pilih_dataset,
               "cars" = mtcars,
               "women" = women, 
               "rock" = rock,
               "pressure" = pressure)
      })
      return(as.data.frame(chosendata()))
    }
    else if(input$data == "Input Mandiri"){
      filedata <- reactive({
        inFile <- input$pilih_file
        ext <- tools::file_ext(inFile$datapath)
        req(inFile)
        validate(need(ext == "csv", "Silakan upload csv file"))
        readData <- read.csv(inFile$datapath, header = TRUE)
        readData
      })
      return(as.data.frame(filedata()))
    }
  })
  
  output$show_tbl = DT::renderDataTable(myData(),
                                        options = list(scrollX = TRUE))
  
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
        Variabel = c(input$iv, input$dv),
        n = c(length(myData()[, input$iv]), length(myData()[, input$dv])),
        rata2 = c(mean(myData()[, input$iv], na.rm = TRUE), mean(myData()[, input$dv], na.rm = TRUE)),
        variansi = c(var(myData()[, input$iv], na.rm = TRUE), var(myData()[, input$dv], na.rm = TRUE)),
        min = c(min(myData()[, input$iv], na.rm = TRUE), min(myData()[, input$dv], na.rm = TRUE)),
        median = c(median(myData()[, input$iv], na.rm = TRUE), median(myData()[, input$dv], na.rm = TRUE)),
        max = c(max(myData()[, input$iv], na.rm = TRUE), max(myData()[, input$dv], na.rm = TRUE))
      )
    } else {
      data.frame(Variabel = character(0), n = numeric(0), rata2 = numeric(0), variansi = numeric(0), min = numeric(0), median = numeric(0), max = numeric(0))
    }
  })
  
  output$korelasi.statistik <- renderTable({
    if (!is.null(input$iv) && !is.null(input$dv) && is.numeric(myData()[, input$iv]) && is.numeric(myData()[, input$dv])) {
      correlation_method <- switch(input$korelasi,
                                   "Korelasi Pearson" = cor(myData()[,input$iv], myData()[,input$dv], method = "pearson"),
                                   "Korelasi Spearman" = cor(myData()[,input$iv], myData()[,input$dv], method = "spearman"),
                                   "Kendalls Tau" = cor(myData()[,input$iv], myData()[,input$dv], method = "kendall"))
      data.frame(Method = input$korelasi, Correlation = correlation_method)
    } else {
      data.frame(Method = character(0), Correlation = numeric(0))
    }
  })
  
  output$scatter <- renderPlotly({
    if (!is.null(input$iv) && !is.null(input$dv) && is.numeric(myData()[, input$iv]) && is.numeric(myData()[, input$dv])) {
      x <- myData()[, input$iv]
      y <- myData()[, input$dv]
      dataa <- data.frame(x = x, y = y)
      createRegressionPlot <- function(data, x_var, y_var, show_reg_line, show_smooth_line, smoothness = 0.5) {
        lm_model <- lm(formula = paste(y_var, "~", x_var), data = data)
        p <- ggplot(data, aes_string(x = x_var, y = y_var)) + geom_point() + theme_minimal()
        if (show_reg_line) {
          p <- p + geom_smooth(method = "lm", se = FALSE, color = "#5959b8")
        }
        if (show_smooth_line) {
          p <- p + geom_smooth(method = "loess", se = FALSE, color = "#92fb51", span = smoothness)
        }
        return(p)
      }
      ggplotly(createRegressionPlot(data = dataa, x_var = "x", y_var = "y", show_reg_line = input$linear, show_smooth_line = input$smooth))
    }
  })
}

shinyApp(ui, server)
