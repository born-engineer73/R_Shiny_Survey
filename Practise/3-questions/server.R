# server.R
library(shiny)

# Define the server logic
server <- function(input, output, session) {
  # Load global.R
  source("global.R", local = TRUE)
  
  # Initialize the survey data
  observe({
    if (!file.exists("survey_data.csv")) {
      write.csv(data.frame(Gender = character(), Salutation = character(), Rating = numeric()), "survey_data.csv", row.names = FALSE)
    }
  })
  
  # Collect and save survey data on button click
  observeEvent(input$submitBtn, {
    new_entry <- data.frame(Gender = input$gender, Salutation = input$salutation, Rating = input$rating)
    survey_data <- read.csv("survey_data.csv")
    updated_data <- rbind(survey_data, new_entry)
    write.csv(updated_data, "survey_data.csv", row.names = FALSE)
  })
  
  # Display survey results in a table
  output$surveyResults <- renderTable({
    read.csv("survey_data.csv")
  })
}
