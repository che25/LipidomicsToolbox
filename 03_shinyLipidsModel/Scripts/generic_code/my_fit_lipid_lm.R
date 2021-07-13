my_fit_lm_lipid_class_wrapper = function(x, lipid_class, ion_subset, deco_subset, response_var_name = "TopRT",  plot_data = T, ...) {
  
  # save(list=ls(), file="wrapper.RData")
  
  if(is.null(deco_subset)) deco_subset = "-"
  deco_subset %<>% replace(., . == "NA", "-") 
  
  #### filter ####
  x %<>%
    mutate(decoration = ifelse(is.na(decoration), "-", decoration)) %>% 
    filter(
      Class == lipid_class,
      Ion %in% ion_subset,
      decoration %in% deco_subset
    )
  
  if(nrow(x)<10) return()
  
  N = x$FattyAcid %>% stringr::str_count(":") %>% unique()
  
  stopifnot("N not the same"= length(N) == 1)
  
  #### model1 predictors  ####
  
  model1_predict = 
    x$FattyAcid %>% 
    strsplit("[_:]") %>% 
    unlist() %>% 
    matrix(ncol = N*2, byrow=T) %>% 
    subset(select = seq(N)*2) %>% 
    set_colnames(sprintf("nDouble%d_as_factor_", seq(N))) 
  
  ## remove if there is only one level
  nl1 = model1_predict %>% apply(2, function(y) unique(y) %>% length())
  model1_predict %<>% subset(select = nl1>1)
  
  #### model 2 predictors ####
  nDouble_lev = model1_predict %>% as.vector %>% unique() %>% sort()
  
  model2_predict = foreach(i = nDouble_lev[-1], .combine = c) %do% {
    
    apply(model1_predict, 1, function(y) sum(y==i))
    
  } %>% 
    matrix(ncol = length(nDouble_lev)-1) %>% 
    set_colnames(sprintf("double_count_%s", nDouble_lev[-1]))
  
  
  #### complete predictor matrix
  x %<>% 
    bind_cols(
      model1_predict %>% as_tibble(),
      model2_predict %>% as_tibble()
    )
  
  #### predictor names ####
  
  ## optional factors
  predictor3 = character()
  
  if(length(unique(x$Ion))>1) {
    predictor3 %<>% c("Ion")
    x %<>%
      mutate(Ion = factor(Ion, levels = Ion %>% table() %>% sort(decreasing = T) %>% names()))
  }
    
  if(length(unique(x$decoration))>1) {
    predictor3 %<>% c("decoration") 
    x %<>%
      mutate(decoration = factor(decoration, levels = decoration %>% table() %>% sort(decreasing = T) %>% names()))
  }
  
  
  predictor1 = "nCarbon"
  predictor2 = 
    list(
    model0 = c("nDouble"),
    model1 = colnames(model1_predict),
    model2 = colnames(model2_predict)
  )
  
  #### calculate ####
  
  lapply(predictor2, function(pr2) {
    
    pr = c(predictor1, pr2, predictor3) 
    
    obj = my_fit_lm_lipid_class(x,  sprintf("%s ~ %s",response_var_name, pr %>% paste(collapse = " + ")), ...)
    
    if(plot_data) {
      obj$ab = my_ablines2(obj, predictor1, pr2, predictor3)
      
      obj$plot_data = my_make_plot_data(obj, predictor3)
    }

    return(obj)
    
  })
}

my_make_plot_data = function(obj, pr3) {
  
  m = obj$model
  x = x2 = obj$data %>% filter(keep1)
  
  ## get rid off contributions of some factors
  for(v in pr3) x2 %<>% mutate(!!as.name(v) := m$xlevels[[v]][1])
  
  x2 %<>% mutate(pseudoRt = predict(m, .) + deltaRt) %>% 
    select(LIPID_ID, pseudoRt)
   
  left_join(x, x2, by="LIPID_ID")
  
}

my_ablines2 = function(obj, pr1, pr2, pr3) {
  
  m = obj$model
  x = obj$data %>% filter(keep1)
  
  ## for all combinations of the model variables pertaining to double bonds
  x2 = x %>% select_at(pr2) %>% 
    unique() 
  
  ## create dummy variables to calculate offset
  for(v in pr1) x2 %<>% mutate(!!as.name(v) := 0)
  for(v in pr3) x2 %<>% mutate(!!as.name(v) := m$xlevels[[v]][1])
  
   x2 %>% 
    mutate(
      a = predict(m, .),
      b = coef(m)[pr1]
    )
}

## this is the version to use
#' - only removes outliers, global and local
#' - fits with many data points
#' - iteration may converge on a cycle; need hard criterion to stop; at the moment r<10
#' - should pick model with best BIC
#' - could also simply abort after BIC does not become more negative; I am worried that this could stop the process prematurely

my_fit_lm_lipid_class = function(x, formula1, mad_factor=3.5, verbose=T) {
  
  reponse_var = formula1 %>% strsplit("~") %>% sapply(first) %>% trimws()
  
  if(verbose) sprintf("Mad factor = %.1f\nFormula = %s\n", mad_factor, formula1) %>% cat()
  
  # save(list = ls(), file = "fit.RData")
  
  x %<>% 
    mutate(keep1 = T)
  
  r = 0
  keep1_old = !x$keep1
  MAD = 1
  mm = model.matrix(formula(formula1), x)
  
  
  while(!identical(keep1_old, x$keep1) && r<10 && MAD>0.01) {
    
    keep1_old = x$keep1
    
    m = lm(formula1, data = x %>% filter(keep1))
    
    # rmsd = mean(residuals(m)^2) %>% sqrt()
    # RSE = m %>% {sum(residuals(.)^2) / df.residual(.)} %>% sqrt()
    RSE = summary(m)$sigma
    R2 = summary(m)$r.squared
    MED = m %>% residuals() %>% median()
    MAD = m %>% residuals() %>% mad(constant = 1)
    
    if(verbose) sprintf(
      "Round %02d n = %3d R2 = %.3f, RSE=%.3f, MAD = %.3f, BIC = % .2f \n",
      r, sum(keep1_old), R2, RSE, MAD, BIC(m)
    ) %>% cat()
    
    #### select for next round ####
    
    ## predict; absent levels are NA
    
    x %<>%
      mutate(
        predRt = my_simple_predict2(mm, m),
        deltaRt = !!as.name(reponse_var) - predRt,
        mad1 =  abs(deltaRt-MED) > MAD* mad_factor
      ) %>%
      group_by(Class, FattyAcid)%>%
      mutate(mad2 = my_mad_outlier2(deltaRt, mad_factor)) %>%
      ungroup() %>%
      mutate(keep1 = !mad1 & !mad2)
    
    r = r+1
    
  }
  
  return(list(data = x, model=m, R2=R2, RSE=RSE, MAD=MAD, formula = formula1))
  
  
}

my_mad_outlier2 = function(x, mad_factor) {
  
  abs(x - median(x)) > mad(x, constant=1)*mad_factor + 1e-10
  
}

my_simple_predict2 = function(mm, m) {
  
  cf = m$coefficients %>% subset(., !is.na(.))
  
  as.vector(mm[,names(cf)] %*% cf)
  
  
}


