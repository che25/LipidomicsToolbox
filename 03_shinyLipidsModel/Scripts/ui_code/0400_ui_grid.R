sidebarLayout(
  sidebarPanel(
    br(),
    tabsetPanel(
      id = "grid_tab",
      tabPanel(
        "Options",
        br(),
        with_pref(
          sliderInput,
          inputId = "grid_marker_size",
          label = "Node size",
          value = 10,
          min = 0.5,
          max = 20,
          step = 0.5
        ),
        with_pref(
          radioButtons,
          inputId="grid_text", 
          label="Show text label?",
          choices = c("yes", "no"),
          selected ="no",
          inline = T
        ),
        conditionalPanel(
          condition = "input.grid_text=='yes'",
          with_pref(
            sliderInput,
            inputId = "grid_label_size",
            label = "Text label size",
            value = 5,
            min = 0.5,
            max = 10,
            step = 0.5
          )
        ),
        with_pref(
          sliderInput,
          inputId = "grid_line_width",
          label = "Line width",
          value = 0.5,
          min = 0.5,
          max = 5,
          step = 0.25
        ),
        uiOutput("grid_col_var"),
        selectInput(
          inputId = "grid_node_pal",
          label = "Select node palette",
          choices = categorical_pal,
          selected = categorical_pal[1],
          multiple = F
        )
        
      ),
      #### more ####
      tabPanel(
        "More",
        br(),
        with_pref(
          sliderInput,
          inputId = "grid_plot_height",
          label = "Plot height (pixels)",
          value = 600,
          min = 300,
          max = 1500,
          step = 100
        ),
        with_pref(
          sliderInput,
          inputId = "grid_plot_width",
          label = "Plot width (pixels)",
          value = 600,
          min = 300,
          max = 1500,
          step = 100
        ),
        br(),
        downloadBttn(
          outputId = "grid_download_plot.png", 
          label = "Download plot"
        ),
        br()
        
      )
    )
  ),
  mainPanel(
    radioButtons(
      inputId = "grid_model",
      label = "Show model",
      choices = c("model0", "model1", "model2"),
      inline = T
    ),
    uiOutput("grid_plot_wrapper"),
    tableOutput("grid_click_table")
  )
)