# Getting Started with R Script
# Follow along with this .R script for the codes necessary for today's exercise in the "Getting Started with R" class in the Umbrella Academy.

# Install Packages ----
# First, we install the packages we will need.
# Since you only need to install packages once, you don't need to write this step into your script; you can execute it directly in the console.
install.packages("tidyverse")
install.packages("gtExtras")
install.packages("viridis")
install.packages("readxl")
install.packages("pheatmap")

# Load Libraries ----
# Every R script should include some kind of header to describe the contents of the file, followed by loading of all the packages that will be used in the script

# I also think it's a good idea to include a little note next to each package so you remember what you used it for:
library(readxl) # Improves on Base-R's ability to read in datasets, especially those saved as Excel spreadsheets
library(tidyverse) # This is a bundle of many packages for data manipulation and plotting, including the essential "ggplot2" for making plots
library(gtExtras) # Creates elegant summary tables
library(viridis) # Color palettes designed to improve graph readability for readers with common forms of color blindness (they also just look nice)
library(pheatmap) # Creates heatmaps

# Load the Data ----
# Follow the instructions to download and save the dataset
# Then load it into R:
small_star_wars <- read_excel("input/small_star_wars.xlsx", na = "NA")

# Explore the Data ----
# Look at the structure
str()
# *Hint* Remember when we learned about "tab to complete" last week?
# Try it here now with the "small_star_wars" variable name -- start typing "sma" and hit TAB.

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


##### Your plot with a bespoke color scheme goes here! #####



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


# Adding labels -- update your name in the caption!
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

# Fun with bar plots ----
# Using geom_bar()
ggplot(
  small_star_wars,
  aes(
    x = fct_reorder(species, desc(height)),
    y = height,
    fill= species
  )
) +
  geom_bar(stat="identity") +
  scale_fill_viridis(option = "C", begin = 0.1, end = 0.9, discrete=TRUE) +
  theme_light() +
  labs(
    x = "Species",
    y = "Height (cm)",
    fill = "Species"
  )

# Stacked bar plot
ggplot(
  small_star_wars,
  aes(
    x = fct_reorder(species, desc(height)),
    y = height,
    fill= name
  )
) +
  geom_bar(stat="identity") +
  scale_fill_viridis(option = "C", begin = 0.1, end = 0.9, discrete=TRUE) +
  theme_light() +
  labs(
    x = "Species",
    y = "Height (cm)",
    fill = "Species"
  )

# Adjacent bar plots
ggplot(
  small_star_wars,
  aes(
    x = fct_reorder(species, desc(height)),
    y = height,
    fill= fct_reorder(name, desc(height))
  )
) +
  geom_bar(stat="identity", position="dodge") +
  scale_fill_viridis(option = "C", begin = 0.1, end = 0.9, discrete=TRUE) +
  theme_light() +
  labs(
    x = "Species",
    y = "Height (cm)",
    fill = "Species"
  )
 
# Percentage bar plot
ggplot(
  small_star_wars,
  aes(
    x = species,
    fill= sex
  )
) +
  geom_bar(position="fill") +
  scale_y_continuous(labels = scales::percent) +
  scale_fill_viridis(option = "C", begin = 0.1, end = 0.9, discrete=TRUE) +
  theme_light() +
  labs(
    x = "Species",
    y = "Sex (% of Total)",
    fill = "Sex",
    title = "Proportion of Sex within Each Species",
    subtitle = "Bar plot showing the percentage breakdown of sex by species"
  )


# Faceting
ggplot(
  small_star_wars,
  aes(
    x = fct_reorder(species, desc(height)),
    y = height,
    fill= fct_reorder(name, desc(height))
  )
) +
  geom_bar(stat="identity", position="dodge") +
  scale_fill_viridis(option = "C", begin = 0.1, end = 0.9, discrete=TRUE) +
  facet_wrap(~sex) +
  theme_light() +
  labs(
    x = "Species",
    y = "Height (in cm)",
    fill = "Name",
    title = "Character Height by Sex within Each Species"
  )

# Dropping unused factors when faceting
ggplot(
  small_star_wars,
  aes(
    x = fct_reorder(species, desc(height)),
    y = height,
    fill= fct_reorder(name, desc(height))
  )
) +
  geom_bar(stat="identity", position="dodge") +
  scale_fill_viridis(option = "C", begin = 0.1, end = 0.9, discrete=TRUE) +
  facet_wrap(~sex, scales ="free_x") +
  theme_light() +
  labs(
    x = "Species",
    y = "Height (in cm)",
    fill = "Name",
    title = "Character Height by Sex within Each Species"
  )

# Lollipop plot
ggplot(
  small_star_wars, 
  aes(
    x=name,
    y=height)) +
  # You can also set colors using text or Hex codes
  geom_segment( aes(x=name, xend=name, y=0, yend=height), color="skyblue") +
  geom_point(color="#433E85FF", size=3.5, alpha=0.9) + 
  theme_classic() +
  labs(
    x = "Species",
    y = "Height (in cm)"
  )


# Box and Violin Plots ----
#We will use the full `starwars` dataset now
# There are a few NAs for height and sex in the full dataset -- filter those out first
# Our friend Jabba is also the only hermaphrodite in the data, so let's filter them out too, for plotting purposes
filtered_star_wars <- starwars %>% filter(!is.na(sex), !is.na(height), species!="Hutt")

