# ui.R

library(shiny)
library(shinyjs)

fluidPage(
  shinyjs::useShinyjs(),
  textInput("google_link", "Google Link"),
  actionButton("open_link", "Open Link"),
  tableOutput("web_data_table")
)
