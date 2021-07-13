
output$fit_class = renderUI({
  
  req(my_data$features)
  
  counter = 
    my_data$features %>% 
    group_by(Class) %>% 
    summarise(count = n(), .groups = "drop") %>% 
    filter(count>10) %>% 
    mutate(name = sprintf("%s (%d)", Class, count))
  
  selectInput(
    inputId = "fit_class",
    label = "Choose lipid class",
    choices = with(counter, Class %>% setNames(name))
  )
  
})

output$fit_ion = renderUI({
  
  req(my_data$features, input$fit_class)
  
  counter = 
    my_data$features %>% 
    filter(Class == input$fit_class) %>% 
    group_by(Ion) %>% 
    summarise(count = n(), .groups = "drop") %>% 
    mutate(name = sprintf("%s (%d)", Ion, count)) %>% 
    arrange(-count)
  
  ch = with(counter, Ion %>% setNames(name))
  
  selectInput(
    inputId = "fit_ion",
    label = "Choose Ion",
    choices = ch,
    selected = ch[1],
    multiple = T
  )
  
})

output$fit_decoration = renderUI({
  
  req(my_data$features, input$fit_class)
  
  counter = 
    my_data$features %>% 
    filter(Class == input$fit_class) %>% 
    group_by(decoration) %>% 
    summarise(count = n(), .groups = "drop") %>% 
    mutate(name = sprintf("%s (%d)", decoration, count)) %>% 
    arrange(-count)
  
  ch = with(counter, decoration %>% setNames(name))
  
  selectInput(
    inputId = "fit_decoration",
    label = "Choose decoration",
    choices = ch,
    selected = ch[1],
    multiple = T
  )
  
})



observeEvent(
  input$fit_go,
  {
    req(my_data$features)
    
    my_data$fit = 
      list(
        model = 
          my_data$features %>% 
          mutate(keep1 = T) %>% 
          my_fit_lm_lipid_class_wrapper(
            lipid_class = input$fit_class,
            ion_subset = input$fit_ion, 
            deco_subset = input$fit_decoration, 
            response_var_name = "Rt",
            mad_factor = input$fit_mad
          )
      )
    
    
    my_data$fit$bic = 
      tibble(
        name = paste0("model", 0:2),
        n = map_dbl(my_data$fit$model, ~nrow(.$plot_data)),
        AIC = map_dbl(my_data$fit$model, ~AIC(.$model)),
        BIC = map_dbl(my_data$fit$model, ~BIC(.$model))
      )

  }
)

output$fit_bic = renderTable({
  
  req(my_data$fit)
  
  my_data$fit$bic
  
})


output$fit_summary = renderPrint({
  
  req(my_data$fit)
  
  my_fit = my_data$fit$model[[input$fit_model]]
  
  sprintf(
    "formula: %s\n", 
    # my_fit$formula %>% deparse() %>% trimws() %>% paste(collapse = " ")
    my_fit$formula 
  ) %>% cat()
  
  sprintf(
    "data points: %d\n",
    my_fit$data %>% filter(keep1) %>% nrow()
  ) %>% cat()
  
  summary(my_fit$model)
  
})
