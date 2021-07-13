my_combine_lipid_class = function() {
  
  gr = paste(my_data$features$Class, my_data$features$decoration, sep="::") %>% sub("::NA", "", .)

  ## area
  my_data$x1 = my_data$x = aggregate(x, list(LIPID_ID=gr), sum, na.rm=T) %>% 
    as_tibble()
  
  ## numeric columns
  f1 = my_data$features %>% 
    select_if(is.numeric) %>% 
    as.matrix() %>% 
    aggregate(list(LIPID_ID=gr), mean, na.rm=T) %>% 
    as_tibble()
  
  f2 = my_data$features %>% 
    select(Class, decoration) %>% 
    aggregate(list(LIPID_ID=gr), first) %>% 
    as_tibble()
  
  f3 = my_data$features %>% 
    select(COUNT = LIPID_ID) %>% 
    aggregate(list(LIPID_ID=gr), length) %>% 
    as_tibble()
  
  my_data$features1 = left_join(f2,f3, by="LIPID_ID") %>% left_join(f1, by="LIPID_ID")

  
}


my_combine_lipid_group = function() {
  
  gr = my_data$features$shortName
  
  ## area
  my_data$x1 = my_data$x = aggregate(x, list(LIPID_ID=gr), sum, na.rm=T) %>% 
    as_tibble()
  
  ## numeric columns
  f1 = my_data$features %>% 
    select_if(is.numeric) %>% 
    as.matrix() %>% 
    aggregate(list(LIPID_ID=gr), mean, na.rm=T) %>% 
    as_tibble()
  
  f2 = my_data$features %>% 
    select(Class, decoration, NeutralFormula) %>% 
    aggregate(list(LIPID_ID=gr), first) %>% 
    as_tibble()
  
  f3 = my_data$features %>% 
    select(COUNT = LIPID_ID) %>% 
    aggregate(list(LIPID_ID=gr), length) %>% 
    as_tibble()
  
  my_data$features1 = left_join(f2,f3, by="LIPID_ID") %>% left_join(f1, by="LIPID_ID")
  
  
  
}

my_combine_lipid_adduct = function(rt_tol = NULL, my_fun="sum") {
  
  ## make the same if Rt is within tol
  gr = my_data$features %>% 
    select(LipidMolec, Rt, LipidIon) %>% 
    group_by(LipidMolec) %>% 
    mutate(Rt_good = diff(range(Rt))<rt_tol) %>% 
    ungroup() %>% 
    with(ifelse(Rt_good, LipidMolec, LipidIon))

  
  # f2 = my_data$features %>% 
  #   select(shortName, Class, decoration, NeutralFormula, FattyAcid) %>% 
  #   aggregate(list(LI=gr), first) %>% 
  #   as_tibble()
  
  ## numeric columns
  f1 = my_data$features %>% 
    select_if(is.numeric) %>% 
    as.matrix() %>% 
    aggregate(list(LIPID_ID=gr), mean, na.rm=T) %>% 
    as_tibble()
  
  ## make unique and keep if length == 1
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
  
  
}


