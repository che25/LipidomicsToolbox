#### parse ####

observeEvent(
  input$infile_pos_upload,
  {
    req(input$infile_pos_upload$datapath)
    
    out = my_lipid_search_matrix_parser(input$infile_pos_upload$datapath)
    if(is.null(my_global$order)) my_global$order = names(out)
    for(nm in names(out)) my_pos_data[[nm]] = out[[nm]]
        
  }
)

observeEvent(
  input$infile_neg_upload,
  {
    req(input$infile_neg_upload$datapath)
    
    out = my_lipid_search_matrix_parser(input$infile_neg_upload$datapath)
    if(is.null(my_global$order)) my_global$order = names(out)
    for(nm in names(out)) my_neg_data[[nm]] = out[[nm]]
    
  }
)

observeEvent(
  input$infile_parse,
  {

    for(nm in names(my_lipids)) my_lipids[[nm]] = NULL
    
    
    if(is.null(my_pos_data$Samples)) {
      if(!is.null(my_neg_data$Samples)) {
        for(nm in names(my_neg_data)) my_lipids[[nm]] = my_neg_data[[nm]]
      }
    } else {
      if(is.null(my_neg_data$Samples)) {
        for(nm in names(my_pos_data)) my_lipids[[nm]] = my_pos_data[[nm]]
      } else {
        out = my_merge_posneg(my_pos_data, my_neg_data)
        for(nm in names(out)) my_lipids[[nm]] = out[[nm]]
        
      }
    }
    
  }
)

output$infile_summary = renderPrint({
  
  do_something = input$infile_parse
  
  if(!is.null(my_pos_data$Samples)) sprintf("Positive mode dataset loaded \n") %>% cat()
  if(!is.null(my_neg_data$Samples)) sprintf("Negative mode dataset loaded \n") %>% cat()
  if(!is.null(my_neg_data$Samples) && !is.null(my_pos_data$Samples)) sprintf("Positive and negative mode datasets ready to merge \n") %>% cat()
  if(!is.null(my_lipids$Samples)) sprintf("Ready to proceed \n") %>% cat()

})


