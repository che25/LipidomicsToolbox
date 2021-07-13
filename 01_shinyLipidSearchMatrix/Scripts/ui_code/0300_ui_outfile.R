sidebarLayout(
  sidebarPanel(
    h3("Export"),
    radioButtons(
      inputId = "outfile_filter",
      label= "Exported features",
      choices = c("all", "filtered"),
      selected = "all"
    ),
    br(),
    downloadButton(
      outputId = "outfile_go",
      label = "outfile"
    )
  ),
  mainPanel(
    verbatimTextOutput("outfile_summary") %>% 
      tagAppendAttributes(style= 'color:green;')
  )
)