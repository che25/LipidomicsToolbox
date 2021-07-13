source_functions_only2 =  function(file) {
  try(
    {
      MyEnv<-new.env()
      assign("output", list(), envir = MyEnv)
      source(file=file,local=MyEnv)
      list2env(Filter(f=is.function,x=as.list(MyEnv)),
               envir=.GlobalEnv)
    }, 
    silent = T
  )
}