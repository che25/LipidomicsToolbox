observeEvent(
  input$preproc_go,
  {
    if(is.null(my_data$x)) return()
    
    keep_row = apply(my_data$x, 1, function(y) {
      sum(!is.na(y))>1 && sd(y, na.rm=T)!=0
    })
    
    keep_col = apply(my_data$x, 2, function(y) {
      sum(!is.na(y))>1 && sd(y, na.rm=T)!=0
    }) & (!colnames(my_data$x) %in% input$preproc_remove_samples)
    
    my_data$samples1 = my_data$samples %>% filter(keep_col) 
    my_data$features1 = my_data$features %>% filter(keep_row) 
    
    if(nrow(my_data$samples1)==0 || nrow(my_data$features1)==0) {
      my_data$x1 = NA
    } else {
      my_data$x1 = my_data$x[keep_row, keep_col, drop=F] %>% 
        my_preproc(
          normalise_sample = input$preproc_norm == "yes", 
          impute_na = if(input$preproc_impute!="no") input$preproc_impute, 
          transform_matrix = input$preproc_trans, 
          scale_variables = input$preproc_scale
        )
      
      if(any(!is.finite(my_data$x1))) {
        my_data$Rowv = NULL
        my_data$Colv = NULL
      } else {
        my_data$Rowv = my_data$x1 %>% dist() %>% hclust() %>% as.dendrogram()
        my_data$Colv = my_data$x1 %>% t() %>% dist() %>% hclust() %>% as.dendrogram()
      }
      
      my_data$features1_cat = 
        my_data$features1 %>% 
          sapply(
            function(y) {
              if(!is.character(y)) return(F) 
              y1 = subset(y, !is.na(y))
              return(length(unique(y1)) > 1 && length(unique(y1)) < length(y1))
            }
          ) %>% which() %>% names()
      
      if(length(my_data$features1_cat) == 0) my_data$features1_cat = NULL

            my_data$samples1_cat = 
        my_data$samples1 %>% 
        sapply(
          function(y) {
            if(!is.character(y)) return(F) 
            y1 = subset(y, !is.na(y))
            return(length(unique(y1)) > 1 && length(unique(y1)) < length(y1))
          }
        ) %>% which() %>% names()
      
      if(length(my_data$samples1_cat) == 0) my_data$samples1_cat = NULL

      my_data$samples1_num = 
        my_data$samples1 %>% 
        sapply(
          function(y) {
            if(!is.numeric(y)) return(F) 
            all(is.finite(y))
          }
        ) %>% which() %>% names()
      
      if(length(my_data$samples1_num) == 0) my_data$samples1_num = NULL
      
    }
    
    
      
  }
)

output$preproc_remove_samples = renderUI({
  
  req(my_data$samples)
  
  selectizeInput(
    inputId = "preproc_remove_samples",
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


output$preproc_summary = renderPrint({
  
  
  update = input$preproc_go
  
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
      sprintf("Normalisation: %s\n", input$preproc_norm) %>% cat()
      sprintf("Imputation: %s\n", input$preproc_impute) %>% cat()
      sprintf("Transformation: %s\n", input$preproc_trans) %>% cat()
      sprintf("Scaling: %s\n", input$preproc_scale) %>% cat()
      
      
      if((min(my_data$x, na.rm=T)<0) && input$preproc_trans!="identity") {
        sprintf("Some negative values in original matrix. Transformation `%s` not carried out.\n", input$preproc_trans) %>% cat()
      }
      
      if(!all(is.finite(my_data$x1))) {
        sprintf("Some remaining missing or infinite values. Clustering and PCA not possible. Consider imputing them. \n") %>% cat()
      }
    })
  }

})