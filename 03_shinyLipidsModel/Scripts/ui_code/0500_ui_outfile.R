sidebarLayout(
  sidebarPanel(
    h3("Export"),
    br(),
    radioButtons(
      inputId = "outfile_model",
      label = "Export model",
      choices = c("model0", "model1", "model2"),
      inline = T
    ),
    radioButtons(
      inputId = "outfile_mode",
      label = "Filter peaks before export",
      choices = c(`Do not filter at all`="no", `MAD threshold only`="mad", `RT threshold`="threshold"),
      #  `best species`="best"
      selected = "no"
    ),
    conditionalPanel(
      condition = "input.outfile_mode=='threshold'",
      sliderInput(
        inputId = "outfile_threshold",
        label = "Delta RT threshold (min)",
        value = 0.2,
        min = 0,
        max = 1,
        step = .05
      )
    ),
    hr(),
    br(),
    uiOutput("outfile_download_wrapper")
  ),
  mainPanel(
    verbatimTextOutput("outfile_summary") %>% 
      tagAppendAttributes(style= 'color:green;')
  )
)