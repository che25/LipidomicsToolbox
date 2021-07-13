#### initialise ####
source("Scripts/initialise.R")

#### ui ####

ui <- fluidPage(
  # useShinyjs(),
  navbarPage(
    title = "Shiny Lipids Linear Model 1.0",
    theme = shinytheme("sandstone"),
    ## read input
    tabPanel(
      "Load", 
      source(file.path("Scripts/ui_code", "0100_ui_infile.R"),  local = TRUE)$value
    ),
    tabPanel(
      "Fit",
      source(file.path("Scripts/ui_code", "0300_ui_fit.R"),  local = TRUE)$value
    ),
    tabPanel(
      "Grid",
      source(file.path("Scripts/ui_code", "0400_ui_grid.R"),  local = TRUE)$value
    ),
    tabPanel(
      "Export",
      source(file.path("Scripts/ui_code", "0500_ui_outfile.R"),  local = TRUE)$value
    )
  )
)

server <- function(input, output, session) {
  
  #### reactive values ####
  my_data = reactiveValues()
  grid_ranges <- reactiveValues(x = NULL, y = NULL)

  #### infile ####
  source(file.path("Scripts/server_code", "0100_server_infile.R"),  local = TRUE)$value

  #### fit ####
  source(file.path("Scripts/server_code", "0300_server_fit.R"),  local = TRUE)$value
  source(file.path("Scripts/server_code", "0301_server_cv.R"),  local = TRUE)$value
  
  #### grid ####
  source(file.path("Scripts/server_code", "0400_server_grid.R"),  local = TRUE)$value
  
  #### grid ####
  source(file.path("Scripts/server_code", "0500_server_outfile.R"),  local = TRUE)$value
  
  
  #### exit ####
  source(file.path("Scripts/server_code", "1100_server_exit.R"),  local = TRUE)$value
  

} # end server 

shinyApp(ui, server)