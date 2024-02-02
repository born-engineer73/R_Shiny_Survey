# ui.R
library(shiny)

# Define the user interface
ui <- fluidPage(
  titlePanel("User Survey"),
  sidebarLayout(
    sidebarPanel(
      radioButtons("gender", "Gender:", c("Male", "Female", "Other")),
      selectInput("salutation", "Salutation:", c("Mr.", "Ms.", "Dr.")),
      sliderInput("rating", "Rate between 1 to 100:", min = 1, max = 100, value = 50)
    ),
    mainPanel(
      actionButton("submitBtn", "Submit"),
      tableOutput("surveyResults")
    )
  )
)
