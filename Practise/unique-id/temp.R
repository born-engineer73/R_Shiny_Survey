library(shiny)

# Define the server logic
server <- function(input, output, session) {
  # Reactive values for user ID and CSV data
  rv <- reactiveValues(userID = NULL, data = NULL)
  
  # Determine which UI to render based on user input
  output$main_ui <- renderUI({
    if (is.null(rv$userID)) {
      # Render welcome UI if user ID is not provided
      welcome_ui
    } else {
      # Render CSV upload UI if user ID is provided
      csv_upload_ui
    }
  })
  
  # Welcome page server logic
  observeEvent(input$continueBtn, {
    rv$userID <- input$userID
  })
  
  # CSV file upload page server logic
  observeEvent(input$file, {
    inFile <- input$file
    if (!is.null(inFile)) {
      rv$data <- read.csv(inFile$datapath)
    }
  })
  
  observeEvent(input$saveBtn, {
    # Save the data with the user's unique ID
    timestamp <- format(Sys.time(), "%Y%m%d%H%M%S")
    filename <- paste0("survey_data_", rv$userID, "_", timestamp, ".csv")
    
    # Save the data to the file
    write.csv(rv$data, filename, row.names = FALSE)
    
    cat("Data saved to:", filename, "\n")
  })
}
