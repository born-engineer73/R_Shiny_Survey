library(shiny)
library(RSQLite)
ui <- fluidPage(
  titlePanel("Survey"),
  sidebarLayout(
    sidebarPanel(
      # Sidebar content
    ),
    mainPanel(
      # Main panel content
      HTML("Please <a href='https://transparency.fb.com/policies/community-standards/' id='myLink' target='_blank'>click here</a> to visit our website."),
      br(),
      actionButton("submitBtn", "Submit")
    )
  )
)

server <- function(input, output, session) {
  # Initialize SQLite connection and create a table to store URLs
  con <- dbConnect(RSQLite::SQLite(), "url_history.db")
  dbExecute(con, "CREATE TABLE IF NOT EXISTS url_history (id INTEGER PRIMARY KEY AUTOINCREMENT, url TEXT)")
  
  # Record the URL when the link is clicked
  observeEvent(input$myLink_click, {
    dbExecute(con, "INSERT INTO url_history (url) VALUES (?)", input$myLink_href)
  })
  
  # Close the database connection when the app is stopped
  onStop(function() {
    dbDisconnect(con)
  })
}

shinyApp(ui = ui, server = server)
