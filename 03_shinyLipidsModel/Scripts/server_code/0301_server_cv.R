observeEvent(
  input$cv_go,
  {
    req(my_lipids$fit)
    
    my_lipids$fit$cv = 
      lapply(my_lipids$fit$model, my_cv_lm, cvmethod = input$cv_method, k = input$cv_k, r = input$cv_r)

  
  }
)

output$cv_summary = renderPrint({
  
  req(my_lipids$fit$cv)
  
  my_lipids$fit$cv %>% `[[`(input$fit_model) %>% print()
  
})