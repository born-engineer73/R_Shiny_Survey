library(shiny)

# Define UI
ui <- fluidPage(
  titlePanel("User Feedback Survey"),
  sidebarLayout(
    sidebarPanel(),
    mainPanel(
      uiOutput("question"),
      actionButton("nextBtn", "Next"),
      actionButton("exitBtn", "Exit", icon = icon("stop"))
    )
  )
)

# Define Server
server <- function(input, output, session) {
  questions <- list(
    "What is your age group?" = c("18-24", "25-34", "35-44", "45-54", "55+"),
    "What is your gender?" = c("Male", "Female", "Non-binary", "Prefer not to say"),
    "How would you describe your level of education?" = c("High School or below", "Some College", "Bachelor's Degree", "Master's Degree", "Doctorate or higher"),
    "How often do you use technology for work or personal purposes?" = c("Daily", "Weekly", "Monthly", "Rarely", "Never"),
    "What type of devices do you use most frequently?" = c("Smartphone", "Laptop", "Desktop", "Tablet", "Smartwatch"),
    "Which social media platform do you use the most?" = c("Facebook", "Instagram", "Twitter", "LinkedIn", "TikTok"),
    "How would you rate your overall satisfaction with online shopping experiences?" = c("Very Satisfied", "Satisfied", "Neutral", "Dissatisfied", "Very Dissatisfied"),
    "What is your preferred method of communication for professional purposes?" = c("Email", "Phone", "Video Conference", "Instant Messaging", "In-person meetings"),
    "How often do you participate in online surveys or feedback forms?" = c("Frequently", "Occasionally", "Rarely", "Never"),
    "What topics are you most interested in for future surveys?" = c("Technology", "Health and Wellness", "Entertainment", "Education", "Other")
  )
  
  # Shuffle the order of questions
  questions <- questions[sample(length(questions))]
  
  question_index <- reactiveVal(1)
  
  output$question <- renderUI({
    if (question_index() <= length(questions)) {
      question_text <- names(questions)[question_index()]
      answer_choices <- questions[[question_text]]
      tagList(
        h4(question_text),
        radioButtons(paste0("answer_", question_index()), NULL, answer_choices)
      )
    } else {
      h4("Thank you for completing the survey!")
    }
  })
  
  observeEvent(input$nextBtn, {
    question_index(question_index() + 1)
  })
  
  observeEvent(input$exitBtn, {
    showModal(modalDialog(
      title = "Exit Survey",
      "Are you sure you want to exit the survey?",
      footer = tagList(
        actionButton("confirmExit", "Yes", icon = icon("check")),
        modalButton("No", icon = icon("times"))
      )
    ))
  })
  
  observeEvent(input$confirmExit, {
    shinyjs::enable("exitBtn")
    removeModal()
  })
}

# Run the Shiny App
shinyApp(ui, server)
