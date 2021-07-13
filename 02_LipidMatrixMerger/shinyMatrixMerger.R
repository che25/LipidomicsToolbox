#### initialise ####
source("Scripts/initialise.R")

#### ui ####

ui <- fluidPage(
  # useShinyjs(),
  navbarPage(
    title = "Shiny Merger 1.0",
    theme = shinytheme("sandstone"),
    ## read input
    tabPanel(
      "Load", 
      source(file.path("Scripts/ui_code", "0100_ui_infile.R"),  local = TRUE)$value
    ),
    tabPanel(
      "Merge",   
      source(file.path("Scripts/ui_code", "0200_ui_merge.R"),  local = TRUE)$value
    )
  )
)

server <- function(input, output, session) {
  
  #### reactive values ####
  my_data = reactiveValues()

  #### infile ####
  source(file.path("Scripts/server_code", "0100_server_infile.R"),  local = TRUE)$value

  #### mergec ####
  source(file.path("Scripts/server_code", "0200_server_merge.R"),  local = TRUE)$value

  
  #### exit ####
  source(file.path("Scripts/server_code", "1100_server_exit.R"),  local = TRUE)$value
  

} # end server 

shinyApp(ui, server)