output$outfile_go = downloadHandler(
  filename = function() "ls_matrix_outfile.xlsx",
  content = function(file) {
    
    outlist = my_lipids %>% 
      reactiveValuesToList() 
    
    if(input$outfile_filter == "filtered") {
      
      keep1 = outlist$Features$keep1
      for(nm in names(outlist) %>% setdiff("Samples")) {
        outlist[[nm]] = outlist[[nm]] %>% filter(keep1)
      }
    }
    

    openxlsx::write.xlsx(outlist[my_global$order], file)
    
  }
)