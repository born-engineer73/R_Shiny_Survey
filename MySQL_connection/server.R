

host <- "localhost"  # Replace with your MySQL host
port <- 3306         # Replace with your MySQL port
user <- "root"  # Replace with your MySQL username
password <- "Vaibhav@2003"  # Replace with your MySQL password
database <- "r_shiny"  # Replace with your MySQL database name
table_name <- "browserhistory"

# Establish a database connection


library(shiny)
library(RMySQL)

# Define server logic
server <- function(input, output) {
  
  # Connect to MySQL database
  con <- dbConnect(MySQL(), 
                   host = host, 
                   port = port, 
                   user = user, 
                   password = password, 
                   dbname = database)
  
  # Function to insert data into the database
  insertData <- function() {
    unique_id <- input$unique_id
    marg_id <- input$marg_id
    time <- input$time
    title <- input$title
    url <- input$url
    
    # Insert data into the table
    query <- sprintf("INSERT INTO %s (Unique_ID, Marg_ID, time, title, url) VALUES ('%s', '%s', '%s', '%s', '%s')", 
                     table_name, as.character(unique_id), as.character(marg_id), time, title, url)
    dbSendQuery(con, query)
  }
  
  # Perform data insertion when submit button is clicked
  observeEvent(input$submit, {
    insertData()
    output$view_table <- renderTable({
      # Fetch data from the table
      query <- paste("SELECT * FROM",table_name)
      table_data <- dbGetQuery(con, query)
      table_data
    })
  })
  
  # Display the table
  
  
  # Close the database connection when the app exits
  onStop(function() {
    dbDisconnect(con)
  })
}

