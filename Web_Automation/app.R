library(shiny)
library(shinyjs)
library(RSelenium)
library(netstat)
# Define UI
ui <- fluidPage(
  shinyjs::useShinyjs(),
  textInput("google_link", "Google Link"),
  actionButton("open_link", "Open Link"),
  tableOutput("web_data_table")
)

# Define server logic
server <- function(input, output, session) {
  # Function to capture web data using Selenium
  captureWebData <- function(url) {
    # Set up Chrome WebDriver
    driver <- rsDriver(browser = "chrome", chromever = "121.0.6167.185", port=4445L)
    remDr <- driver[["client"]]
    
    # Open the link in a new window
    remDr$executeScript(paste0("window.open('", url, "', '_blank');"))
    
    # Switch to the new window
    remDr$switchToWindow(remDr$getWindowHandles()[[2]])
    
    # Capture URL and title
    url <- remDr$getCurrentUrl()
    title <- remDr$getTitle()
    
    # Stop the Selenium driver
    driver$server$stop()
    
    return(list(url = url, title = title))
  }
  
  observeEvent(input$open_link, {
    google_link <- input$google_link
    
    # Capture web data using Selenium
    web_data <- captureWebData(google_link)
    
    # Display web data
    output$web_data_table <- renderTable({
      web_data
    })
  })
}

# Run the application
shinyApp(ui = ui, server = server)
