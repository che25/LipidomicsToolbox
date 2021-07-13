observeEvent(
  input$infile_upload$datapath,
  {
    sh = readxl::excel_sheets(input$infile_upload$datapath)
    
    if("Samples" %in% sh && "Features" %in% sh) {
      
      my_data$samples = readxl::read_xlsx(input$infile_upload$datapath, "Samples")
      my_data$features = readxl::read_xlsx(input$infile_upload$datapath, "Features")
      my_data$sheet_names = sh %>% setdiff(c("Samples", "Features"))
    }
  }
)

output$infile_select_matrix = renderUI({
  
  req(my_data$sheet_names)
  
  selectInput(
    inputId = "infile_sheet",
    label = "Select matrix",
    choices = my_data$sheet_names 
  )
  
})

observeEvent(
  input$infile_sheet,
  {
    req(input$infile_sheet)
    
    my_data$x = readxl::read_xlsx(input$infile_upload$datapath, input$infile_sheet) %>% 
      select_at(my_data$samples$SAMPLE_ID) %>% 
      as.matrix() 
    
  }
)

output$infile_summary = renderPrint({
  
  if(!is.null(my_data$samples)) sprintf("Found Sample sheet with %d samples \n", nrow(my_data$samples)) %>% cat()
  if(!is.null(my_data$features)) sprintf("Found Features sheet with %d features \n", nrow(my_data$features)) %>% cat()
  if(!is.null(my_data$x)) {
    sprintf(
      "Data matrix `%s` selected with %d rows and %d columns", 
      input$infile_sheet, nrow(my_data$x), ncol(my_data$x)
    ) %>% cat()
  }
  
})