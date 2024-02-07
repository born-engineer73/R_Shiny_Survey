jscode <- "Shiny.addCustomMessageHandler('closeWindow', function(m) {window.close();});"

runApp(shinyApp(
  ui = tagList(
    tags$head(tags$script(HTML(jscode))),
    navbarPage(
      "test",
      id = "navbar",
      tabPanel(title = "tab1"),
      tabPanel(title = "", value = "Stop", icon = icon("power-off"))
    )
  ),
  server = function(input, output, session) {
    observe({
      if (input$navbar == "Stop") {
        session$sendCustomMessage(type = "closeWindow", message = "message")
        stopApp()
      }
    })
  }
))