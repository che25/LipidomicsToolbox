output$heatmap_plot_wrapper = renderUI(
  {
    
    req(my_data$x1)
    
    plotOutput(
      outputId = "heatmap_plot",
      height = ifelse(is.null(input$heatmap_height), 600, input$heatmap_height),
      width = ifelse(is.null(input$heatmap_width), 600, input$heatmap_width)
      
    )
    
  }
)

output$heatmap_plot = renderPlot({
  
  req(my_data$x1)
  
  heatmap_function()
  
})


heatmap_function = function() {
  
  x = my_data$x1
  
  ## palette 
  
  pal = my_brewer_pal(
    n = ifelse(is.null(input$heatmap_ncolour), 10, input$heatmap_ncolour),
    name = ifelse(is.null(input$heatmap_palette), "Spectral", input$heatmap_palette)
  )
  
  ## row colours and column colours for side row
  
  if(is.null(input$heatmap_colsidevar) || input$heatmap_colsidevar == "none") {
    cc = NULL
  } else {
    f = my_data$samples1[[input$heatmap_colsidevar]] %>% as.factor()
    cc = my_brewer_pal(nlevels(f), "Dark2")[f] %>% replace(., is.na(.), "#FFFFFF")
  }
  
  if(is.null(input$heatmap_rowsidevar) || input$heatmap_rowsidevar == "none") {
    rc = NULL
  } else {
    f = my_data$features1[[input$heatmap_rowsidevar]] %>% as.factor()
    rc = my_brewer_pal(nlevels(f), "Dark2")[f] %>% replace(., is.na(.), "#FFFFFF")
  }
  
  ## show precalculated dendrograms
  
  colv = if(input$heatmap_coldend == "yes") my_data$Colv else NULL
  rowv = if(input$heatmap_rowdend == "yes") my_data$Rowv else NULL
  
  ## reorder and switch dendrogram off
  
  if(!is.null(input$heatmap_colsidevar) && input$heatmap_colsidevar != "none" && input$heatmap_col_order=="yes") {
    colv = NULL
    coli = my_data$samples1 %>% mutate(idx = 1:n()) %>% arrange_at(input$heatmap_colsidevar) %>% with(idx)
    x = x[,coli]
    cc = cc[coli]
  }
  
  if(!is.null(input$heatmap_rowsidevar) && input$heatmap_rowsidevar != "none" && input$heatmap_row_order=="yes") {
    rowv = NULL
    rowi = my_data$features1 %>% mutate(idx = 1:n()) %>% arrange_at(input$heatmap_rowsidevar) %>% with(idx)
    x = x[rowi,]
    rc = rc[rowi]
  }
  
  dend = if(is.null(colv)) {if(is.null(rowv)) "none" else "row"} else {if(is.null(rowv)) "col" else "both"} 
  
   my_heatmap.2(
    x,  
    cc = cc,
    rc = rc,
    trace = "none", 
    Colv = colv,
    Rowv = rowv,
    dendrogram = dend,
    cexCol = ifelse(is.null(input$heatmap_cexCol), 1, input$heatmap_cexCol),
    cexRow = ifelse(is.null(input$heatmap_cexRow), 1, input$heatmap_cexRow),
    srtCol = ifelse(is.null(input$heatmap_srtCol), 90, input$heatmap_srtCol),
    margins = c(
      ifelse(is.null(input$heatmap_margin1), 6, input$heatmap_margin1), 
      ifelse(is.null(input$heatmap_margin2), 6, input$heatmap_margin2)
    ),
    col = pal,
    symbreaks = F,
    symkey = F,
    denscol = "black",
    key.title = "",
    key.xlab = "",
    key.ylab = "",
    lwid = c(ifelse(is.null(input$heatmap_lwid), 1.5, input$heatmap_lwid),4), 
    lhei = c(ifelse(is.null(input$heatmap_lhei), 1.5, input$heatmap_lhei),4),
    main = input$infile_sheet
  )
  
}

output$heatmap_download = renderUI({
  
  req(my_data$x1)
  
  downloadBttn(
    outputId = "heatmap.png",
    label = "Download png",
    style = "jelly", 
    color = "success", 
    size = "sm"
  )
})


output$heatmap.png = 
  downloadHandler(
    filename = function() "heatmap.png",
    content = function(file) {
      png(
        filename=file, 
        height=ifelse(is.null(input$heatmap_height), 500, input$heatmap_height), 
        width = ifelse(is.null(input$heatmap_width), 500, input$heatmap_width)
      )
      heatmap_function()
      dev.off()
    }
  )

output$heatmap_colsidevar = renderUI({
  
  req(my_data$samples1) 
  
  selectInput(
    inputId = "heatmap_colsidevar",
    label = "Select factor",
    choices = c("none", my_data$samples1_cat)
  )
  
  
})

output$heatmap_rowsidevar = renderUI({
  
  req(my_data$features1) 
  
  selectInput(
    inputId = "heatmap_rowsidevar",
    label = "Select factor",
    choices = c("none", my_data$features1_cat)
  )
  
  
})
