# server.R

library(shiny)
library(shinyjs)
library(RMySQL)

host <- "localhost"  # Replace with your MySQL host
port <- 3306         # Replace with your MySQL port
user <- "root"       # Replace with your MySQL username
password <- "Vaibhav@2003"  # Replace with your MySQL password
database <- "r_shiny"  # Replace with your MySQL database name

# Connect to MySQL database
mydb <- dbConnect(MySQL(), 
                  host = host, 
                  port = port, 
                  user = user, 
                  password = password, 
                  dbname = database)

function(input, output, session) {
  observeEvent(input$web_data, {
    print("Changed")
    # Get data from JavaScript
    web_data <- input$web_data
    # Print to debug
    print(web_data)
    # Display web data
    output$web_data_table <- renderTable({
      web_data
    })
  })
  observeEvent(input$open_link, {
    print('Link Clicked')
    google_link <- input$google_link
    # Open link in new window using JavaScript
    runjs(paste0("window.open('", google_link, "', '_blank', 'width=760,height=800,scrollbars=yes,left=0, top=0');"))
  })
  
  # Display table of web data
  output$web_data_table <- renderTable({
    dbReadTable(mydb, "browserhistory")
  })
  
  onStop(function() {
    dbDisconnect(mydb)
  })
}
