#### initialise ####
source("Scripts/initialise.R")

#### ui ####

ui <- fluidPage(
  # useShinyjs(),
  navbarPage(
    title = "Shiny Lipid Search Matrix 1.0",
    theme = shinytheme("sandstone"),
    tabPanel(
      "Load", 
      source(file.path("Scripts/ui_code", "0100_ui_infile.R"),  local = TRUE)$value
    ),
    tabPanel(
      "Filter",
      source(file.path("Scripts/ui_code", "0200_ui_filter.R"),  local = TRUE)$value
    ),
    tabPanel(
      "Export",
      source(file.path("Scripts/ui_code", "0300_ui_outfile.R"),  local = TRUE)$value
    )
  )
)

server <- function(input, output, session) {
  
  
  #### reactive values ####
  my_pos_data = reactiveValues()
  my_neg_data = reactiveValues()
  my_lipids = reactiveValues()
  my_global = reactiveValues()
  grid_ranges <- reactiveValues(x = NULL, y = NULL)
  
  #### infile ####
  source(file.path("Scripts/server_code", "0100_server_infile.R"),  local = TRUE)$value

  #### filter ####
  source(file.path("Scripts/server_code", "0200_server_filter.R"),  local = TRUE)$value

  #### outfile ####
  source(file.path("Scripts/server_code", "0300_server_outfile.R"),  local = TRUE)$value
  
  #### exit ####
  source(file.path("Scripts/server_code", "1100_server_exit.R"),  local = TRUE)$value
  

} # end server 

shinyApp(ui, server)