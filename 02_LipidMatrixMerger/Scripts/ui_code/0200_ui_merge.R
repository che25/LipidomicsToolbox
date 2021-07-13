sidebarLayout(
  sidebarPanel(
    h3("Merge"),
    br(),
    radioButtons(
      inputId = "merge_mode",
      label = "Merge by",
      choices = c(`Class`="class", `Class n:m`="group", `Class fatty acid`="lipid"),
      selected = "class",
      inline = F
    ),
    radioButtons(
      inputId = "merge_function",
      label = "Aggregate function",
      choices = c("max", "sum", "median"),
      selected = "sum",
      inline = T
    ),
    conditionalPanel(
      condition ="input.merge_mode == 'lipid'",
      sliderInput(
        inputId = "merge_tol",
        label = "Merge Rt tolerance (min)",
        min = 0.01, max = 1, value = 0.1
      )
    ),
    uiOutput("merge_remove_samples"),
    br(),
    actionButton(
      inputId = "merge_go",
      label = "Go!"
    ),
    br(),
    br(),
    uiOutput("merge_download_wrapper"),
  ),
  mainPanel(
    verbatimTextOutput("merge_summary") %>% 
      tagAppendAttributes(style= 'color:green;'),
    DT::dataTableOutput("merge_features")
  )
)