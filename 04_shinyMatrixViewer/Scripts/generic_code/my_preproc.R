my_preproc = function(x, normalise_sample = F, impute_na = NULL, transform_matrix = NULL, scale_variables = NULL) {
  
  # save(list=ls(), file="prepro.RData")
  
  #' matrix x with samples in columns, variables in rows
  #' x must not contain NA or contstand rows and columns
  
  
  ## 1. normalise samples: divide by column median
  
  if(normalise_sample) {
    x %<>% 
      apply(2, function(y) {
        y / median(y, na.rm=T)
      })
  }
  
  ##  2. impute by row min (default)
  
  if(!is.null(impute_na)) { 
    
    if(impute_na == "min") {
      f = function(y) min(y, na.rm=T)*0.5
    } else if(impute_na == "median") {
      f = function(y) median(y, na.rm=T)
    }
    
    x %<>% 
      apply(1, function(y) {
        replace(y, is.na(y), f(y))
      }) %>% t()
  }
  
  ## 3. transform; only for positive
  
  if(!is.null(transform_matrix) && min(x, na.rm=T)>=0) {
    
    fun = match.fun(transform_matrix)
    
    if(min(x, na.rm=T)==0 && grepl("^log", transform_matrix)) {
      x %<>% add(1) 
    }
    
    x %<>% fun() 
  }
  
  ## 4. scale variables
  
  if(!is.null(scale_variables) && scale_variables %in% c("unit", "pareto")) {
    
    s = apply(x, 1, sd, na.rm=T)
    
    x %<>% t() %>% scale(scale = if(scale_variables == "pareto") sqrt(s) else s) %>% t()
    
  }
  
  return(x)
  
} 