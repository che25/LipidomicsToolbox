sidebarLayout(
  sidebarPanel(
    h3("Input"),
    br(),
    br(),
    fileInput(
      inputId = "infile_pos_upload",
      label = "Upload pos file"
    ),
    fileInput(
      inputId = "infile_neg_upload",
      label = "Upload neg file"
    ),
    br(),
    actionButton(
      inputId = "infile_parse",
      label = "Parse"
    )
  ),
  mainPanel(
     verbatimTextOutput("infile_summary") %>% 
       tagAppendAttributes(style= 'color:green;')
  )
)