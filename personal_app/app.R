library(shiny)
library(ggplot2)
library(shinythemes)
library(readr)

songs <- read_csv("spotify_songs_edited.csv")

# Define UI for application that draws a histogram
ui <- fluidPage(
  theme = shinytheme("cyborg"),
  titlePanel("Spotify Music"),
  sidebarLayout(
    sidebarPanel(
      titlePanel("Popularity vs Elements of Music"),
      selectInput(inputId = "dataset", label = "Dataset", choices = c("songs")),
      selectInput(inputId = "plot_variable_x",
                  label = "Select x-axis variable:",
                  choices = NULL),
      selectInput(inputId = "plot_variable_y",
                  label = "Select y-axis variable:",
                  choices = NULL)
    ),
    mainPanel(
      h3(textOutput("caption", container = span)),
      plotOutput("plot", width = "1000px", height = "800px") # Output: Plot based on selected variables
    )
  )
)

# Define server logic to summarize and view selected dataset ----
server <- function(input, output) {
  
  # Return the requested dataset ----
  datasetInput <- reactive({
    switch(input$dataset,
           "songs" = songs)
  })
  
  # Create caption ----
  output$caption <- renderText({
    input$caption
  })
  
  # Generate a summary of the dataset (conditional) ----
  output$summary <- renderPrint({
    if (input$show_summary) {
      dataset <- datasetInput()
      summary(dataset)
    }
  })
  
  # Update variable choices based on selected dataset ----
  observeEvent(input$dataset, {
    dataset <- datasetInput()
    updateSelectInput(
      inputId = "plot_variable_x",
      choices = names(dataset),
      selected = NULL
    )
    if (input$dataset == "songs") {
      updateSelectInput(
        inputId = "plot_variable_x",
        choices = c("danceability","valence","speechiness","tempo"),
        selected = NULL
      )}
    updateSelectInput(
      inputId = "plot_variable_y",
      choices = c("track_popularity"),
      selected = NULL
    )
  }
  )
  
  # Generate plot based on selected variables ----
  
  output$plot <- renderPlot({
    dataset <- datasetInput()
    variable_x <- input$plot_variable_x
    variable_y <- input$plot_variable_y
    
    if (!is.null(variable_x) && !is.null(variable_y)) {
      ggplot(dataset, aes_string(x = variable_x, y = variable_y)) +
        geom_point() +
        labs(x = variable_x, y = variable_y) +
        theme_minimal() +
        geom_smooth(method = "lm")
    }
  })
  
}

# Run the application 
shinyApp(ui = ui, server = server)