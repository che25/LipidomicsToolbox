
## categorical variable for colour
output$pca_colour_cat = renderUI({
  
  req(my_data$samples1)
  
  with_pref(
    selectizeInput,
    inputId="pca_colour_cat",
    label = "Colour variable",
    choices = my_data$samples1_cat,
    selected = NULL,
    multiple = T,
    options = list(
      'plugins' = list('remove_button', 'drag_drop'),
      'create' = TRUE,
      'persist' = FALSE,
      'placeholder' = 'pls choose one or more'
    )
  )
  
})


## categorical variable for symbol
output$pca_symbol_cat = renderUI({
  
  req(my_data$samples1_cat)
  
  with_pref(
    selectizeInput,
    inputId="pca_symbol_cat",
    label = "Shape variable",
    choices = my_data$samples1_cat,
    selected = NULL,
    multiple = T,
    options = list(
      'plugins' = list('remove_button', 'drag_drop'),
      'create' = TRUE,
      'persist' = FALSE,
      'maxItems' = 1, 
      'placeholder' = 'pls choose one'
    )
  )
})

## numerical variable for size
output$pca_size_var = renderUI({
  
  req(my_data$samples1_num)
  
  with_pref(
    selectizeInput,
    inputId="pca_size_var",
    label = "Size variable",
    choices = my_data$samples1_num,
    selected = NULL,
    multiple = T,
    options = list(
      'plugins' = list('remove_button', 'drag_drop'),
      'create' = TRUE,
      'persist' = FALSE,
      'maxItems' = 1, 
      'placeholder' = 'pls choose one'
    )
  )
})


## download ##

output$pca_download_button = renderUI({
  
  req(my_data$pca_plot)
  
  downloadButton(
    outputId = "pca_plot_download",
    label = "Download"
  )
  
  
})

output$pca_plot_download = 
  downloadHandler(
    filename = function() "pcaplot.png",
    content = function(file) {
      png(
        filename=file, 
        height=ifelse(is.null(input$pca_plot_height), 500, input$pca_plot_height), 
        width = ifelse(is.null(input$pca_plot_width), 500, input$pca_plot_width)
      )
      my_data$pca_plot %>% print()
      dev.off()
    }
  )
