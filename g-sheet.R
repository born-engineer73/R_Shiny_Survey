# Load necessary libraries
library(shiny)
library(httr)

# Define Sheety API endpoint (replace 'YOUR_SHEETY_API_URL' with your actual Sheety API URL)
sheety_api_url <- "https://api.sheety.co/de772c6b55dd0e6f908b117c72e20221/rShinyResponses/sheet1"

# Define UI
ui <- fluidPage(
  titlePanel("Survey"),
  mainPanel(
    textOutput("question1"),
    uiOutput("response1"),
    textOutput("question2"),
    uiOutput("response2"),
    textOutput("question3"),
    uiOutput("response3"),
    actionButton("submit", "Submit")
  )
)

# Define Server
server <- function(input, output, session) {
  # Load questions and choices
  questions <- c("Question 1?", "Question 2?", "Question 3?")
  choices <- list(
    c("Choice 1", "Choice 2", "Choice 3"),
    c("Choice A", "Choice B", "Choice C"),
    c("Option X", "Option Y", "Option Z")
  )
  
  # Shuffle questions and choices
  question_order <- sample(1:3)
  choices_order <- lapply(choices, function(x) sample(x))
  
  # Display questions and choices
  output$question1 <- renderText(questions[question_order[1]])
  output$response1 <- renderUI({
    radioButtons("response1", label = NULL, choices = choices_order[[1]])
  })
  
  output$question2 <- renderText(questions[question_order[2]])
  output$response2 <- renderUI({
    radioButtons("response2", label = NULL, choices = choices_order[[2]])
  })
  
  output$question3 <- renderText(questions[question_order[3]])
  output$response3 <- renderUI({
    radioButtons("response3", label = NULL, choices = choices_order[[3]])
  })
  
  # Save responses to Sheety API on submit
  observeEvent(input$submit, {
    # Create a data frame with responses
    responses <- data.frame(
      sheet1 = questions,
      sheet2 = c(input$response1, input$response2, input$response3)
    )
    
    # Make a POST request to Sheety API
    response <- httr::POST(sheety_api_url, body = list(data = responses), encode = "json")
    
    # Check if the request was successful
    if (httr::http_status(response)$category == "success") {
      cat("Responses successfully saved to Sheety!\n")
    } else {
      cat("Error saving responses to Sheety.\n")
      print(httr::content(response))
    }
  })
}

# Run the application
shinyApp(ui, server)
