my_merge_posneg = function(pos, neg) {
  
  stopifnot(all(names(pos)==names(neg)))
  
    foreach(nm2 = names(pos)) %do% {

      if(nm2 == "Samples") {
        full_join(
          pos[[nm2]], neg[[nm2]],
          by = c("SAMPLE_ID", "GROUP_ID", "SAMPLE_TYPE"),
          suffix = c("_POS", "_NEG")
        ) %>% 
          select(SAMPLE_ID, GROUP_ID, SAMPLE_TYPE, everything())
      } else {
        bind_rows(
          pos[[nm2]] %>% mutate(LIPID_ID = sprintf("pos_%04d", LIPID_ID)), 
          neg[[nm2]] %>% mutate(LIPID_ID = sprintf("neg_%04d", LIPID_ID))
        )
      }

    } %>% set_names(names(pos))
  
}


my_lipid_search_matrix_parser = function(file_name, outname=NULL) {
  
  b = readLines(file_name)
  n = grep("^#", b) %>% max()
  
  xraw = read_delim(b %>% sub("\\t$", "", .), skip = n+1, delim = "\t", col_types = cols()) 
  
  h = b[1:n]
  
  h2 = h %>% subset(grepl("^#\\[", .))
  
  samp = 
    h2 %>% sub("^#", "", .) %>% strsplit(":") %>% Reduce(rbind, .) %>% 
    set_colnames(c("SAMPLE_ID", "FILE_NAME")) %>% 
    as_tibble() %>% 
    mutate(GROUP_ID = sub("^\\[(.*)-.*", "\\1", SAMPLE_ID)) %>% 
    mutate(SAMPLE_ID = gsub("(\\]|\\[)", "", SAMPLE_ID))
  
  s = samp$SAMPLE_ID
  
  mnames = xraw %>% names() %>% grep(s[1], ., value=T) %>% 
    sub(sprintf("\\[%s\\]", s[1]), "", .)
  
  l1 = foreach(m = mnames) %do% {
    
    xraw %>% select_at(sprintf("%s[%s]", m, s)) %>% set_names(s) %>% mutate(LIPID_ID = 1:n()) %>% select(LIPID_ID, everything())
    
  } %>% set_names(mnames %>% replace(., .=="S/N", "S_N"))
  
  
  control_group = grep("#control group:", h, value=T) %>% sub("#control group:", "", .)
  sample_groups = samp$GROUP_ID %>% unique() %>% setdiff(control_group)
  
  
  samp %<>%
    mutate(SAMPLE_TYPE = ifelse(GROUP_ID == control_group, "control", "sample"))
  
  gnames = xraw %>% names() %>% grep(sprintf("\\[%s/%s\\]", sample_groups[1], control_group), ., value=T) %>% 
    sub(sprintf("\\[%s/%s\\]", sample_groups[1], control_group), "", .)
  
  l2 = foreach(g = gnames) %do% {
    
    xraw %>% select_at(sprintf("%s[%s/%s]", g, sample_groups, control_group)) %>% set_names(sprintf("%s/%s", sample_groups, control_group)) %>% 
      mutate(LIPID_ID = 1:n()) %>% select(LIPID_ID, everything())
    
  } %>% set_names(gnames)
  
  
  first_group = xraw %>% names() %>% grep(sprintf("%s\\[%s/%s\\]", gnames[1], sample_groups[1], control_group), .)
  
  feat = xraw %>% select(seq(first_group-1)) %>% 
    mutate(LIPID_ID = 1:n()) %>% 
    select(LIPID_ID, everything()) %>% 
    my_lipid_search_parse_feature() %>% 
    mutate(
      Rt = l1$Rt %>% select(-LIPID_ID) %>% apply(1, median, na.rm=T),
      ObsMz = l1$ObsMz %>% select(-LIPID_ID) %>% apply(1, median, na.rm=T),
      Occupy = l1$Occupy %>%  select(-LIPID_ID) %>% apply(1, max, na.rm=T),
      PeakDataPoint = l1$PeakDataPoint %>%  select(-LIPID_ID) %>% apply(1, median, na.rm=T),
      Grade = l1$Grade %>% select(-LIPID_ID) %>% apply(1, function(z) z %>% subset(!is.na(.)) %>% min())
    )
  
  outlist = c(list(Samples = samp, Features = feat), l1, l2)
  
  if(!is.null(outname)) openxlsx::write.xlsx(outlist, outname, firstRow=T, firstCol=T)
  
  invisible(outlist)
  
  
}