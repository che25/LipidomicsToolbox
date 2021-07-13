my_plot_grid  = function(obj, marker_size = 5, label_size = NAL, line_width = 1, col_var = "nDouble", node_pal = "Dark2") {
  
  save(list=ls(), file="tmp/gridplot.RData")
  
  x = obj$plot_data %>% 
    mutate(!!as.name(col_var):= as.factor(!!as.name(col_var)))
  ab = obj$ab
  
  brx = seq(min(x$nCarbon), max(x$nCarbon))
  pal_val = my_brewer_pal(obj$data %>% `[[`(col_var) %>% as.factor() %>% nlevels(), node_pal)
  
  ## main plot
  gg =  ggplot(
    data = x,
    mapping = aes(x=nCarbon, y=pseudoRt, colour = !!as.name(col_var), label=FattyAcid)
  ) +
    theme_bw() +
    theme(panel.grid.major.x = element_line(colour="black", size=0.5)) +
    scale_x_continuous(minor_breaks = NULL, breaks = brx) +
    scale_color_manual(values = pal_val) +
    labs(title= sprintf("%s", obj$class), y="adjusted Top Rt (min)")
  
  ## diagonal lines for double bond series
  if(!is.null(ab)) {
    gg = gg +
      geom_abline(
        data = ab, mapping=aes(slope=b, intercept=a), size = line_width
      ) 
  }
  
  ## points on top of grid and diagonal lines
  gg = gg  + geom_point(size=marker_size) 
  
  ## fatty acid text labels
  if(!is.na(label_size)) gg = gg + geom_text(colour = "black", size=label_size)
  
  return(gg)
}




