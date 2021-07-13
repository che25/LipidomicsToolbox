sidebarLayout(
  sidebarPanel(
    h3("Positive mode features"),
    br(),
    shinyWidgets::sliderTextInput(
      inputId = "filter_pos_grade", 
      label = "Max Grade for positive mode", 
      choices = LETTERS[1:4]
    ),
    sliderInput(
      inputId = "filter_pos_occupy",
      label = "Min Occupy for positive mode",
      value = 10,
      min = 0,
      max = 100,
      step = 1
    ),
    sliderInput(
      inputId = "filter_pos_points",
      label = "Min Number of points for positive mode",
      value = 10,
      min = 0,
      max = 100,
      step = 1
    ),
    hr(),
    h3("Negative mode features"),
    shinyWidgets::sliderTextInput(
      inputId = "filter_neg_grade", 
      label = "Max Grade for negative mode", 
      choices = LETTERS[1:4]
    ),
    sliderInput(
      inputId = "filter_neg_occupy",
      label = "Min Occupy for negative mode",
      value = 10,
      min = 0,
      max = 100,
      step = 1
    ),
    sliderInput(
      inputId = "filter_neg_points",
      label = "Min Number of points for negative mode",
      value = 10,
      min = 0,
      max = 100,
      step = 1
    ),
    hr(),
    br(),
    actionButton(
      inputId = "filter_go",
      label = "Filter"
    )
  ),
  mainPanel(
    verbatimTextOutput("filter_summary") %>% 
      tagAppendAttributes(style= 'color:green;')
  )
)