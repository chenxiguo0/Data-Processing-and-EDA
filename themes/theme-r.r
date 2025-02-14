---
title: "Styling visualizations in R"
subtitle: "A DSAN 5200 laboratory"
author: "DSAN 5200 Instructional Team"
date: last-modified
date-format: long
format:
    html: 
        light: [cosmo, style/html-sta313.scss]
        dark: [cosmo, style/html-sta313.scss, style/html-dark.scss]
        toc: true
        code-copy: true
        code-overflow: wrap
        mainfont: "Atkinson Hyperlegible"
        code-annotations: hover

execute:
    echo: true
    warning: false
    message: false
    freeze: auto
filters:
    - openlinksinnewpage
    - lightbox
lightbox: auto
---

::: callout-tip
Many code blocks have annotation markings on the right. Hover over them with your mouse to see the actual annotation content.
:::

# Building a plot: data-driven elements

In this part of the assignment, we will build up a figure piece by piece, to demonstrate the grammar of graphics. Make sure you have the `tidyverse` meta-package installed in your environment, or at least the `ggplot2` package.

The `ggplot2` package uses the *Grammar of Graphics* to build up a visualization. This provides a mental model for how to build a visualization using different data elements mapped to visual encodings. In the following example, we build up a visualization, customizing the style and creating a final presentation graphic. Each chunk builds on the previous chunk and saves the update into the object `g`. So you'll see a lot of

``` r
g <- g + ...
```

This is the process of building the visualization.

## Load library and data

```{r}
library(ggplot2) #<1>

data("midwest", package = "ggplot2") #<2>

head(midwest) #<3>
```

1.  Load the ggplot2 package
2.  The `midwest` data is part of the ggplot2 package, and this command loads the data into the current session
3.  Display the first 6 lines of the dataset

## Create a basic plot

```{r}
g <- ggplot(midwest, aes(x = area, y = poptotal)) + # <1>
  geom_point() # <2>
plot(g) # <3>
```

1.  Specify the data and the visual encodings with `aes()`.
2.  Specify the geometry. In this case, we a scatter plot
3.  If you save the ggplot pipeline to a name, it doesn't get printed but is just saved to the name. To actually see it, you need to use `plot()`

::: callout-important
`aes()` are *aesthetic mappings*, which we have called **visual encodings** in the lecture. They represent the mapping of data elements (column names) from the data to visual elements. The use of columns to specify data elements in the ggplot specification shows that the input to the ggplot should be in **tidy format**.
:::

## Alternative methods

The same graph can be generated using some alternative code as well, which achieve the same result.

```{r}
#| eval: false
g <- ggplot(midwest, aes(x = area, y = poptotal))
g <- g + geom_point()
plot(g)
```

```{r}
#| eval: false
g <- ggplot(midwest)
g <- g + geom_point(aes(x = area, y = poptotal))
plot(g)
```

::: callout-note
### Question

What is the difference in effects of the two examples as we continue building the visualization?
:::

## Add context with labels

```{r}
g <- ggplot(midwest, aes(x = area, y = poptotal))
g <- g + geom_point() +
  labs( # <1>
    title = "Area Vs Population",
    subtitle = "From midwest dataset",
    x = "Area (square miles)",
    y = "Population (count)",
    caption = "Midwest Demographics"
  )
plot(g)
```

1.  This sets various labels. This can also be done with, for example, `ggtitle()` for the titles, and `scale_<x,y>_continuous()` for the axes

::: callout-tip
We use a lot of Markdown in our Quarto documents. Can this also be done in `ggplot2`?

Actually, the **ggtext** package provides a solution. It provides two additional theme functions, `element_markdown` and `element_textbox()`, that can replace the `element_text()` function that specifies text styling. We'll go into more detail in the next secion.

You can also better format the labels on the axes using the **scales** package, which has several `label_*` functions
:::

```{r}
library(ggtext)
g <- ggplot(midwest, aes(x = area, y = poptotal))
g <- g + geom_point() +
  scale_y_continuous(
    label = scales::label_number(scale_cut = scales::cut_short_scale()) # <1>
  ) +
  labs( # <1>
    title = "Area Vs Population",
    subtitle = "From *midwest* dataset", # <2>
    y = "Population (count)",
    x = "Area (miles<sup>2</sup>)", # <2>
    caption = "Midwest Demographics"
  ) +
  theme(
    axis.title.x = element_markdown(), # <3>
    plot.subtitle = element_markdown()
  )
plot(g)
```

