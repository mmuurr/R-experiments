library(shiny)

ui <- fluidPage(
  actionButton("btn", "click me"),
  verbatimTextOutput("out")
)

server <- function(input, output, session) {
  my_iris <- reactive({
    input$btn
    dplyr::sample_n(iris, 10)
  })
  my_op_tbl <- reactive({
    input$btn
    tibble::tibble(x = sample(1:10, 3))
  })

  output$out <- renderPrint({
    input$btn
    purrr::pwalk(my_op_tbl(), function(...) with(list(...), {
      my_iris() |> dplyr::slice(x) |> print()
    }))
  })
}

runApp(shinyApp(ui, server), port = 6969)
