#### parse ####

observeEvent(
  input$filter_go,
  {
    req(my_lipids$Features)
    
    #' first two conditions are independent of user settings
    
    my_lipids$Features %<>% 
      mutate(
        keep1 = 
          Polarity_check &
          (Polarity == "Pos" | Grade<=input$filter_neg_grade) &
          (Polarity == "Neg" | Grade<=input$filter_pos_grade) &
          (Polarity == "Pos" | Occupy>=input$filter_neg_occupy) &
          (Polarity == "Neg" | Occupy>=input$filter_pos_occupy) &
          (Polarity == "Pos" | PeakDataPoint>=input$filter_neg_points) &
          (Polarity == "Neg" | PeakDataPoint>=input$filter_pos_points) 
          
      )
  }
)

output$filter_summary = renderPrint({
  
  req(my_lipids$Features)
  
  c(
    sprintf("%d records retained (%.0f %s)\n\n", sum(my_lipids$Features$keep1), mean(my_lipids$Features$keep1*100), "%")
  ) %>% 
    cat(sep = "\n")
  
  my_lipids$Features %>% filter(keep1) %>% with(table(Polarity, Class)) %>% print()
  
})


