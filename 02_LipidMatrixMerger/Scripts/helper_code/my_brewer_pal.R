my_brewer_pal = function(n, name) {
  
  if(n==0) return(c())
  
  if(name=="colour_wheel") return(gg_color_hue(n))
  
  n_max = 
    brewer.pal.info %>% 
    as_tibble(rownames = "pal") %>% 
    filter(pal==name) %$% 
    maxcolors 
  
  if(n<3) n=3
  
  if(n<=n_max) {
    brewer.pal(n, name)
  } else {
    crp = colorRampPalette(brewer.pal(n_max, name))
    crp(n)
  }
  
}

gg_color_hue <- function(n) {
  hues = seq(15, 375, length = n + 1)
  hcl(h = hues, l = 65, c = 100)[1:n]
}

