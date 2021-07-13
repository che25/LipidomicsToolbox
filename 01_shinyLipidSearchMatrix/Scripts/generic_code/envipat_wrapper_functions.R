data(isotopes)
ISOTOPES = isotopes


my_subtract_adduct = function(x) {
  
  left_join(
    x %>% select(Formula = IonFormula, Ion),
    adduct_list,
    by = c("Ion")
  ) %>% 
    mutate(Formula = gsub(" ", "", Formula) %>% my_check_formula()) %>% 
    group_by(Ion) %>% 
    mutate(
      ## note: subtracting mod formula
      Formula = subform(Formula, Formula_add[1])
    ) %>% 
    mutate(
      Formula = mergeform(Formula, Formula_ded[1])
    ) %>% 
    ungroup() %>% 
    with(Formula) 
  
}


my_calc_mz = function(x) {
  
  #' x is a tibble with columns FORMULA and ADDUCT
  
  x %>% 
    mutate(M = check_chemform(ISOTOPES %>% as.data.frame(), FORMULA)$monoisotopic_mass) %>% 
    left_join(ADDUCTS, by = c(ADDUCT="Name")) %>% 
    with(M/abs(Charge)+Mass)
  
}

my_check_formula = function(x) {
  
  check_chemform(as.data.frame(ISOTOPES), x) %>% 
    with(new_formula)
  
}





