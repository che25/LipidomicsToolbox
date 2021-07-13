#### clean cwd ####
wipe_global_env = T
if(wipe_global_env) rm(list=ls(envir = .GlobalEnv), envir = .GlobalEnv)
assign("DEBUG", T, env = .GlobalEnv)

#### libraries ####

## fundamental
require(magrittr)
require(foreach)

## tidyverse
require(tibble)
require(readr)
require(dplyr)
require(tidyr) # unnest
require(purrr) # map
require(ggplot2)

## leaving out forcats and stringr

## shiny
require(shiny)
require(shinythemes)
require(shinyWidgets)
# require(shinyjs)
require(DT)

require(openxlsx)

## heatmap
require(RColorBrewer)

## cross-validation
require(caret)
require(matchingR)
require(modelr)
require(stringr)

#### options ####

## allow upload up to 500 MB
options(shiny.maxRequestSize=500*1024^2)

#### source ####

cat(getwd(), "\n")

## Scripts
for (pathdir in c("Scripts/helper_code", "Scripts/generic_code")) 
  for (f in list.files(pathdir, pattern="*.R")) f %>%  file.path(pathdir,.) %>% source 

#### prefs ####

## preferences as global variable
assign("MY_SHINY_PREFERENCES",
       if(file.exists("shiny_preferences.RDS")) my_read_shiny_prefs() else list(),
       envir = .GlobalEnv
)


assign(
  "categorical_pal",
  brewer.pal.info %>% 
    as_tibble(rownames = "pal") %>% 
    filter(category =="qual") %$% 
    pal,
  envir = .GlobalEnv
)

assign(
  "continuous_pal",
  brewer.pal.info %>% 
    as_tibble(rownames = "pal") %>% 
    filter(category !="qual") %$% 
    pal,
  envir = .GlobalEnv
)
