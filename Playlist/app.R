#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    https://shiny.posit.co/
#

library(shiny)
library(shinythemes)

# Define UI for application that draws a histogram
ui <- navbarPage(
  theme = shinytheme("cyborg"),
  title = "Spotify",
                 tabPanel(id = "tab",
                          title = strong("Top 50 - Global"),
                          icon = icon("circle-info"),  # updated
                          sidebarLayout(
                            sidebarPanel = '',  # updated
                            mainPanel(
                              tags$iframe(
                                style="border-radius:12px", 
                                src="https://open.spotify.com/embed/playlist/37i9dQZEVXbMDoHDwVN2tF?utm_source=generator&theme=0", 
                                width="100%", 
                                height="352", 
                                frameBorder="0", 
                                allowfullscreen="", 
                                allow="autoplay; clipboard-write; encrypted-media; fullscreen; picture-in-picture", 
                                loading="lazy")
                            )
                          )
                 )
)

# Define server logic to summarize and view selected dataset ----
server <- function(input,output,session){}

shinyApp(ui,server)
