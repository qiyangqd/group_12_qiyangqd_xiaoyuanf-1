# author: Margot Chen, Qi Yang
# date: 2020-03-23

"This script is the main file that creates a Dash app.

Usage: app.R
"

# Load libraries

library(dash)
library(dashCoreComponents)
library(dashHtmlComponents)
library(ggplot2)
library(plotly)
library(tidyverse)
library(here)
library(viridis)

app <- Dash$new()

# Load the data
df_clean <- read.csv(here("data", "cleaned_data.csv"))
df <- read.csv(here("data", "raw_data.csv"))
df_clean_sample <- sample_n(df_clean, 5000)

# source
source(here("scripts/dash_functions.R"))
source(here("scripts/dash_components.R"))



# layout
app$layout(
  title,
  htmlDiv(
    className = "pretty_container",
    list(
      intro,
      overview_header,
      div_checklist,
      overview_heatmap,
      time_header,
      div_slider,
      graph_time,
      factors_header,
      div_radio,
      factor_scatterplot,
      dccMarkdown("[Data Source](https://archive.ics.uci.edu/ml/datasets/Beijing+PM2.5+Data#)")
      ), style = list('display' = 'block',
                      'margin-left' = 'auto',
                      'margin-right' = 'auto',
                      'width'='90%')

          )
)

# app callback
## year checklist callback
app$callback(
  output=list(id='heat', property='figure'),
  params=list(input(id='year_checklist', property='value')),
  function(yearCheck) {
    make_heatmap(yearCheck)
  }
)

## year_time callback
app$callback(
  output=list(id = 'graph_time', property='figure'),
  params=list(input(id='year-slider', property='value')),
  # Create a list of values
  function(value) {
    make_line_graph(value)
  })

## year_time hint callback
app$callback(
  output(id = 'time_range_hint', property='children'),
  params=list(input(id='year-slider', property='value')),
  function(value) {
    time_range(value)
  })


## weather factor callback
app$callback(
  output=list(id='scatter', property='figure'),
  params=list(input(id='factor_radio', property='value')),
  function(x_axis) {
    make_scatter(x_axis)
  }
)


# Run app
app$run_server(debug=TRUE)
