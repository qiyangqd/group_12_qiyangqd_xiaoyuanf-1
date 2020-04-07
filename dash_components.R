# to create div components for beijing pm2.5 dashboard

# title
title <- htmlDiv(
  className = "pretty_container",
  list(htmlH1('BEIJING PM2.5 (2010-2014)')),
  style = list(
    'columnCount' = 1,
    'background-color' = '#8ECCD9',
    'text-align' = 'center',
    'height'=85,
    'font-family' = 'Impact, Charcoal, sans-serif'
  )
)

# introduction
intro <- htmlDiv(
  className = "pretty_container",
  list(
    htmlH2("Introduction"),
    dccMarkdown('
                Welcome to the BEIJING PM2.5 dashboard! 
                
                Beijing, the capital city of China, has been fighting against PM2.5 pollution in recent decades. PM2.5 are fine airborne particles less than 2.5 micrometers that can cause severe damage to human health. This dashboard enables you to explore how __time__ and __weather conditions__ contribute to PM2.5 concentration in Beijing from 2010 to 2014 based on the [Beijing PM2.5 dataset](https://archive.ics.uci.edu/ml/datasets/Beijing+PM2.5+Data#).  
                
                By playing around this dashboard, you can:
                
                1) obtain an overview of the temporal distribution of PM2.5 concentration in Beijing from 2010 to 2014; 
                
                2) explore how daily PM2.5 concentration changed in a certain period from 2010 to 2014; 
                
                3) explore how weather factors (temperature, pressure, dew point and wind speed) were correlated to PM2.5 concentration.
                ')
  )
)



# checklist
yearChecklist <- dccChecklist(
  id='year_checklist',
  options=list(
    list("label" = "2010  ", "value" = "2010"),
    list("label" = "2011  ", "value" = "2011"),
    list("label" = "2012  ", "value" = "2012"),
    list("label" = "2013  ", "value" = "2013", disabled=TRUE),
    list("label" = "2014", "value" = "2014")
  ),
  value=list("2013")
)

div_checklist <- htmlDiv(
  list(
    htmlLabel('Please pick one or more years you are interested in to see the hourly PM2.5 concentration: '),
    yearChecklist
  ), style=list(
    'padding'=20,
    color = '#4B5F5F'
  )
)

# overview heatmap
overview_heatmap <- dccGraph(
  id='heat',
  figure=make_heatmap()
)


# Line graph and slider: readers can change the range of time to see how [pm2.5] changes with time
## Slider
year_slider <- dccRangeSlider(
  id='year-slider',
  min=14611, # 2010-01-02
  max=16435, # 2014-12-31
  step=1, # each move is 1
  value=list(14975, 16071),
  allowCross = FALSE,
  marks = list(
    "14611" = list("label" = "2010"), # marks the start of each year
    "14976" = list("label" = "2011"),
    "15341" = list("label" = "2012"),
    "15706" = list("label" = "2013"),
    "16071" = list("label" = "2014"),
    "16435" = list("label" = "2015")
  )
)

div_slider <- htmlDiv(
  list(
    htmlLabel('Please pick a time range to see the changes of daily PM2.5 concentration: '),
    year_slider,
    htmlDiv(id='time_range_hint')), style=list('padding'=20, color = '#4B5F5F')
)

## Graph
graph_time <- dccGraph(
  id = 'graph_time',
  figure = make_line_graph()
)

# relationship scatterplot
## weather factor radiobutton
factor_xaxis <-
  tibble(
    label = c("Temperature", "Pressure","Dew Point", "Cumulated wind speed"),
    value = c("TEMP", "PRES", "DEWP", "Iws")
  )

factorRadio <- dccRadioItems(
  id='factor_radio',
  options=map(1:nrow(factor_xaxis), function(i) {
    list(label=factor_xaxis$label[i], value=factor_xaxis$value[i])
  }),
  value = "TEMP",
  labelStyle = list("display" = "block", color = '#4B5F5F')
)

div_radio <- htmlDiv(
  list(
    htmlLabel('Please select a weather factor: '),
    factorRadio
  ), style=list(
    'padding'=20, color = '#4B5F5F'
  )
)

## scatterplot
factor_scatterplot <- dccGraph(
  id='scatter',
  figure=make_scatter()
)


# overview
overview <- htmlDiv(
  className = "pretty_container",
  list(htmlH2("Overview"),
       dccMarkdown('
                   In the heatmap below, each big column represents a month (values at the top) composed of days (values at the bottom). The concentration of PM2.5 of each hour (values on the left) is represented by a color ranging from yellow (low concentration) to dark blue (high concentration) according to the legend. The value on the right indicates the year(s) that you select.
                   '),
       div_checklist,
       overview_heatmap
  )
)

# pm2.5 change over time
time <- htmlDiv(
  className = "pretty_container",
  list(htmlH2("How did Beijing PM2.5 change over time?"),
       dccMarkdown('
                   In the line graph below, the change in PM2.5 concentration is represented on a daily level and a certain time range can be selected. Note that the vertical blue line indicates the time when Chinese government started a PM2.5 reduction plan (September 2013). 
                   
                   '),
       div_slider,
       graph_time
  )
)

# correlated factors

factors <- htmlDiv(
  className = "pretty_container",
  list(htmlH2("How did weather factors relate to PM2.5?"),
       dccMarkdown('
                   In the scatter plots below, you can see the corrleation between a weather factor that you pick and PM2.5 concentration at four different wind directions. 
                   
                   '),
       div_radio,
       factor_scatterplot
  )
)
