library(shiny)

# Define the user interface


# Page1 :- Unique ID


welcome_ui <- fluidPage(
  titlePanel("Welcome to CSV File Upload App"),
  sidebarLayout(
    sidebarPanel(
      textInput("userID", "Enter Your Unique ID"),
      actionButton("continueBtn", "Continue")
    ),
    mainPanel(
      # You can add additional content or instructions here
    )
  )
)


# Page2 :- 3 Questions (Dropdown for Gender , Salutation, and Rating Scale for range 1-100 )


ui <- fluidPage(
  # Input fields for the survey
  sidebarPanel(
    selectInput("gender", "Gender:", choices = c("Male", "Female", "Other")),
    selectInput("salutation", "Salutation:", choices = c("Mr.", "Ms.", "Mrs.", "Dr.", "Other")),
    sliderInput("rating", "Rating:", min = 1, max = 10, value = 5)
  ),
  # Button to submit the survey
  mainPanel(
    actionButton("submitBtn", "Submit"),
    # Display survey results in a table
    tableOutput("surveyResults")
  )
)





# Page3 :- 3 Questions for recording time in seconds  --------------->

ui <- fluidPage(
  uiOutput("questionnairePage")
)

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
  fluidPage(
    mainPanel(
      h4("Survey Summary"),
      tableOutput("summaryTable")
    )
  )
}




# Page4 :- Randomizing the order of questions (MCQ type) -------------------->

fluidPage(
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


# Page5 :- Link opening in new window in left half of screen

ui <- fluidPage(
  titlePanel("Survey"),
  sidebarLayout(
    sidebarPanel(
      # Sidebar content
    ),
    mainPanel(
      # Main panel content
      HTML("Please <a href='https://transparency.fb.com/policies/community-standards/' id='myLink' onclick=\"window.myWindow = window.open(this.href,'_blank','width=760,height=800,left=0,top=0'); return false;\">click here</a> to visit our website."),
      br(),
      actionButton("submitBtn", "Submit")
    )
  )
)
