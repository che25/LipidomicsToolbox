sidebarLayout(
  sidebarPanel(
    h3("Heatmap"),
    tabsetPanel(
      id = "heatmap_tab",
      tabPanel(
        title = "Axes",
        br(),
        sliderInput(
          inputId = "heatmap_cexCol",
          label = "Resize x-labels",
          min = 0.1, max = 5, value = 1, step = .1
        ),
        sliderInput(
          inputId = "heatmap_cexRow",
          label = "Resize y-labels",
          min = 0.1, max = 5, value = 1, step = .1
        ),
        sliderInput(
          inputId = "heatmap_srtCol",
          label = "Angle of  x-labels",
          min = 0, max = 90, value = 90, step = 5
        ),
        sliderInput(
          inputId = "heatmap_margin1",
          label = "Margin for x-labels",
          min = 1, max = 50, value = 6, step = 1
        ),
        sliderInput(
          inputId = "heatmap_margin2",
          label = "Margin for y-labels",
          min = 1, max = 50, value = 6, step = 1
        )
        ),
      tabPanel(
        title = "Colour",
        br(),
        selectInput(
          inputId = "heatmap_palette",
          label = "Palette",
          choices = brewer.pal.info[brewer.pal.info$category != "qual",] %>% rownames(),
          selected = "Spectral"
        ),
        sliderInput(
          inputId = "heatmap_ncolour",
          label = "Number of colours",
          min = 5, max = 20, value = 10, step = 1
        )
      ),
      tabPanel(
        title = "Size",
        br(),
        sliderInput(
          inputId = "heatmap_height",
          label = "Height in pixels",
          min = 200, max = 2000, value = 600, step = 25
        ),
        sliderInput(
          inputId = "heatmap_width",
          label = "Width in pixels",
          min = 200, max = 2000, value = 600, step = 25
        ),
        sliderInput(
          inputId = "heatmap_lwid",
          label = "Relative size of left dendrogram",
          min = 0.1, max = 10, value = 1.5, step = 0.1
        ),
        sliderInput(
          inputId = "heatmap_lhei",
          label = "Relative size of top dendrogram",
          min = 0.1, max = 10, value = 1.5, step = 0.1
        )
      ),
      tabPanel(
        title = "Side",
        br(),
        h4("Columns"),
        radioButtons(
          inputId = "heatmap_colside",
          label = "Include sample factor",
          choices = c("no", "yes"),
          selected = "no",
          inline = T
        ),
        conditionalPanel(
          condition = "input.heatmap_colside == 'yes'",
          uiOutput("heatmap_colsidevar"),
          radioButtons(
            inputId = "heatmap_col_order",
            label = "Order columns by sample factor (and switch off dendro)",
            choices = c("no", "yes"),
            selected = "no",
            inline = T
          )
        ),
        radioButtons(
          inputId = "heatmap_coldend",
          label = "Show column dendrogram (if possible)",
          choices = c("no", "yes"),
          selected = "yes",
          inline = T
        ),
        tags$hr(style="border-color: black;"),
        h4("Rows"),
        radioButtons(
          inputId = "heatmap_rowside",
          label = "Include feature factor",
          choices = c("no", "yes"),
          selected = "no",
          inline = T
        ),
        conditionalPanel(
          condition = "input.heatmap_rowside == 'yes'",
          uiOutput("heatmap_rowsidevar"),
          radioButtons(
            inputId = "heatmap_row_order",
            label = "Order rows by feature factor (and switch off dendro)",
            choices = c("no", "yes"),
            selected = "no",
            inline = T
          )  
        ),
        radioButtons(
          inputId = "heatmap_rowdend",
          label = "Show row dendrogram (if possible)",
          choices = c("no", "yes"),
          selected = "yes",
          inline = T
        )
      )
    ), ## end tabset panel
    br(),
    br(),
    uiOutput("heatmap_download")
    
  ),
  mainPanel(
    uiOutput("heatmap_plot_wrapper")
  )
)