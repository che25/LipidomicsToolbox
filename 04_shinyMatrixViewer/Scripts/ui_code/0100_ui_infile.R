sidebarLayout(
  sidebarPanel(
    h3("Input"),
    br(),
    br(),
    fileInput(
      inputId = "infile_upload",
      label = "Upload excel file"
    ),
    uiOutput("infile_select_matrix")
  ),
  mainPanel(
    verbatimTextOutput("infile_summary") %>% 
      tagAppendAttributes(style= 'color:green;')
  )
)