set_a_pref_character = function(pref, nm, default, choices) {
  
  ## selectizeInput does not need the additional check (which if any of pref[[nm]] are in choices)
  ## However, better be on the safe side
  
  # cat(nm, "\n")
  # cat(choices)
  # cat("\n")
  # cat(pref[[nm]])
  # cat("\n")
  
  if(nm %in% names(pref)) {
    
    pr = pref[[nm]]
    
    
    ## legacy code when multiple selections were pasted together wth `;`
    if(any(grepl(";",pr))) 
      {
      pr = strsplit(pr, ";") %>% unlist 
    }
    
    ## legacy placeholders
    if(length(pr)>1) pr %<>% setdiff(c("None","none"))
    
    
    if(any(pr %in% choices)) {

      idx = which(pr %in% choices)
      
      return(pr[idx])
    }
  } 
  
  return(default)
}



set_a_pref_numeric = function(pref, nm, default, mini, maxi) {
  
  if(nm %in% names(pref) && pref[[nm]]<=maxi &&  pref[[nm]]>=mini) pref[[nm]] else default
  
}

set_a_pref_boolean = function(pref, nm, default) {
  
  if(nm %in% names(pref) && is.logical(pref[[nm]])) pref[[nm]] else default
  
}

with_pref = function(x, ...) {
  
  my_args = list(...)
  
  if("choices" %in% names(my_args)) {
    my_args$selected = 
      set_a_pref_character(
        MY_SHINY_PREFERENCES, 
        my_args$inputId, 
        my_args$selected, 
        my_args$choices
      )
  } else if("min" %in% names(my_args) && "max" %in% names(my_args)){
    my_args$value = 
      set_a_pref_numeric(
        MY_SHINY_PREFERENCES, 
        my_args$inputId, 
        my_args$value, 
        my_args$min, 
        my_args$max
      )
  } else {
    ## checkBoxInput
    my_args$value = 
      set_a_pref_boolean(
        MY_SHINY_PREFERENCES, 
        my_args$inputId, 
        my_args$value)
  }
  
  do.call(x, args=my_args)
}

my_as_logical = function(x) {
  
  if(is.na(x)) return()
  
  if(is.logical(x)) return(x)
  
  if(tolower(x) == "true") return(TRUE)
  
  if(tolower(x) == "false") return(FALSE)
  
  return()
  
}

my_read_shiny_prefs = function(filename="shiny_preferences.RDS") {
  
  x = readRDS(filename)
  
  ## convert a tibble into a named list and set the correct type
  ## x: tibble with columns name, value, class
  
  lapply(seq(nrow(x)) , function(i) switch(x$class[i],
                                           integer = lapply(x$value[i], as.integer),
                                           numeric = lapply(x$value[i], as.numeric),
                                           logical = lapply(x$value[i], my_as_logical),
                                           lapply(x$value[i], as.character) 
  ) %>% unlist
  ) %>% 
    setNames(x$name)
  
}

my_shiny_pref = function(my_input) {

  ## remove empty
  my_input = my_input[!sapply(my_input, is.null)]
  
  ## make_tibble
  input2 = tibble(name=names(my_input), value = my_input, class = lapply(my_input, class))
  
  ## filter
  input2 %>% 
    filter(
      ## remove action buttons etc 
      sapply(class, length)==1,
      ## remove selectized
      !grepl("selectized$",name)
    ) %>% 
    mutate(class = unlist(class)) %>% 
    ## remove file input
    filter(class!="data.frame") 
    # %>% 
    # mutate(value= sapply(value, function(x) paste(as.character(x), collapse=";")))
  
}
  
