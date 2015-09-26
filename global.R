## Load libraries
library(shiny)
library(ggplot2)
library(dplyr)
library(ggvis)
library(leaflet)
library(RColorBrewer)
library(shinythemes)
library(grid)

## Set ggplot theme
theme_set(theme_bw())


# Source functions
source("functions.R")


# Load data
load("Erie.RData")
