

## wrapper
output$pca_click_plot_wrapper <- renderUI({
  
  plotOutput(
    "my_pca_clickable_plot", 
    click = "pca_plot_click",
    dblclick ="pca_plot_double_click",
    width = ifelse(is.null(input$pca_plot_width), 800, input$pca_plot_width),
    height = ifelse(is.null(input$pca_plot_height), 800, input$pca_plot_height)
  )
})



## render pca plot
output$my_pca_clickable_plot <- renderPlot({
  
  req(my_data$x1, input$pca_dim1, input$pca_dim2)
  
  pca = my_data$x1 %>% t() %>% prcomp()
  
  ## left join with meta data
  df = pca$x %>% as_tibble(rownames = "SAMPLE_ID") %>% 
    left_join(my_data$samples1, by="SAMPLE_ID")
  
  ## axes labels
  importance = summary(pca)$importance[2,]*100
  my_xlab = sprintf("%s (%.1f %s)", input$pca_dim1, importance[input$pca_dim1],"%")
  my_ylab = sprintf("%s (%.1f %s)", input$pca_dim2, importance[input$pca_dim2],"%")
  
  my_data$pca_plot =   
    my_scatter_plot(
      df, x_var = input$pca_dim1, y_var = input$pca_dim2, 
      col_var = input$pca_colour_cat, shape_var = input$pca_symbol_cat, size_var = input$pca_size_var, 
      base_size = input$pca_base_size, symbol_max_size = input$pca_symbol_size, x_lab = my_xlab, y_lab = my_ylab, 
      my_title = "PCA", colour_pal = input$pca_pal
    )
  
  my_data$pca_plot
  
})


####  click ####

observeEvent(
  input$pca_plot_click,
  {
    req(my_data$pca_plot)
    
    my_data$pca_click = 
      nearPoints(
        my_data$pca_plot$data, 
        input$pca_plot_click, 
        maxpoints = 1,
        threshold = 100
      ) %>%
      select_at(names(my_data$samples1))
    
    
  }
)

output$pca_click_table = renderTable({
  
  req(my_data$pca_click)
  
  my_data$pca_click
  
}, rownames = F)
