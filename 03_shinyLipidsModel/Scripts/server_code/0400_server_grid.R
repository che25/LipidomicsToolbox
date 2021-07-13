observeEvent(
  c(
    input$fit_go
  ),
  {
    grid_ranges <- reactiveValues(x = NULL, y = NULL)
  }
)

output$grid_col_var = renderUI({
  
  req(my_data$fit)
  
  selectInput(
    inputId = "grid_col_var",
    label = "Select colour variable",
    choices = c("nDouble", "Ion", "decoration", "type", "polarity", "Filename"),
    selected = "nDouble",
    multiple = F
  )
  
  
})

#### plot ####

output$grid_plot_wrapper = renderUI({
  
  req(my_data$fit)
  
  plotOutput(
    outputId = "grid_plot",
    height = ifelse(is.null(input$grid_plot_height), 600, input$grid_plot_height),
    width = ifelse(is.null(input$grid_plot_width), 600, input$grid_plot_width),
    click = "grid_click",
    dblclick = "grid_dblclick",
    brush = brushOpts(
      id = "grid_brush",
      resetOnNew = TRUE
    )
  )
})


output$grid_plot = renderPlot({
  
  req(my_data$fit, input$grid_model)
  
  marker_size = ifelse(is.null(input$grid_marker_size), 5, input$grid_marker_size)
  line_width = ifelse(is.null(input$grid_line_width), 0.5, input$grid_line_width)
  node_pal = ifelse(is.null(input$grid_node_pal), "Accent", input$grid_node_pal)  
  col_var = ifelse(is.null(input$grid_col_var), "nDouble", input$grid_col_var)  
  
  
  
  my_data$grid = 
    my_plot_grid(
      obj = my_data$fit$model[[input$grid_model]], 
      marker_size = marker_size, 
      line_width = line_width, 
      label_size = ifelse(input$grid_text == "no", NA, input$grid_label_size), 
      col_var = col_var,
      node_pal = node_pal) 
  
  my_data$grid +
    coord_cartesian(xlim = grid_ranges$x, ylim = grid_ranges$y, expand = T)
})

#### click ####

observeEvent(
  input$grid_click,
  {
    req(input$grid_click)
    
    my_data$grid_click = 
      nearPoints(
        my_data$grid$data,
        input$grid_click, 
        maxpoints = 5,
        threshold = 100
      ) 
    
  }
)

output$grid_click_table = renderTable({
  
  req(my_data$grid_click)
  
  my_data$grid_click %>% 
    select(id, LipidIon, shortName, TopRT, deltaRt, pseudoRt, Grade)
  
})



observeEvent(
  input$grid_brush, 
  {
    req(input$grid_brush)
    brush <- input$grid_brush
    grid_ranges$x <- c(brush$xmin, brush$xmax)
    grid_ranges$y <- c(brush$ymin, brush$ymax)
  })


observeEvent(
  input$grid_dblclick, 
  {
    grid_ranges$x <- NULL
    grid_ranges$y <- NULL
  })

#### download ####

output$grid_download_plot.png <- {downloadHandler(
  
  filename = "grid_download_plot.png",
  content = function(file) {
    
    req(my_data$grid)
    
    png(file, height = input$grid_plot_height, width= input$grid_plot_width)
    my_data$grid %>% print()
    dev.off()
  }    
)}



