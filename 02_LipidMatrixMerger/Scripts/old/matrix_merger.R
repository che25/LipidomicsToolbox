my_combine_lipids = function(mode,  rt_tol = NULL, my_fun="sum") {
  
  ## special treatment for ion: all adducts need to be within rt range
  switch(
    mode,
    lipid = {
      gr = my_data$features %>% 
        select(LipidMolec, Rt, LipidIon) %>% 
        group_by(LipidMolec) %>% 
        mutate(Rt_good = diff(range(Rt))<rt_tol) %>% 
        ungroup() %>% 
        with(ifelse(Rt_good, LipidMolec, LipidIon))
    },
    group = my_data$features$shortName,
    class = my_data$features$Class
  )
  
  ## numeric columns - average
  f1 = my_data$features %>% 
    select_if(is.numeric) %>% 
    as.matrix() %>% 
    aggregate(list(LIPID_ID=gr), mean, na.rm=T) %>% 
    as_tibble()
  
  ## character columns - keep if only one value
  f2 = my_data$features %>% 
    select(-LIPID_ID) %>% 
    select_if(is.character) %>% 
    aggregate(list(LIPID_ID=gr), unique) %>% 
    as_tibble() %>% 
    select_if(is.character)
  
  ## count
  f3 = my_data$features %>% 
    select(COUNT = LIPID_ID) %>% 
    aggregate(list(LIPID_ID=gr), length) %>% 
    as_tibble()
  
  
  my_data$x1 = aggregate(x, list(LIPID_ID=gr), my_fun, na.rm=T) %>% 
    as_tibble()
  
  my_data$features1 = left_join(f2,f3, by="LIPID_ID") %>% left_join(f1, by="LIPID_ID")
  
  
}