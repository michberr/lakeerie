
############## Server ####################

shinyServer(function(input, output, session) {
  
  ### Inputs ###
    
  ## Get reactive input from radio button for plot-type
  get_radio <- reactive ({
    choice = input$bp
  })
  
  ## Get reactive input from scroll bar for week
  get_date <- reactive({
    date = levels(Full$Date)[input$w]
  })
  
  
  ### Outputs ###
  
  ## Toxin plot output
  plotToxin <- reactive ({
    Full %>% 
      ggvis(~Date, ~ParMC, opacity := .4) %>%
      group_by(Station) %>%
      layer_lines() %>%
      layer_points(fill := "black", opacity := .4) %>%
      filter(Date == get_date()) %>%
      layer_points(fill := "red") %>%
      add_axis("y", title = "Toxin (ug/L)") %>%
      add_axis("x", title_offset = 40, properties = axis_props(
        labels = list(angle = 315, align = "right", fontSize = 12)
      )) %>%
      set_options(width = 420, height = 220) 
  })
  plotToxin %>% bind_shiny("toxinplot")


  
  
  ## Bacteria barplot output
  output$barplot <- renderPlot ({
    # Determine which button was selected
    type <- get_radio()
    
    # Determine which date was selected
    date <- get_date()
    
    # Make appropriate plot
    if(type == "A"){
      newdf <- get_week_data(Full, date)
      phylum_barplot(newdf)
    } else {
      newdf <- get_week_data(Cyano, date)
      cyano_barplot(newdf)
    }
    
  }, height = 500, width = 700)
  
  
  ## Map output
  output$map = renderLeaflet(map)
  
  ## Date output
  output$d <- renderText ({
    w <- get_date()
    w
  })

})

