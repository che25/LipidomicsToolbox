sidebarLayout(
  sidebarPanel(
    tabsetPanel(
      tabPanel(
        title = "Var",
        br(),
        with_pref(
          selectInput,
          inputId="pca_dim1",
          label = "First dimension",
          choices = paste0("PC", 1:5),
          selected = "PC1",
          multiple = F,
          width = "200px"
        ),
        with_pref(
          selectInput,
          inputId="pca_dim2",
          label = "Second dimension",
          choices = paste0("PC", 1:5),
          selected = "PC2",
          multiple = F,
          width = "200px"
        ),
        uiOutput("pca_colour_cat"),
        uiOutput("pca_symbol_cat"),
        uiOutput("pca_size_var")
      ),
      tabPanel(
        title = "Par",
        br(),
        with_pref(
          sliderInput,
          inputId='pca_symbol_size', 
          label='Symbol size',
          value = 3,
          min = 1, 
          step = 0.1,
          max = 10
        ),
        
        with_pref(
          sliderInput,
          inputId='pca_base_size', 
          label='Text Size',
          value = 8,
          min = 1, 
          max = 30,
          step = 1
        ),
        
        with_pref(
          selectInput,
          inputId = "pca_pal",
          label = "Select palette",
          choices = c(categorical_pal),
          selected = "colour_wheel"
        )
      ),
      tabPanel(
        title = "Png",
        br(),
        
        with_pref(
          sliderInput,
          inputId='pca_plot_height', 
          label='Plot height (pixels)',
          value = 800,
          min = 300, 
          max = 1500,
          step = 100
        ),
        with_pref(
          sliderInput,
          inputId='pca_plot_width', 
          label='Plot width (pixels)',
          value = 800,
          min = 300, 
          max = 1500,
          step = 100
        ),
        br(),
        uiOutput("pca_download_button"),
      )
    )
  ),
  mainPanel(
    uiOutput("pca_click_plot_wrapper"),
    tableOutput("pca_click_table")
  )
)



