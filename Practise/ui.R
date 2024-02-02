# ui.R
library(shiny)

ui <- fluidPage(
  titlePanel("Questionnaire"),
  uiOutput("questionnairePage")
)
