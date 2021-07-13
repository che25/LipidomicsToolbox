sidebarLayout(
  sidebarPanel(
    tabsetPanel(
      id="fit_panel",
      tabPanel(
        "Fit",
        br(),
        uiOutput("fit_class"),
        uiOutput("fit_ion"),
        uiOutput("fit_decoration"),
        br(),
        
        sliderInput(
          inputId = "fit_mad",
          label = "MAD factor for exclusion of outliers",
          value = 3.5,
          min = 0,
          max = 10,
          step = 0.5
        ),
        br(),
        actionButton(
          inputId = "fit_go",
          label = "Fit"
        )
      ),
      tabPanel(
        "CV",
        br(),
        radioButtons(
          inputId = "cv_method",
          label = "CV method",
          choices = c(`k-fold`="repeatedcv", `Leave-one-out`="loocv"),
          inline = T
        ),
        conditionalPanel(
          condition = "input.cv_method == 'repeatedcv'",
          sliderInput(
            inputId = "cv_k",
            label = "Number of folds (k)",
            value = 10,
            min = 2,
            max = 10,
            step = 1
          ),
          sliderInput(
            inputId = "cv_r",
            label = "Number of repeats",
            value = 1,
            min = 1,
            max = 10,
            step = 1
          )
        ),
        br(),
        actionButton(
          inputId = "cv_go",
          label = "Cross-val"
        )
      )
    )
  ),
  mainPanel(
    radioButtons(
      inputId = "fit_model",
      label = "Show model",
      choices = c("model0", "model1", "model2"),
      inline = T
    ),
    br(),
    conditionalPanel(
      condition = "input.fit_panel == 'Fit'",
      verbatimTextOutput("fit_summary") %>% 
        tagAppendAttributes(style= 'color:green;')
    ),
    conditionalPanel(
      condition = "input.fit_panel == 'CV'",
      verbatimTextOutput("cv_summary") %>% 
        tagAppendAttributes(style= 'color:green;')
    ),
    tableOutput("fit_bic")
  )
)