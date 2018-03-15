library(shiny)
source("note_io.R")

# Define UI
ui <- navbarPage(
  "Studyr",
  tabPanel(
    "Readings",
    fluidPage(
      sidebarLayout(
        sidebarPanel(uiOutput('select_note')),
        mainPanel(
          h1(textOutput("note_title")),
          htmlOutput("note_body"),
          actionButton("next_note", "Next")
        )
      )
    )
  ),
  tabPanel("Questions")
)
  
server <- function(input, output) {

  # List of notes
  notes_directory <- "~/stage_3_notes"
  notes <- list_notes(notes_directory)

  # Note selection dropdown
  output$select_note = renderUI({
    selectInput('note_file', 'Select note:', purrr::map(notes, ~ .$path))
  })

  # Get note from dropdown selection
  note <- reactive({
    read_note(input$note_file)
  })

  # Note title
  output$note_title <- renderText(note()$header$title)

  # Note body
  output$note_body <- renderUI({
    HTML(markdown::markdownToHTML(text = note()$body, fragment.only = T))
  })

  # Extract questions

}

shinyApp(ui = ui, server = server)
