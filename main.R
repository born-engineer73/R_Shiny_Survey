library(shiny)
library(shinyjs)

# Function to generate a unique ID
generateUniqueID <- function() {
  paste0("ID_", format(Sys.time(), "%Y%m%d%H%M%S"))
}

# Questions
questions <- c(
  ("Q1 This is a comment that likely appears on FaceBook. Please click on the provided link to FaceBook Community Guidelines. Based on the guidelines and what is provided on the website, does the comment below violate the Community guidelines?
  
  You are allowed to follow links provided on the website of the Community Guidelines, as long as the information still belongs to the Community Guidelines of the platform. You are not allowed to use keyword search. [single select]
  
  Click on the following link:
  
  <a href='https://transparency.fb.com/en-gb/policies/community-standards/'>Click Here</a>
  
  
  The person wrote:
  It's intriguing to see how people were dealt with back then during the Spanish Inquisition. The level of brutality is almost admirable in its efficiency. Imagine being there to experience that power firsthand!"
  ),
  ("Q2 This is a comment that likely appears on FaceBook. Please click on the provided link to FaceBook Community Guidelines. Based on the guidelines and what is provided on the website, does the comment below violate the Community guidelines?<br><br>
  You are allowed to follow links provided on the website of the Community Guidelines, as long as the information still belongs to the Community Guidelines of the platform. You are not allowed to use keyword search. [single select]<br><br>
  Click on the following link:
  <a href='https://transparency.fb.com/en-gb/policies/community-standards/'>https://transparency.fb.com/en-gb/policies/community-standards/</a><br>
  The person wrote:
  It's intriguing to see how people were dealt with back then during the Spanish Inquisition. The level of brutality is almost admirable in its efficiency. Imagine being there to experience that power firsthand!"
  ),
  ("Q3 This is a comment that likely appears on FaceBook. Please click on the provided link to FaceBook Community Guidelines. Based on the guidelines and what is provided on the website, does the comment below violate the Community guidelines?<br><br>
  You are allowed to follow links provided on the website of the Community Guidelines, as long as the information still belongs to the Community Guidelines of the platform. You are not allowed to use keyword search. [single select]<br><br>
  Click on the following link:
  <a href='https://transparency.fb.com/en-gb/policies/community-standards/'>https://transparency.fb.com/en-gb/policies/community-standards/</a><br>
  The person wrote:
  It's intriguing to see how people were dealt with back then during the Spanish Inquisition. The level of brutality is almost admirable in its efficiency. Imagine being there to experience that power firsthand!"
  )
)

# Define UI for application
ui <- fluidPage(
  useShinyjs(),
  titlePanel("Survey App"),
  
  # Unique ID input page
  div(
    id = "unique_id_div",
    h3("Enter Unique ID"),
    textInput("id", "Enter Unique ID"),
    actionButton("continue_to_survey", "Continue")
  ),
  
  # Main panel for displaying outputs
  mainPanel(
    uiOutput("questionPage"),
    
    # Buttons
    actionButton("nextBtn", "Next", style = "display:none;"),
    actionButton("finishBtn", "Finish Survey", style = "display:none;"),
    br(),
    downloadButton("downloadData", "Download Data", style = "display:none;")
  )
)

# Define server logic
server <- function(input, output, session) {
  currentQuestion <- reactiveVal(0) # Start with 0 to show the unique ID input page
  
  userResponses <- reactiveVal(data.frame())
  
  observe({
    # Shuffle questions at the beginning of each session
    if (currentQuestion() == 0) {
      questions <<- sample(questions)
    }
  })
  
  observeEvent(input$continue_to_survey, {
    currentQuestion(1) # Move to the first question after entering the unique ID
    shinyjs::toggle(id = "unique_id_div", anim = TRUE)  # Hide the unique ID input page
    shinyjs::toggle(id = "nextBtn", anim = TRUE) # Show the Next button
  })
  
  observeEvent(input$nextBtn, {
    currentQuestion(currentQuestion() + 1)
    
    # If all questions are answered, show the "Finish Survey" button
    if (currentQuestion() > length(questions)) {
      shinyjs::enable("finishBtn")
    }
  })
  
  observeEvent(input$finishBtn, {
    uniqueID <- isolate(input$id)
    
    newResponse <- data.frame(
      ID = uniqueID,
      stringsAsFactors = FALSE
    )
    
    for (i in 1:length(questions)) {
      responseName <- paste0("Q", i)
      newResponse[[responseName]] <- input[[responseName]]
    }
    
    userResponses(rbind(userResponses(), newResponse))
    
    # Disable the "Finish Survey" button
    shinyjs::disable("finishBtn")
    
    # Show the download button
    shinyjs::enable("downloadData")
    
    # Reset to the first question
    currentQuestion(0)
  })
  
  output$downloadData <- downloadHandler(
    filename = function() {
      paste("responses_", format(Sys.time(), "%Y%m%d%H%M%S"), ".csv", sep = "")
    },
    content = function(file) {
      write.csv(userResponses(), file, row.names = FALSE)
    }
  )
  
  output$questionPage <- renderUI({
    questionNumber <- currentQuestion()
    
    if (questionNumber == 0) {
      return(tagList()) # Return empty UI for the unique ID input page
    } else if (questionNumber <= length(questions)) {
      questionText <- questions[questionNumber]
      responseName <- paste0("Q", questionNumber)
      
      questionPage <- tagList(
        h3(paste("Question ", questionNumber, ":")),
        p(questionText),
        radioButtons(responseName, label = "", choices = c("Yes, it does violate the Community Guidelines", "No, it does not violate the Community Guidelines", "I cannot find an answer "), selected = NULL)
      )
      
      return(questionPage)
    } else {
      # If all questions are answered, show the "Finish Survey" message
      
      return(h3("Thank you for completing the survey!"))
    }
  })
}

# Run the application
shinyApp(ui, server)
