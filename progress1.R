library(shiny)
library(ggplot2)
library(plotly)
library(readxl)

## UI 
ui <- shinyUI(
  fluidPage(
    titlePanel("Plot Pencar dan Korelasi"),
    sidebarLayout(
      sidebarPanel(
        selectInput(inputId = "data", "Pilih data", choices = c("Input Mandiri", "Data Disediakan")),
        conditionalPanel(
          condition = "input.data == 'Input Mandiri'",
          fileInput("file", "Pilih file CSV/Excel"),
          textOutput(outputId = "caption")
        ),
        conditionalPanel(
          condition = "input.data == 'Data Disediakan'",
          selectInput(inputId = "dataset", "Dataset", choices = c("Data Satu", "Data Dua", "Data Tiga", "Data Empat")),
        ),
        textInput("x", "Nama Variabel X"),
        textInput("y", "Nama Variabel Y"),
        selectInput(inputId = "korelasi", "Korelasi Statistik", choices = c("Korelasi Pearson", "Korelasi Spearman", "Kendalls Tau")),
        checkboxInput(inputId = "smooth", label = "Tren Pemulusan"),
        checkboxInput(inputId = "linear", label = "Tren Lurus/Linear"),
        checkboxInput(inputId = "pindah.hapus", label = "Memindahkan/Menghapus Data"),
        checkboxInput(inputId = "edit", label = "Mengubah Judul")
      ),
      mainPanel(
        tabsetPanel(
          tabPanel(
            title = "Deskripsi Data dan Plot Pencar",
            tableOutput(outputId = "deskripsi"),
            plotlyOutput(outputId = "plot", width = "100%", height = "100%"),
            tableOutput(outputId = "korelasi.statistik")
          ),
          tabPanel(
            title = "Distribusi Bootstrap"
          ),
          tabPanel(
            title = "Distribusi Permutasi"
          )
        )
      )
    )
  )
)

server <- function(input, output) {
  data <- reactive({
    if (input$data == "Input Mandiri") {
      if (is.null(input$file)) return(NULL)
      # Read user-uploaded CSV or Excel file
      data <- read.csv(input$file$datapath)
      return(data)
    } else {
      # Your code to load data for data disediakan based on selected dataset
      # For now, I'm generating random data with different correlations as an example
      dataset <- switch(input$dataset,
                        "Data Satu" = data.frame(x = rnorm(100), y = rnorm(100)),
                        "Data Dua" = data.frame(x = rnorm(100), y = 2*x + rnorm(100)),
                        "Data Tiga" = data.frame(x = rnorm(100), y = 0.5*x + rnorm(100)),
                        "Data Empat" = data.frame(x = rnorm(100), y = -0.5*x + rnorm(100)))
      return(dataset)
    }
  })
  
  output$caption <- renderText({
    if (input$data == "Input Mandiri" && !is.null(input$file)) {
      # Your code for caption
      # For now, I'm returning a placeholder text
      paste("File", input$file$name, "berhasil diunggah.")
    } else {
      "This is a placeholder for the caption."
    }
  })
  
  output$deskripsi <- renderTable({
    if (!is.null(data())) {
      # Your code to generate table output for deskripsi
      # For now, I'm returning a summary of the data
      data_summary <- summary(data())
      data.frame(Statistic = names(data_summary), Value = as.character(data_summary))
    }
  })
  
  output$plot <- renderPlotly({
    if (!is.null(data())) {
      # Your code for generating plotly scatter plot
      # For now, I'm using a simple scatter plot as an example
      p <- plot_ly(data(), x = ~x, y = ~y, type = 'scatter', mode = 'markers')
      p <- p %>% layout(title = "Scatter Plot")
      p
    }
  })
  
  output$korelasi.statistik <- renderTable({
    if (!is.null(data())) {
      # Your code for generating korelasi.statistik table
      # For now, I'm returning a Pearson correlation coefficient
      correlation_method <- switch(input$korelasi,
                                   "Korelasi Pearson" = cor(data()$x, data()$y, method = "pearson"),
                                   "Korelasi Spearman" = cor(data()$x, data()$y, method = "spearman"),
                                   "Kendalls Tau" = cor(data()$x, data()$y, method = "kendall"))
      data.frame(Method = input$korelasi, Correlation = correlation_method)
    }
  })
}

shinyApp(ui, server)
