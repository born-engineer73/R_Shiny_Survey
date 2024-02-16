// Function to send web data to Shiny
function sendWebData() {
  var url = window.location.href;
  var title = document.title;
  console.log(title);
  Shiny.setInputValue("web_data", {url: url, title: title});
}

// Call sendWebData() when the document is ready
$(document).ready(function() {
  sendWebData(); // Initial capture on page load
  
  // Capture URL and title on page navigation
  $(window).on('hashchange', function() {
    sendWebData();
  });
  
  // Capture URL and title when a link is clicked
  $(document).on('click', 'a', function() {
    sendWebData();
  });
});


library(shiny)
library(shinyjs)
library(RMySQL)


host <- "localhost"  # Replace with your MySQL host
port <- 3306         # Replace with your MySQL port
user <- "root"  # Replace with your MySQL username
password <- "Vaibhav@2003"  # Replace with your MySQL password
database <- "r_shiny"  # Replace with your MySQL database name
table_name <- "browserhistory"

# MySQL connection parameters
# Connect to MySQL database
mydb <- dbConnect(MySQL(), 
                  host = host, 
                  port = port, 
                  user = user, 
                  password = password, 
                  dbname = database)

# Define UI
ui <- fluidPage(
  shinyjs::useShinyjs(),
  tags$head(
    tags$script(src = "script.js")
  ),
  textInput("google_link", "Google Link"),
  actionButton("open_link", "Open Link"),
  tableOutput("web_data_table")
)

# Define server logic
server <- function(input, output, session) {
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
  
  
  #observeEvent(input$web_data, function(web_data) {
  # Insert into MySQL database
  #dbWriteTable(mydb, "web_data_table", web_data, append = TRUE)
  #})
  
  # Display table of web data
  output$web_data_table <- renderTable({
    dbReadTable(mydb, "browserhistory")
  })
  onStop(function() {
    dbDisconnect(mydb)
  })
  
}

# Run the application
shinyApp(ui = ui, server = server)

