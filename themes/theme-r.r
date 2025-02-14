library(ggplot2)
library(RColorBrewer)

my_palette <- c('#ce5444', '#f6d989', '#beaae3', '#75a7c4', '#77847a')

my_theme <- theme_bw() +
  theme(
    plot.background = element_rect(fill = "white"),
    plot.title = element_text(face = "bold", size = 20, color = "darkblue"),
    plot.subtitle = element_text(face = "italic", size = 15, color = "darkblue"),
    axis.title = element_text(face = "bold", size = 12, color = "black"),
    axis.title.x = element_text(face = "bold", size = 14, color = "black"),
    axis.title.y = element_text(face = "bold", size = 14, color = "black"),
    axis.text = element_text(size = 10, color = "black"),
    axis.text.x = element_text(angle = 45, hjust = 1),
    panel.background = element_rect(fill = "white"),
    panel.grid.major = element_line(color = "pink", size = 0.25),
    panel.grid.minor = element_blank(),
    legend.title = element_text(face = "bold", size = 12),
    legend.key = element_rect(fill = "white"),
    legend.background = element_rect(fill = "white"),
    strip.background = element_rect(fill = "lightblue"),
    strip.text = element_text(face = "bold", color = "black"),
    plot.caption = element_text(hjust = 0.5, size = 10, color = "black")
  )

library(extrafont)
my_theme <- my_theme +
  theme(
    plot.title = element_text(family = "Merriweather", size = 16, face = "bold"),
    axis.title = element_text(family = "Merriweather", face = "bold")
  )
