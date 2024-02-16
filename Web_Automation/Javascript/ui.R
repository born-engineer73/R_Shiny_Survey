# ui.R

library(shiny)
library(shinyjs)

fluidPage(
  shinyjs::useShinyjs(),
  tags$head(
    tags$script(src = "script.js")
  ),
  textInput("google_link", "Google Link"),
  actionButton("open_link", "Open Link"),
  tableOutput("web_data_table")
)
