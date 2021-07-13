
my_scatter_plot = function(
  df, x_var, y_var, 
  col_var = NULL, shape_var = NULL, size_var = NULL, colour_pal = "Dark2",
  base_size = 10, symbol_max_size = 6, x_lab = "x", y_lab = "y", my_title = "scatter"
) {
  
  #' df is a data frame
  #' xvar, yvar, colvar etc are all character
  #' col_var is allowed to be >length 1!

  ## https://stackoverflow.com/questions/19410781/problems-when-using-ggplot-aes-string-group-and-linetype/19415464#19415464
  inter = function(x) {
    if(is.null(x)) return()
    paste0(x, collapse = ", ") %>% sprintf("interaction(%s)", .)
  }
  
  inter2 = function(x) {
    if(is.null(x)) return()
    paste0(x, collapse = ":")
  }
  
  ## number of colours for palette
  if(is.null(col_var)) {
    # dummy value
    ncol = 3
  } else {
    ncol = df[col_var] %>% interaction() %>% nlevels()
  }
  
  
  ## ggplot
  gg = 
    ggplot(
      mapping=
        aes_string(
          x = x_var, 
          y = y_var, 
          colour = inter(col_var),
          shape = shape_var,
          size= size_var
        ),
      data = df
    ) 
  
  ## fixed or variable symbol size 
  if(is.null(size_var)) {
    gg = gg + geom_point(size = symbol_max_size)}
  else {
    gg = gg + geom_point() + scale_size(range = c(1, symbol_max_size))
    } 
  
  ## theme
  gg +
    theme_bw(base_size = base_size) + 
    theme(
      panel.grid.major = element_line(size = 0.5, linetype = 'solid', colour = "navy"), 
      panel.grid.minor = element_line(size = 0.25, linetype = 'solid', colour = "skyblue")
    ) +
    labs(title=my_title, x= x_lab, y= y_lab, colour = inter2(col_var)) +
    ## colorBrewer palettes extended to n colours
    scale_colour_manual(
      values = my_brewer_pal(ncol, colour_pal)
    )
  
}
