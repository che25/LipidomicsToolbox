observeEvent(
  input$merge_go,
  {
    if(is.null(my_data$x)) return()
    
    keep_row = apply(my_data$x, 1, function(y) {
      sum(!is.na(y))>1 && sd(y, na.rm=T)!=0
    })
    
    keep_col = apply(my_data$x, 2, function(y) {
      sum(!is.na(y))>1 && sd(y, na.rm=T)!=0
    }) & (!colnames(my_data$x) %in% input$merge_remove_samples)
    
    my_data$samples1 = my_data$samples %>% filter(keep_col) 
    my_data$features1 = my_data$features %>% filter(keep_row) 
    
    if(nrow(my_data$samples1)==0 || nrow(my_data$features1)==0) {
      my_data$x1 = NA
    } else {
      my_data$x[keep_row, keep_col, drop=F] %>% 
        my_merge_lipids(
          mode = input$merge_mode,
          rt_tol = input$merge_tol, 
          my_fun = input$merge_function
        )
    }
  }
)

my_merge_lipids = function(x, mode,  rt_tol = NULL, my_fun="sum") {
  
  ## special treatment for ion: all adducts need to be within rt range
  gr = 
    switch(
      mode,
      lipid = {
        my_data$features1 %>% 
          select(LipidMolec, Rt, LipidIon) %>% 
          group_by(LipidMolec) %>% 
          mutate(Rt_good = diff(range(Rt))<rt_tol) %>% 
          ungroup() %>% 
          with(ifelse(Rt_good, LipidMolec, LipidIon))
      },
      group = my_data$features1$shortName,
      class = my_data$features1$Class
    )
  
  ## numeric columns - average
  f1 = my_data$features1 %>% 
    select_if(is.numeric) %>% 
    as.matrix() %>% 
    aggregate(list(LIPID_ID=gr), mean, na.rm=T) %>% 
    as_tibble()
  
  ## character columns - keep if only one value
  f2 = my_data$features1 %>% 
    select(-LIPID_ID) %>% 
    select_if(is.character) %>% 
    aggregate(list(LIPID_ID=gr), unique) %>% 
    as_tibble() %>% 
    select_if(is.character)
  
  ## count
  f3 = my_data$features1 %>% 
    select(COUNT = LIPID_ID) %>% 
    aggregate(list(LIPID_ID=gr), length) %>% 
    as_tibble()
  
  
  my_data$x1 = aggregate(x, list(LIPID_ID=gr), my_fun, na.rm=T) %>% 
    as_tibble()
  
  my_data$features1 = left_join(f2,f3, by="LIPID_ID") %>% left_join(f1, by="LIPID_ID")
  
  
}

output$merge_remove_samples = renderUI({
  
  req(my_data$samples)
  
  selectizeInput(
    inputId = "merge_remove_samples",
    label = "Select samples to be removed",
    choices = c(my_data$samples$SAMPLE_ID),
    selected = NULL,
    multiple = T,
    options = list(
      'plugins' = list('remove_button'),
      'create' = TRUE,
      'persist' = FALSE
      )
  )
  
  
})

output$merge_features = DT::renderDataTable({
  
  req(my_data$features1)
  my_data$features1
})
  

output$merge_summary = renderPrint({
  
  update = input$merge_go
  
  if(is.null(my_data$x1)) {
    cat("...")
  } else if(all(is.na(my_data$x1))) {
    cat("Matrix is empty. Aborting.")
  } else {
  
    isolate({
    
      sprintf("Processing sheet %s\n", input$infile_sheet) %>% cat()
      sprintf("Removing constant and NA rows and columns (if any).\n") %>% cat()
      sprintf("Kept %d/%d samples \n", nrow(my_data$samples1), nrow(my_data$samples)) %>% cat()
      sprintf("Kept %d/%d features \n", nrow(my_data$features1), nrow(my_data$features)) %>% cat()
      # sprintf("Normalisation: %s\n", input$merge_norm) %>% cat()
      # sprintf("Imputation: %s\n", input$merge_impute) %>% cat()
      # sprintf("Transformation: %s\n", input$merge_trans) %>% cat()
      # sprintf("Scaling: %s\n", input$merge_scale) %>% cat()
      
      
    })
  }

})

output$merge_download_wrapper = renderUI({
  
  req(my_data$x1)
  
  downloadButton(
    outputId = "merge_download",
    label = "Download"
  )
  
})



output$merge_download = 
  downloadHandler(
    filename = function() "lipid_merge.xlsx",
    content = function(file) {
      openxlsx::write.xlsx(list(my_data$samples1,my_data$features1, my_data$x1) %>% set_names(c("Samples", "Features", input$infile_sheet)), file, firstRow=T, firstCol=T)
    }
  )