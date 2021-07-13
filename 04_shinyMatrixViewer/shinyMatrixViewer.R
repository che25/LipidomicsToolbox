#### initialise ####
source("Scripts/initialise.R")

#### ui ####

ui <- fluidPage(
  # useShinyjs(),
  navbarPage(
    title = "Shiny Matrix Viewer 1.0",
    theme = shinytheme("sandstone"),
    ## read input
    tabPanel(
      "Load", 
      source(file.path("Scripts/ui_code", "0100_ui_infile.R"),  local = TRUE)$value
    ),
    tabPanel(
      "Preproc",   
      source(file.path("Scripts/ui_code", "0200_ui_preproc.R"),  local = TRUE)$value
    ),
    tabPanel(
      "Heatmap",
      source(file.path("Scripts/ui_code", "0300_ui_heatmap.R"),  local = TRUE)$value
    ),
    tabPanel(
      "PCA",
      source(file.path("Scripts/ui_code", "0400_ui_pca.R"),  local = TRUE)$value
    )
  )
)

server <- function(input, output, session) {
  
  #### reactive values ####
  my_data = reactiveValues()

  #### infile ####
  source(file.path("Scripts/server_code", "0100_server_infile.R"),  local = TRUE)$value

  #### preproc ####
  source(file.path("Scripts/server_code", "0200_server_preproc.R"),  local = TRUE)$value

  #### heatmap ####
  source(file.path("Scripts/server_code", "0300_server_heatmap.R"),  local = TRUE)$value


  #### pca ####

  source(file.path("Scripts/server_code", "0400_server_pca_plot.R"),  local = TRUE)$value
  source(file.path("Scripts/server_code", "0401_server_pca_widgets.R"),  local = TRUE)$value
  
  
  #### exit ####
  source(file.path("Scripts/server_code", "1100_server_exit.R"),  local = TRUE)$value
  

} # end server 

shinyApp(ui, server)