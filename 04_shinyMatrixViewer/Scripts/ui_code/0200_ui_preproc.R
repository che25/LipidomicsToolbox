sidebarLayout(
  sidebarPanel(
    h3("Preproc"),
    br(),
    radioButtons(
      inputId = "preproc_norm",
      label = "Normalise by sample median",
      choices = c("yes", "no"),
      selected = "yes",
      inline=T
    ),
    radioButtons(
      inputId = "preproc_impute",
      label = "Impute missing values (if any)",
      choices = c("no", "min", "median"),
      selected = "min",
      inline=T
    ),
    radioButtons(
      inputId = "preproc_trans",
      label = "Transform values (ignored if negative values found)",
      choices = c(no="identity", "sqrt", "log"),
      selected = "identity",
      inline = T
    ),
    radioButtons(
      inputId = "preproc_scale",
      label = "Scale variables",
      choices = c("no", "unit", "pareto"),
      selected = "no",
      inline = T
    ),
    uiOutput("preproc_remove_samples"),
    br(),
    actionButton(
      inputId = "preproc_go",
      label = "Go!"
    )
  ),
  mainPanel(
    verbatimTextOutput("preproc_summary") %>% 
      tagAppendAttributes(style= 'color:green;')
  )
)