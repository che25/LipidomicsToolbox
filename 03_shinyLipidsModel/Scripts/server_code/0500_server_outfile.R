output$outfile_download_wrapper = renderUI({
  
  req(my_data$fit$model)
  
  downloadButton(
    outputId = "outfile_download",
    label = "Export"
  )
  
})


output$outfile_download <- {downloadHandler(
  
  filename = "lipid_model_data.xlsx",
  content = function(file) {
    
    req(my_data$fit$model[[input$outfile_model]])
    
    m = my_data$fit$model[[input$outfile_model]]
    
    model_coef = m$model %>% coef() %>% {tibble(coef = names(.), value=.)}
    model_info = tibble(equation =  m$formula, lipid_class = input$fit_class)
    
    model_data = 
      switch(
        input$outfile_mode,
        no = m$data,
        mad = {m$plot_data %>% filter(!mad1 & !mad2)},
        threshold = {m$plot_data %>% filter(!mad1 & !mad2 & abs(deltaRt) < input$outfile_threshold)}
        )
    
    idx = which(m$plot_data$LIPID_ID %in% model_data$LIPID_ID)
    
    outlist = list(my_data$samples, model_data, my_data$x[idx,], model_info, model_coef) %>% 
      set_names(c("Samples", "Features", input$infile_sheet, "model_info", "model_coef"))
    
    openxlsx::write.xlsx(list(Sample = my_data$samples, Features = model_data, model_coef = model_coef, model_info = model_info), file = file)
  }    
)}