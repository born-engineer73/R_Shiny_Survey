# server.R
library(shiny)

questions <- list(
  list(question = "Question 1", options = c("Option A", "Option B", "Option C")),
  list(question = "Question 2", options = c("Option X", "Option Y", "Option Z")),
  list(question = "Question 3", options = c("Option P", "Option Q", "Option R"))
)

server <- function(input, output, session) {
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
  
  render_question_page <- function(question, options) {
    fluidPage(
      mainPanel(
        h4(question),
        radioButtons("response", label = NULL, choices = options),
        actionButton("nextBtn", "Next"),
        tags$a(href = "https://transparency.fb.com/policies/community-standards/", target = "_blank", "Facebook Community Guidelines")
      )
    )
  }
  
  render_summary_page <- function() {
    summary_data <- data.frame(
      Question = names(response_times),
      Time_Taken = as.numeric(reactiveValuesToList(response_times))
    )
    write.csv(summary_data, "response_times.csv", row.names = FALSE)
    
    fluidPage(
      mainPanel(
        h4("Survey Summary"),
        tableOutput("summaryTable")
      )
    )
  }
  
  output$summaryTable <- renderTable({
    read.csv("response_times.csv")
  })
}
