library(shiny)

# Define the server logic
server <- function(input, output, session) {


  # Page1 :- Unique ID --------------->



  # Reactive values for user ID and CSV data
  rv <- reactiveValues(userID = NULL, data = NULL)
  # Determine which UI to render based on user input
  output$main_ui <- renderUI({
    if (is.null(rv$userID)) {
      # Render welcome UI if user ID is not provided
      welcome_ui
    }
  })
  # Welcome page server logic
  observeEvent(input$continueBtn, {
    rv$userID <- input$userID
  })


  # Page2 :- 3 Questions (Dropdown for Gender , Salutation, and Rating Scale for range 1-100 ) --------------?

  # Initialize the survey data
  observe({
    if (!file.exists("survey_data.csv")) {
      write.csv(data.frame(Gender = character(), Salutation = character(), Rating = numeric()), "survey_data.csv", row.names = FALSE)
    }
  })

  # Collect and save survey data on button click
  observeEvent(input$submitBtn, {
    new_entry <- data.frame(Gender = input$gender, Salutation = input$salutation, Rating = input$rating)
    survey_data <- read.csv("survey_data.csv")
    updated_data <- rbind(survey_data, new_entry)
    write.csv(updated_data, "survey_data.csv", row.names = FALSE)
  })

  # Display survey results in a table
  output$surveyResults <- renderTable({
    read.csv("survey_data.csv")
  })



  # Page3 :- 3 Questions for recording time in seconds  --------------->

  questions <- list(
    list(question = "Question 1", options = c("Option A", "Option B", "Option C")),
    list(question = "Question 2", options = c("Option X", "Option Y", "Option Z")),
    list(question = "Question 3", options = c("Option P", "Option Q", "Option R"))
  )

  question_index <- reactiveVal(1)
  start_time <- reactiveVal(NULL)
  response_times <- reactiveValues()

  observe({
    start_time(Sys.time())
  })

  output$questionnairePage <- renderUI({
    if (question_index() <= length(questions)) {
      question <- questions[[question_index()]]
      render_question_page(question$question, question$options)
    } else {
      render_summary_page()
    }
  })

  observeEvent(input$nextBtn, {
    response_times[[paste0("Question", question_index())]] <- as.numeric(difftime(Sys.time(), start_time(), units = "secs"))
    question_index(question_index() + 1)
    start_time(Sys.time())
  })

  output$summaryTable <- renderTable({
    summary_data <- data.frame(
      Question = names(response_times),
      Time_Taken = as.numeric(reactiveValuesToList(response_times))
    )
    write.csv(summary_data, "response_times.csv", row.names = FALSE)
    read.csv("response_times.csv")
  })



  # page4 :- Randomizing the order of questions (MCQ type) -------------------->
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



  # Page5 :- Link opening in new window in left half of screen ------->

  observeEvent(input$submitBtn, {
    runjs("window.myWindow.close();")
  })
}
