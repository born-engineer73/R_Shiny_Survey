library(shiny)

# Define UI
ui <- fluidPage(
  titlePanel("Insert Data into MySQL Database"),
  
  sidebarLayout(
    sidebarPanel(
      textInput("unique_id", "Enter Unique ID:"),
      textInput("marg_id", "Enter Marg ID:"),
      textInput("time", "Enter Time:"),
      textInput("title", "Enter Title:"),
      textInput("url", "Enter URL:"),
      actionButton("submit", "Submit")
    ),
    
    mainPanel(
      tableOutput("view_table")
    )
  )
)