1.  Updating the format of the labels on the y-axis
2.  Adding markdown/HTML to the labels
3.  Specifying that these elements are markdown (this requires the **ggtext** package)

## Visualize the trend

```{r}
g <- g +
  geom_smooth(method = "lm") # <1>
plot(g)
```

1.  Draw the best fitting straight line to the data. (the default is using loess). You can remove the confidence band by adding `se = FALSE` as an option to `geom_smooth()`

## Change axis limits

You can change the axis limits in order to zoom in and out in the plot. This method doesn't affect points outside of the set limits or the trend line, i.e., it doesn't filter the data and re-draw the plot, but **crops** the plot to meet the set limits.

```{r}
g <- g +
  coord_cartesian(xlim = c(0, 0.1), ylim = c(0, 200000)) # <1>

plot(g)
```

1.  Specify the limits where the plot is cropped.

## Lets explore some color

We'll add some custom color to this plot

```{r}
g <- ggplot(midwest, aes(x = area, y = poptotal)) +
  geom_point(color = "steelblue", size = 3) + # <1>
  geom_smooth(method = "lm", color = "firebrick") +
  coord_cartesian(xlim = c(0, 0.1), ylim = c(0, 200000)) +
  scale_y_continuous(
    label = scales::label_number(scale_cut = scales::cut_short_scale()) # <1>
  ) +
  labs(
    title = "Area Vs Population",
    subtitle = "From *midwest* dataset",
    y = "Population (count)",
    x = "Area (miles<sup>2</sup>)",
    caption = "Midwest Demographics"
  ) +
  theme(
    axis.title.x = element_markdown(),
    plot.subtitle = element_markdown()
  )

plot(g)
```

1.  The specifications for the visual encodings have to be specified in the `geom_` functions. However, if you're doing grouping (using `color=` or `fill=` in the `aes()` function), then you can specify the palette of colors to use for the groups using, for example, `scale_color_manual()`, as we see below.

## Variable color encoding

You can specify color, shape, size, line width and fill color based on values of another variable in the data. The color palette for the color/fill specifications can be specified using pre-made palettes or manually using `scale_<color/fill>_manual()`

```{r}
g <- ggplot(midwest, aes(x = area, y = poptotal)) +
  geom_point(aes(col = state), size = 3) + # <1>
  # theme(legend.position="None")+ # <2>
  geom_smooth(method = "lm", col = "firebrick", size = 2) +
  coord_cartesian(xlim = c(0, 0.1), ylim = c(0, 200000)) +
  scale_y_continuous(
    label = scales::label_number(scale_cut = scales::cut_short_scale()) # <1>
  ) +
  labs(
    title = "Area Vs Population",
    subtitle = "From *midwest* dataset",
    y = "Population (count)",
    x = "Area (miles<sup>2</sup>)",
    caption = "Midwest Demographics",
    color = "State"
  ) +
  theme(
    axis.title.x = element_markdown(),
    plot.subtitle = element_markdown()
  ) +
  scale_colour_brewer(palette = "Spectral") # <3>
plot(g)
```

