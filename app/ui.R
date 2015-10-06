
###### Shiny UI #############

shinyUI(fluidPage( theme = shinytheme("flatly"),

  # Makes pretty header with title of App 
  withTags({
    div(class="header",style = "background-color: #428bca; height:70px;",
      div(class="container brand", style = "font-size: 40px;",
        a(class="span12", style = "color:white;", "Lake Erie Algal Bloom 2014")
      )
    )
  }),

  # Makes intro paragraph introducing algal blooms and how to use app
  tags$div(class = "container", style = "font-size: 25px; padding-top: 30px;", 
      makeHeader(),
    
      br(),
      
      fluidRow(
        
        # Left side of page
        column(5,
          h3("Explore"),
          wellPanel(
            
            # Creates slider for week that data was taken, includes animation button
            sliderInput("w", "Week",
                        min = 1, max = 20, value = 1,
                        animate = animationOptions(interval=3000, loop=T)
            ),
            
            # Creates radio button to choose to view all bacteria or just cyanobacteria in barplot
            radioButtons("bp", 
                         label = h3("Barplot"),
                         choices = list("All Bacteria" = "A", "Cyanobacteria" = "B"),
                         selected = "A"
            ),
            
            # Creates plot of toxin levels highlighting the current week from the slider in red
            h3("Toxin levels"),
            ggvisOutput("toxinplot")
          ), 
          br()
        ),   
        
        # Right side of page
        column(7,
          
          # Bar that prints out current date based on week slider      
          h3("Date:"),
          wellPanel(
            textOutput("d")
          ),
          
          # Plots bacterial composition based on week 
          h3("Bacterial Composition"),
          plotOutput('barplot')
        ),
        
        # Bottom row: Prints out map of stations
        leafletOutput('map'),
        br()
      )
    )
  
)) ## End parens    
    

    
    
  
  

    