# Box Plot with jitter
ggplot( 
  filtered_star_wars,
  aes(x=sex, y=height, fill=sex)) +
  geom_boxplot() +
  scale_fill_viridis(alpha=0.7, begin = 0.2, end = 0.7, option = "D", aesthetics = "fill", discrete = TRUE) +
  geom_jitter(color = "darkgray", size = 0.7, alpha = 0.7) +
  theme_light() +
  theme(
    legend.position="none"
  ) +
  labs(
    x = "Character Sex",
    y = "Height (in cm)",
    title = "Star Wars Height by Character Sex",
    subtitle = "Box Plot with Jitter"
  ) 

# Violin plot
ggplot( 
  filtered_star_wars,
  aes(x=sex, y=height, fill=sex)) +
  geom_violin(width=1.4) +
  geom_boxplot(width=0.1, color="darkgrey", alpha=0.2) +
  scale_fill_viridis(alpha=0.7, begin = 0.2, end = 0.7, option = "D", aesthetics = "fill", discrete = TRUE) +
  theme_light() +
  theme(
    legend.position="none"
  ) +
  labs(
    x = "Character Sex",
    y = "Height (in cm)",
    title = "Star Wars Height by Character Sex",
    subtitle = "Violin Plot with Superimposed Box Plot"
  ) 

# Histograms and Density plots ----
ggplot( 
  filtered_star_wars,
  aes(x=mass)) +
  geom_histogram( binwidth=20, fill="#6fa8dc", color="#e9ecef", alpha=0.9) +
  theme_light() +
  theme(
    plot.title = element_text(size=15)
  ) +
  labs(
    x = "Mass (in kg)",
    y = "Count",
    title = "Star Wars Character Weight",
    subtitle = "Bin Width = 20"
  ) 

##### Your histograms with different bin widths go here! #####
# Don't forget to change the label in the subtitle to reflect your new bin size.



# Density plot 
ggplot( 
  filtered_star_wars,
  aes(x=mass)) +
  geom_density(fill="#6397c6", color="#e9ecef", alpha=0.8) +
  theme_light() +
  labs(
    x = "Weight (in kg)",
    y = "Density",
    title = "Distribution of Star Wars Character Weight"
  )

# Scatter plots ----
# Height vs weight 
# We will keep using our filtered full `starwars` dataset for this one
ggplot(filtered_star_wars, 
       aes(x = mass, 
           y = height, 
           color=mass)
) +
  geom_point(size=3) +     # You can set the size of the points
  ylim(NA, 250) +          # You can also change the limits of the x and y axes
  scale_color_viridis(alpha = 0.5, begin = 1, end = 0, option = "D", aesthetics = "color", discrete = FALSE) +
  theme_light() +
  labs(
    x = "Weight (kg)",
    y = "Height (cm)",
    color = "Weight (kg)",
    title = "Star Wars Character Height and Weight"
  ) 

# Adding species (color) and birth year (size)
ggplot(filtered_star_wars, aes(x = mass, y = height, color = species, size = birth_year)) +
  geom_point() +
  ylim(NA, 230) +
  xlim(NA, 140) +
  scale_color_viridis(alpha = 0.5, begin = 0, end = 1, option = "D", aesthetics = "color", discrete = TRUE) +
  theme_light() +
  labs(
    x = "Weight (kg)",
    y = "Height (cm)"
  ) +
  theme(legend.position = "none")


# Heatmaps ----

# Prepare the data for heatmap
# Extracting the height and weight columns as matrix
heatmap_starwars <- filtered_star_wars %>% 
  filter(!is.na(mass),species %in% c("Human","Droid", "Gungan"))
heatmap_data <- as.matrix(heatmap_starwars[, c("height", "mass")])

# Step 2: Annotate the rows with the "names" variable
rownames(heatmap_data) <- heatmap_starwars$name

##### Your annotation goes here! #####

# Replace `Your_Variable` with your annotation variable
annotations <- data.frame(Your_Variable = heatmap_starwars$Your_Variable)
rownames(annotations) <- heatmap_starwars$name  # Match the rownames of the heatmap data

##### Define the colors for your annotation #####

# First, check the levels of your variable so you know how many categories to make:
table(heatmap_starwars$Your_Variable)

# Then define each level and a color for each level

# Below is the code for `species` -- update it with your variable
## Replace "Human", "Droid", and "Gungan" below with your variable levels 
## Make sure all the levels of your variable are represented
annotation_colors <- list(
  Your_Variable = c(
    "Human" = "#1f77b4",  # Blue
    "Droid" = "#ff7f0e",  # Orange
    "Gungan" = "#2ca02c" # Green
  )
)


##### Generate the heatmap with your annotations #####
pheatmap(
  heatmap_data,
  annotation_row = annotations,  # Add row annotations
  annotation_colors = annotation_colors,  # Add colors for the annotations
  cluster_rows = TRUE,  # Cluster rows
  cluster_cols = FALSE,  # Cluster columns
  scale="column"
)

# Saving ----

##### Pick your favorite plot from today and copy/paste the code below! #####

# Create your plot object
Your_plot <- # paste the code for your favorite plot after the assignment operator!
  
# View your plot by calling the object:
Your_plot

# Save as `.png` while creating a new output directory in your R Project:
ggsave("YOUR_PLOT_NAME.png",
  plot = Your_plot,
  path = "output/figures",
  width = 10,
  height = 6,
  dpi = 300,
  units = "in",
  bg = "white",
  create.dir = TRUE
)

# Timestamp and save as `.pdf`
ggsave(filename = paste0("YOUR_PLOT_NAME_", format(Sys.Date(), "%Y-%m-%d"), ".pdf"),
       plot = Your_plot,
       path = "output/figures",
       width = 10,
       height = 6,
       dpi = 300,
       units = "in",
       bg = "white",
       create.dir = TRUE
)

# Congratulations, you've made some beautiful plots in R!