1.  Specify colors by the states, rather than a fixed color
2.  This automatically generates a legend. You can turn it off overall by this function, or add `show.legend = false` to the `geom_()` specification.
3.  Specifying a pre-made palette from the RColorBrewer package (see [ColorBrewer](https://colorbrewer2.org/#type=sequential&scheme=BuGn&n=3))

# Part 2: Theming and styling

::: callout-tip
**ggplot2** allows us to separate the content (data-driven) and styling (non-data aspects) of a visualization during the build. My (AD) mental model is to actually create the content first, and then end with styling/theming. So usually, I follow this order below, and my code typically reflects this. I find this allows me to more easily debug since each element is in it's own place within the code and I can scan for issues and improvements faster.

My colleagues may share different mental models for building visualizations using **ggplot2**.

1.  Aesthetics (visual encodings)
2.  Geometries (implementing the visual aspects)
3.  Facets, if needed
4.  Labels and annotations
5.  Scales (axes, shapes, fill, lines) (customizing data elements)
6.  Base theme (customizing non-data elements)
7.  Theme customizations (customizing non-data elements)
:::

In **ggplot2** the non-data stylistic elements are specified using the `theme()` function, and data elements by the `scale_*()` functions. We focus on the `theme()` function here.

So, what can you customize in the theme?

```{r}
args(theme)
```

The big groups here are `axis`, `legend`, `panel` (facets), `plot` (the broader plot elements), and `strip` (the titles of the facets). Each of these elements can be customized. Details are available using `?theme`.

::: callout-tip
### From the `theme()` manual page

Theme inheritance:

```         
 Theme elements inherit properties from other theme elements
 hierarchically. For example, ‘axis.title.x.bottom’ inherits from
 ‘axis.title.x’ which inherits from ‘axis.title’, which in turn
 inherits from ‘text’. All text elements inherit directly or
 indirectly from ‘text’; all lines inherit from ‘line’, and all
 rectangular objects inherit from ‘rect’. This means that you can
 modify the appearance of multiple elements by setting a single
 high-level component.
```
:::

The basic functions that are used to specify customizations within the `theme()` function, depending on what you're customizing, are

-   `element_rect`
-   `element_line`
-   `element_text`
-   `element_blank`

::: callout-note
We'll see some other customizations as we go into specialized visualizations later in the semester. We also have already seen an additional customization using `ggtext::element_markdown()`.
:::

There are several themes available in **ggplot2**, including `theme_bw`, `theme_void`, `theme_minimal` and `theme_dark`. You can get a sense of what these are customizing. The default theme is `theme_grey`, which is customized in the other included themes.

```{r}
theme_bw
```

Even more themes are available in extension packages (see <https://exts.ggplot2.tidyverse.org>).

However, we like to develop a custom theme. A valid (and acceptable for this class) approach is to update one of the built-in or extension themes.

```{r}
g +
  theme_bw() +
  theme(
    panel.grid.minor = element_blank(),
    panel.grid.major = element_line(color = "lightblue")
  )
```

Whoops!! This undid some changes we'd already done!! That's because ggplot works as layers, and the last theme directives supercede the earlier ones. `theme_bw` is a completely defined theme, and so it overrides the earlier `theme` specification with the markdown elements. This can off course be fixed.

```{r}
g <- g +
  theme_bw() + # <1>
  theme(
    plot.background = element_rect(fill = "grey80"), # <2>
    axis.title = element_text(face = "bold"),
    axis.title.x = element_markdown(), # <3>
    plot.subtitle = element_markdown(),
    panel.background = element_rect(fill = "#4100FF"), # <4>
    panel.grid.minor = element_blank(), # <5>
    panel.grid.major = element_line(color = "lightblue"), # <6>
    legend.title = element_text(face = "bold"), # <7>
    legend.key = element_rect(fill = "#4100FF") # <8>
  )
plot(g)
```

1.  Start with a base theme (`theme_bw`), and
2.  Change the background of the *canvas*,
3.  Allow markdown in the x-axis title and subtitle,
4.  Change the background color of the plotting area (as hex),
5.  Remove the minor grid lines,
6.  Make the major grid lines blue,
7.  Make the legend title bold.
8.  Match the legend key with the plot background

## Typography

To have maximum flexibility with typography and enable any font installed on your computer to be used in your visualizations, install and load the **extrafont** package.

```{r}
library(extrafont)
g +
  theme(
    plot.title = element_text(family = "Merriweather", size = 16, face = "bold"),
    axis.title = element_text(family = "Merriweather", face = "bold")
  )
```

## Storing your theme for daily use

You can save your own theme as an object and use it as the default in your work. For example, if we were to use the theme we've developed here every day, we would save it as

```{r}
library(extrafont)
my_theme <- theme_bw() +
  theme(
    plot.background = element_rect(fill = "grey80"),
    axis.title = element_text(face = "bold"),
    axis.title.x = element_markdown(),
    plot.subtitle = element_markdown(),
    panel.background = element_rect(fill = "#4100FF"),
    panel.grid.minor = element_blank(),
    panel.grid.major = element_line(color = "lightblue"),
    legend.title = element_text(face = "bold"),
    legend.key = element_rect(fill = "#4100FF")
  ) +
  theme(
    plot.title = element_text(family = "Merriweather", size = 16, face = "bold"),
    axis.title = element_text(family = "Merriweather", face = "bold")
  )
```

To set this theme as a default in a session, use

``` r
theme_set(my_theme)
```

at the start of your code.

If you want to make this theme your default in all your R work, you can put the above code in your global `.Rprofile` file.

# Assignment

Start with the default plot we've developed here. You will develop the style specification that you will use for the rest of the semester. You may update this style over the course of the semester, but it must be your own distinctive style specification.

```{r}
ggplot(midwest, aes(x = area, y = poptotal)) +
  geom_point(aes(col = state)) +
  geom_smooth(method = "lm", se = FALSE) +
  coord_cartesian(xlim = c(0, 0.1), ylim = c(0, 200000)) +
  labs(
    title = "Area Vs Population",
    subtitle = "From midwest dataset",
    y = "Population (count)",
    x = "Area (square miles)",
    caption = "Midwest Demographics",
    color = "State"
  )
```

1.  Create your own color palette that you will use for groups in visualizations. There are a few options that you can use. You can use specific palettes using either the **RColorBrewer** or **viridis** packages (which generally make good, accessible choices). You can also manually create a color palette to use for the points using

``` r
my_palette <- c("<color1","<color2>", "<color3>", "<color4>", "<color5>")
```

and then use it in the plot using `scale_color_manual(values = my_palette)` along with any other options you'd like to use. This latter strategy would be used IRL if you need to incorporate organizational brand colors into your visualizations (for example, Prof. Abhijit uses a custom AZ_palette specification that reflects AstraZeneca brand colors).

2.  Create your own theme by updating one of the available themes in **ggplot2** (not any of the extension packages). You must then customize at least **15 elements** of the theme specification. You must use `element_rect`, `element_line`, `element_text` and `element_blank` at least once. You may also use the **ggtext** functions we've demonstrated here. This theme has to be saved as `my_theme`.

3.  Explain your design choices as a narrative as you develop your theme. If you take inspiration from other publicly available themes and style guides, please cite and refer them in your narrative.

Your solution and submission will begin below the line below. This entire file, along with the rendered HTML file, will be your submission if you choose to do the lab in R. Your solution will include narrative elements and code chunks with output.

::: callout-important
This repository includes a R environment using the **renv** package. This can install all the packages used in this document, so the Quarto will render. To activate the environment, start R in this folder, and make sure you have the **renv** package installed. Then, run

``` r
renv::restore()
```

You will need to do this once, which will clone the R environment into this folder. Then, you can proceed.

Sometimes, because of version issues, `renv::restore()` might generate errors. You can run

``` r
renv::install(renv::dependencies()[,"Package"], type = "binary")
renv::snapshot()
```
:::

<hr/>

# My solution

```{r}
library(ggplot2)
library(RColorBrewer)

my_palette <- c('#ce5444', '#f6d989', '#beaae3', '#75a7c4', '#77847a')
# Create the custom theme
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

# Plot using the custom theme and color palette
ggplot(midwest, aes(x = area, y = poptotal)) +
  geom_point(aes(col = state), size = 2) +
  geom_smooth(method = "lm", col = "darkblue", size = 1.5) +
  coord_cartesian(xlim = c(0, 0.1), ylim = c(0, 200000)) +
  scale_y_continuous(label = scales::label_number(scale_cut = scales::cut_short_scale())) +
  scale_color_manual(values = my_palette) +
  labs(
    title = "Area Vs Population",
    subtitle = "From midwest dataset",
    y = "Population (count)",
    x = "Area (miles²)" ,
    caption = "Midwest Demographics",
    color = "State"
  ) +
  my_theme
```

```{r}
library(extrafont)
my_theme <- my_theme +
  theme(
    plot.title = element_text(family = "Merriweather", size = 16, face = "bold"),
    axis.title = element_text(family = "Merriweather", face = "bold")
  )

theme_set(my_theme)
```
