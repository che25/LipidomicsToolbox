my_cv_lm = function(obj, cvmethod = "repeatedcv", k = 10, r = 5) {
  
  #' obj = my_lipids$fit
  #' using the caret package for cv 
  
  switch(
    cvmethod,
    repeatedcv = 
      {
        train_control = caret::trainControl(method = "repeatedcv", number = k, repeats = r)
      },
    loocv = 
      {
        train_control = caret::trainControl(method = "LOOCV")
      }
  )
  
  suppressWarnings(
    caret::train(
      obj$formula %>% as.formula(),   
      data = obj$data %>% filter(keep1),                        
      trControl = train_control,              
      method = "lm",                      
      na.action = na.pass
    ) 
  )
  
}

