#### clean cwd ####
wipe_global_env = T
if(wipe_global_env) rm(list=ls(envir = .GlobalEnv), envir = .GlobalEnv)

#### libraries ####

## fundamental
require(foreach)

## tidyverse
require(tidyverse)
require(magrittr)

## shiny
require(shiny)
require(shinythemes)
require(shinyWidgets)
# require(shinyjs)
require(DT)

## write xlsx
require(openxlsx)


## adducts and other MS stuff
require("enviPat")

#' using the enviPat functions
#' - subform
#' - mergeform
#' - check_chemform
#' 
#' doi:10.1021/acs.analchem.5b00941

data(isotopes, package = "enviPat", overwrite = T, envir = .GlobalEnv)
ISOTOPES = isotopes

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



