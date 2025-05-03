# Getting Started with R Script
# Follow along with this .R script for the codes necessary for today's exercise in the "Getting Started with R" class in the Umbrella Academy.

# Install Packages ----
# First, we install the packages we will need.
# Since you only need to install packages once, you don't need to write this step into your script; you can execute it directly in the console.
install.packages("tidyverse")
install.packages("gtExtras")
install.packages("viridis")
install.packages("readxl")

# Load Libraries ----
# Every R script should include some kind of header to describe the contents of the file, followed by loading of all the packages that will be used in the script

# I also think it's a good idea to include a little note next to each package so you remember what you used it for:
library(tidyverse) # This is a bundle of many packages for data manipulation and plotting, including the essential "ggplot2" for making plots
library(gtExtras) # Creates elegant summary tables
library(viridis) # Color palettes designed to improve graph readability for readers with common forms of color blindness (they also just look nice)
library(readxl) # Improves on Base-R's ability to read in datasets, especially those saved as Excel spreadsheets


# Load the Data ----
# Follow the instructions to download and save the dataset
# Then load it into R:
small_star_wars <- read_excel("input/small_star_wars.xlsx", na = "NA")

# Explore the Data ----
# Look at the structure
# *Hint* Remember when we learned about "tab to complete" last week?
# Try it here now with the "small_star_wars" variable name -- start typing "sma" and hit TAB.
str(small_star_wars)

# And summarize the dataset, first with `summary()`
summary(small_star_wars)

# Then with gtExtras, either
small_star_wars %>%
  gt()
# or
gt(small_star_wars)

# Now search for the theme options and pick one you like! 

# I like this one:
small_star_wars %>% 
  gt() %>% 
  gt_theme_pff()

##### Your themed `gt()` summary table goes here! #####



# Using `table()` ----
# Table for how many species are in our dataset
table(small_star_wars$species)

# Table for hair color and species
table(small_star_wars$hair_color, small_star_wars$species)

##### Your `table()` contingency table goes here! #####



# Plotting with ggplot2 ----
# Try running `ggplot()` alone:
ggplot()

# Making a simple bar plot of the heights of each character in our dataset:
ggplot(
  small_star_wars,
  aes(
    x=name,
    y=height
  )
) +
  geom_col()

# Coloring the bars by species:
ggplot(
  small_star_wars,
  aes(
    x=name,
    y=height,
    fill=species
  )
) +
  geom_col()

# Colorblind-friendly plot with cleaner background:
ggplot(
  small_star_wars,
  aes(
    x=name,
    y=height,
    fill=species
  )
) +
  geom_col() +
  scale_color_viridis(alpha=0.7, begin = 0, end = 1, option = "D", aesthetics = "fill", discrete = TRUE) +
  # `alpha` adds a bit of transparency, which makes it less harsh (ranges from 0.1 (very faint) to 1 (opaque))
  # `begin` and `end` specify the range of colors within the palette (ranges from 0-1)
  # `option` selects which of the 8 palettes to use
  # `aesthetics` tells us which of the `aes()` should map to this palette 
  # `discrete` specifies if the aesthetic is discrete or continuous
  theme_light()

# Ordering by descending height
ggplot(
  small_star_wars,
  aes(
    x=fct_reorder(name, desc(height)),
    y=height,
    fill=species
  )
) +
  geom_col() +
  scale_color_viridis(alpha=0.7, begin = 0, end = 1, option = "D", aesthetics = "fill", discrete = TRUE) +
  theme_light()


# Adding captions
ggplot(
  small_star_wars,
  aes(
    x=name,
    y=height,
    fill=species
  )
) +
  geom_col() +
  scale_color_viridis(alpha=0.7, begin = 0, end = 1, option = "D", aesthetics = "fill", discrete = TRUE) +
  theme_light() +
  labs(
    x="Character Name",
    y="Height (cm)",
    fill="Star Wars \nSpecies",
    title="Star Wars Character Height",
    subtitle="Character height (in cm) for six primary Star Wars characters, colored by species",
    # Add your name to the caption
    caption = "Created by me, <Your Name Here>!"
  )
 
