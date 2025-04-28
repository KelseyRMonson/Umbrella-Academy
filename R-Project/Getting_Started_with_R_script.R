# Getting Started with R Script
# Follow along with this .R script for the codes necessary for today's exercise in the "Getting Started with R" class in the Umbrella Academy.

# Install Packages ----
# First, we install the packages we will need. 
# Since you only need to install packages once, you don't need to write this step into your script; you can execute it directly in the console. 
install.packages("tidyverse")
install.packages("viridis")
install.packages("readxl")

# Load Libraries ----
# Every R script should include some kind of header to describe the contents of the file, followed by loading of all the packages that will be used in the script

# I also think it's a good idea to include a little note next to each package so you remember what you used it for:
library(tidyverse)  # This is a bundle of many packages for data manipulation and plotting, including the essential "ggplot2" for making plots
library(viridis)    # Color palettes designed to improve graph readability for readers with common forms of color blindness and/or color vision deficiency 
library(readxl)     # A package improving on Base-R's ability to read in datasets, especially those saved as Excel spreadsheets

# Load the Data ----
# Download the dataset from this path: "Umbrella-Academy/R-Project/input/small_star_wars.xlsx"
# Then create a folder in your own project directory called "input" and save the file there.

# Now you can load it in
small_star_wars <- read_excel("input/small_star_wars.xlsx", na="NA")
