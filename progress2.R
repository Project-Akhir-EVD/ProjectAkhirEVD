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

## USER INTERFACE

ui <- shinyUI(
  navbarPage(
    title = "PLOT PENCAR DAN KORELASI",
    ## Tab 1
    tabPanel(
      title = "Plot Pencar dan Korelasi",
      sidebarLayout(
        ## Sidebar Panel Tab 1
        sidebarPanel(
          ## Data Source
          fluidRow(
            column(6, selectInput(inputId = "data", label = "Pilih Data",
                                  choices = c("Data Disediakan", 
                                              "Input Mandiri"))
            ),
            ## Kondisi 1, pilihan "Data Disediakan"
            column(6, conditionalPanel(
              condition = "input.data == 'Data Disediakan'",
              selectInput(inputId = 'pilih_dataset',
                          label = "Pilihan Data",
                          choices = c("cars",
                                      "women",
                                      "rock",
                                      "pressure"))
            )),
            ## Kondisi 2, pilihan "Input Mandiri"
            column(6, conditionalPanel(
              condition = "input.data == 'Input Mandiri'",
              fileInput(inputId = 'pilih_file', 
                        label = 'Pilih CSV File',
                        accept = c('text/csv',
                                   'text/comma-separated-values,text/plain',
                                   '.csv'))
            ))
          ),
          ## Data
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
        ## Main Panel
        mainPanel(
          ## Summary
          fluidRow(
            tableOutput(outputId = "summary")
          ),
          ## Plot Pencar
          fluidRow(
            plotOutput(outputId = "scatter")
          ),
          ## Korelasi
          fluidRow(
            tableOutput(outputId = "korelasi.statistik")
          )
        )
      )
    ),
    ## Tab 2
    tabPanel(
      title = "Distribusi Bootstrap"),
    ## Tab 3
    tabPanel(
      title = "Distribusi Permutasi")
  )
)

## SERVER
server <- function(input, output){
  myData <- reactive({
    req(input$data)
    ## Data Disediakan
    if(input$data == "Data Disediakan"){
      chosendata <- reactive({
        switch(input$pilih_dataset,
               "cars" = mtcars,
               "women" = women, 
               "rock" = rock,
               "pressure" = pressure)
      })
      output$scatter <- renderPlot({
        plot(myData()[,input$iv], myData()[,input$dv],
             xlab = input$iv, ylab = input$dv,  main = "PLOT PENCAR", pch = 16, 
             col = "black", cex = 1)})
      return(as.data.frame(chosendata()))
    }
    ## Input Mandiri
    else if(input$data == "Input Mandiri"){
      filedata <- reactive({
        inFile <- input$chosen_file
        ext <- tools::file_ext(inFile$datapath)
        req(inFile)
        validate(need(ext =="csv", "Silakan upload csv file"))
        readData <- read.csv(inFile$datapath, header = TRUE)
        readData
      })
      output$scatter <- renderPlot({
        plot(myData()[,input$iv], myData()[,input$dv],
             xlab = input$iv, ylab = input$dv,  main = "PLOT PENCAR", pch = 16, 
             col = "black", cex = 1)})
      return(as.data.frame(filedata()))
    }
  })
  
  output$show_tbl = DT::renderDataTable(myData(),
                                        options = list(scrollX = TRUE))
  
  ## Variabel Inpedenden 
  output$iv <- renderUI({
    selectInput(inputId = 'iv', label = h5('Variabel X'), 
                choices = names(myData()))
  })
  
  ## Variabel Dependen
  output$dv <- renderUI({
    selectInput(inputId = 'dv', label = h5('Variabel Y'), 
                choices = names(myData()))
  })
  
  output$summary <- renderTable({
    data.frame(Variabel=c(input$iv, input$dv), 
               n = c(length(myData()[,input$iv]), length(myData()[,input$dv])),
               rata2 =c(mean(myData()[,input$iv]), mean(myData()[,input$dv])),
               variansi=c(var(myData()[,input$iv]), var(myData()[,input$dv])),
               min = c(min(myData()[,input$iv]), min(myData()[,input$dv])),
               median = c(median(myData()[,input$iv]),median(myData()[,input$dv])),
               max = c(max(myData()[,input$iv]),max(myData()[,input$dv]))
    )
  })
  
  output$korelasi.statistik <- renderTable({
    if (!is.null(data())) {
      correlation_method <- switch(input$korelasi,
                                   "Korelasi Pearson" = cor(myData()[,input$iv], myData()[,input$dv], method = "pearson"),
                                   "Korelasi Spearman" = cor(myData()[,input$iv], myData()[,input$dv], method = "spearman"),
                                   "Kendalls Tau" = cor(myData()[,input$iv], myData()[,input$dv], method = "kendall"))
      data.frame(Method = input$korelasi, Correlation = correlation_method)
    }
  })
}

shinyApp(ui, server)