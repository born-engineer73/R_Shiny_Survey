library(shiny)
library(shinyjs)
library(RMySQL)

# Define UI
ui <- fluidPage(
  shinyjs::useShinyjs(),
  tags$head(
    tags$script(
      "function captureWebData(url, title) {
        Shiny.setInputValue('web_data', {url: url, title: title});
      }"
    )
  ),
  textInput("google_link", "Google Link"),
  actionButton("open_link", "Open Link"),
  tableOutput("web_data_table")
)

# Define server logic
server <- function(input, output, session) {
  # Capture messages sent from child window
  observeEvent(input$web_data, {
    # Get data from message
    web_data <- input$web_data
    # Print to debug
    print(web_data)
    # Display web data
    output$web_data_table <- renderTable({
      web_data
    })
  })
  
  # Open link in new window
  observeEvent(input$open_link, {
    google_link <- input$google_link
    js <- sprintf("window.open('%s', '_blank', 'width=760,height=800,scrollbars=yes,left=0, top=0');", google_link)
    runjs(js)
  })
}

# Run the application
shinyApp(ui = ui, server = server)
