library(shiny)
library(ggplot2)


# Define UI for application that draws a histogram
ui <- fluidPage(
  
  # Application title
  titlePanel("Spotify Music"),
  
  # Sidebar layout with input and output definitions ----
  sidebarLayout(
    
    # Sidebar panel for inputs ----
    sidebarPanel(
      
      # Input: Selector for variable to plot against mpg ---
    selectInput(inputId = "plot_variable_x",
                label = "Select x-axis variable:",
                choices = c("danceability","valence","speechiness","tempo")),
    selectInput(inputId = "plot_variable_y",
                label = "Select y-axis variable:",
                choices = c("track_popularity"))
  ),
    
    # Main panel for displaying outputs ----
    mainPanel(
      # Output: Formatted text for caption ----
      h3(textOutput("caption")),
      
      # Output: Plot of the requested variable against mpg ----
      plotOutput("Popularity_Plot"),
      )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
  
  # Compute the formula text ----
  # This is in a reactive expression since it is shared by the
  # output$caption and output$Popularity_Plot functions
  formulaText <- reactive({
    paste("popularity ~", input$plot_variable_x)
  })
  
  # Return the formula text for printing as a caption ----
  output$caption <- renderText({
    formulaText()
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
    
    if (input$dataset == "music") {
      updateSelectInput(
        inputId = "plot_variable_x",
        choices = c("danceability","valence","speechiness","tempo"),
        selected = NULL
      )}

})
  
  # Generate plot based on selected variables ----
  
  output$plot <- renderPlot({
    dataset <- datasetInput()
    variable_x <- input$plot_variable_x
    variable_y <- input$plot_variable_y
    
    if (!is.null(variable_x) && !is.null(variable_y)) {
      ggplot(dataset, aes_string(x = variable_x, y = variable_y)) +
        geom_point() +
        labs(x = variable_x, y = variable_y) +
        geom_smooth(method = "lm")
    }
  })
}


# Run the application 
shinyApp(ui = ui, server = server)