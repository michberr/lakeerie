

#### Header #########

# Text that goes at the top of the app to explain algal blooms and how to use the app
makeHeader <- function() {
         list(
           p("On August 2nd, 2014, Toledo issued a",
             a("warning", href = "http://www.npr.org/2014/08/03/337476329/toledo-residents-told-cut-off-from-water-after-tests-revealed-toxins"),
             "to its 400,000 residents that the tap water was unsafe to drink due to high levels of the liver toxin microcystin.",
             "Microcystin in Lake Erie is produced by strains of", 
             a(em("Microcystis,"), href = "https://en.wikipedia.org/wiki/Microcystis"),
             "a genus of blooming Cyanobacteria (blue-green algae).",
             a("Harmful algal blooms", href = "http://oceanservice.noaa.gov/hazards/hab/"),
             "caused by",
             em("Microcystis"),
             "are an increasing annual threat to public health and the Lake Erie ecosystem."
           ),
           br(),
           p("Drag the sliding button or press the play button to examine week by week how the bacterial community and toxin levels changed on Lake Erie in 2014.
              Measurements were taken at three sites in the western basin depicted on the map.
              You can choose to view all the bacteria at each site, in which case you can observe seasonal shifts at a broader taxonomic level. 
              Or, you can view just the Cyanobacteria and gain finer taxonomic resolution of algal genera including",
             em("Microcystis.")
           )
         )
}



get_week_data <- function(df, week){
  weekdf <- subset(df, Date == week)
}


###### Plotting functions #######


# Theme elements for barplots
plot_theme <- theme(
  axis.text.x = element_text(
    angle = 50,
    color = "#a8a8a8",
    face = "bold", 
    vjust = 1, 
    hjust = 1, 
    size = 15
  ),
  axis.text.y = element_text(colour = "black", size = 10),
  axis.title.y = element_text(face = "bold", size = 16),
  legend.title = element_text(face = "bold", size = 16),
  legend.text = element_text(size = 14),
  strip.text.x = element_text(size = 16, face = "bold"),
  strip.text.y = element_text(size = 16, face = "bold"),
  strip.background = element_rect(color = "white", size = 2, fill = NA),
  plot.background = element_rect(fill = "white"),
  panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
  panel.border = element_rect(colour = "#a8a8a8", fill = NA, size = 1.5),
  panel.margin = unit(1, "lines")
) 


# Makes a barplot of all bacterial phyla
phylum_barplot <- function(df){
  ggplot(df, aes(x = Phylum, y = Abundance, fill = Phylum )) + 
    geom_bar(stat = "identity", alpha = 0.6) +
    scale_y_continuous(limits = c(0, 0.5)) +
    facet_grid(Station~.) +
    xlab("") +
    ylab("Relative Abundance\n") +
    scale_x_discrete(labels = c(Actinobacteria = "Ac", Armatimonadetes = "Ar",
                                Bacteroidetes = "B", Chlorobi = "Ch", Cyanobacteria = "Cy",
                                Planctomycetes = "Pl", Proteobacteria = "Pr",
                                Verrucomicrobia = "V")
    ) +
    scale_fill_brewer(type = "qual", palette = "Set2") + 
    plot_theme
}




# Makes a barplot of relative abundance of Cyanobacteria genera
cyano_barplot <- function(df){
  ggplot(df, aes(x = Genus, y = Abundance, fill = Genus)) + 
    facet_grid(Station~.) +
    scale_y_continuous(limits = c(0, 0.16)) +
    geom_bar(stat = "identity", alpha = 0.6) +
    scale_fill_brewer(type = "qual", palette = "Set2") +
    scale_x_discrete(labels = c(
      Anabaena = "A",
      Microcystis = "M",  
      Pseudanabaena = "Ps", 
      Synechococcus = "S",
      unclassified = "U"
    )
) +
    plot_theme +
    xlab("") +
    ylab("Relative Abundance\n")
}


makeToxinPlot <- function(date){
  Full %>% 
      ggvis(~Date, ~ParMC) %>%
      group_by(Station) %>%
      layer_lines() %>%
      layer_points(fill := "white", stroke := "grey", fillOpacity := .2, shape = ~Station) %>%
      filter(Date == date) %>%
      layer_points(fill := "red", fillOpacity := .2, shape = ~Station) %>%
      add_axis("y", title = "Toxin (ug/L)") %>%
      add_axis("x", title_offset = 40, properties = axis_props(
        labels = list(angle = 315, align = "right", fontSize = 12)
      )) %>%
      set_options(width = 420, height = 220) 
}



######## Map ####################

# Makes a leaflet map of the three sampling locations
map <- leaflet() %>%
  addTiles() %>%  # Add default OpenStreetMap map tiles
  addMarkers(lat = 41.7621666, lng = -83.33, popup = "WE2") %>%
  addMarkers(lat = 41.82666, lng = -83.193, popup = "WE4") %>%
  addMarkers(lat = 41.703166, lng = -83.25433, popup = "WE12 (Toledo)") %>%
  setView(zoom = 9, lat = 41.7621666, lng = -83.25433) 


