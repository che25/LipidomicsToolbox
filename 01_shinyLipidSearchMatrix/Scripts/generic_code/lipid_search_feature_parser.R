my_lipid_search_parse_feature =  function(x) {
  
  x %>% 
    ## this is maybe too restrictive
    select(-`Rej.`) %>% 
    mutate(
      decoration = get_decoration(FattyAcid),
      fa_numbers = get_fa_numbers(FattyAcid),
      LipidMolec = paste0(Class, FattyAcid),
      FattyAcid = FattyAcid %>% gsub("[dtmepO+()]", "", .)
    ) %>% 
    mutate(nCarbon = sapply(fa_numbers, first)) %>% 
    mutate(nDouble = sapply(fa_numbers, last)) %>% 
    ## modify Q FattyAcid only
    mutate(FattyAcid = ifelse(grepl("Q", FattyAcid), sprintf("%d:%d", nCarbon, nDouble), FattyAcid)) %>% 
    select(-fa_numbers) %>% 
    mutate(
      shortName = sprintf("%s %d:%d %s", Class, nCarbon, nDouble, decoration) %>% trimws(),
      decoration = decoration %>% replace(., .=="", NA) 
      ) %>% 
    mutate(
      Ion = sub(".*\\)(.*)$", "M\\1", LipidGroup) 
    ) %>% 
    left_join(
      adduct_list %>% select(Ion, Polarity),
      by = "Ion"
    ) %>% 
    mutate(
      Polarity_check = Polarity == table(Polarity) %>% which.max() %>% names(),
      keep1= Polarity_check
    ) %>%
    mutate(
      NeutralFormula = my_subtract_adduct(.)
      ) %>% 
    select(LIPID_ID, shortName, LipidMolec, Class, Ion, Polarity, nCarbon, nDouble, decoration, NeutralFormula, everything())
  
}

## decoration 
#' PX_ether = "e", of PC, PE ...
#' Cer_N_OH = "d", "t" what about "m"?
#' Cer_FA_OH = "+O"

get_decoration = function(fa) {
  
  fa %<>%  gsub("[()]", "", .)
  
  deco_name = 
    tibble(
      pat = c("e_", "^d", "^t", "^m", "+O$"),
      name = c("e", "d", "t", "m", "a"),
      long = c("PX_ether", "Cer_N_OH2",  "Cer_N_OH3", "Cer_N_OH1", "Cer_FA_OH")
    )
  
  lapply(seq(nrow(deco_name)), function(i) {
    
    ifelse(grepl(deco_name$pat[i], fa), deco_name$name[i], "")  

  }) %>% 
    Reduce(paste0, .) 
  
}



get_fa_numbers = function(fa) {
  
  fa %>% 
    gsub("[dtmepO+()]", "", .) %>% 
    strsplit("_") %>% 
    lapply(function(x) {
      if(any(grepl("Q", x))) {
        gsub("[(Q)]", "", x) %>% as.integer %>% multiply_by(c(5,1))
      } else {
        strsplit(x, split = ":") %>% 
          unlist %>% as.integer() %>% 
          matrix(byrow = T, ncol=2) %>% 
          colSums()
      }
    })
}




## this adduct list needs to be updated
adduct_list = 
  tibble(
    Ion = c("M+H-2H2O", "M+H","M+H-H2O","M+Na","M+NH4", "M-H", "M-CH3", "M+CH3COO", "M-2H"),
    Formula_add = c("H1", "H1", "H1", "Na1", "N1H4", "H0", "H0", "C2H3O2", "H0"),
    Formula_ded = c("H4O2", "H0", "H2O1", "H0", "H0", "H1", "C1H3", "H0", "H2"),
    Polarity = c(rep("Pos",5), rep("Neg",4))
  )
