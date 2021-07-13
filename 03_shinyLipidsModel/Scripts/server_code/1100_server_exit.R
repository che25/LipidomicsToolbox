onStop(function() {
  
  env = parent.env(environment())
  
  ls(envir = env) %>%
    ## .. excluding e.g. session" and "output"
    setdiff(c("session", "output")) %>%
    ## object in a list
    mget(envir = env) %>% 
    ## keep only reactive values
    subset(., subset = sapply(., is.reactivevalues)) %>% 
    ## convert reactive values
    sapply(function(z) isolate(reactiveValuesToList(z)), simplify=F) %>% 
    ## assign to global environment
    list2env(envir = .GlobalEnv)
  
  
  dirname = "Scripts/server_code/"
  
  for( fname in list.files(dirname , pattern = "\\.[rR]$")) {
    cat(fname, " ")
    source_functions_only2(file.path(dirname, fname))
  }
  
  cat("Session stopped\n")
}
)