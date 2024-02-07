library(shiny)
library(shinyjs)

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
      actionButton("submitBtn", "Submit"),
      useShinyjs()
    )
  )
)

server <- function(input, output) {
  observeEvent(input$submitBtn, {
    runjs("window.myWindow.close();")
  })
}

shinyApp(ui = ui, server = server)
