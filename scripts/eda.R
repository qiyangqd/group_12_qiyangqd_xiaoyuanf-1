# author: Qi Yang, Margot Chen
# date: 2020-03-05

"This script reads in the raw and cleaned data (from the data folder) and carries out the exploration data analysis (EDA). 
It produces a correllogram, a faceted histogram, a heat map, a bar chart and a line chart.
It is recommended to save images created to the images folder. 

Usage: eda.R --raw_path=<path_to_raw_data_file> --clean_path=<path_to_clean_data_file> --image_folder_path=<path_to_the_images_folder>
"-> doc

# Load packages
c <- c("tidyverse", "here", "docopt", "ggplot2", "corrplot", "viridis", "glue") # Create package list
invisible(lapply(c, require, character.only = TRUE)) 

# Read in command line arguments
opt <- docopt(doc)

# Main function
main <- function(raw_path, clean_path, image_folder_path){
  
  # Read in the dataset
  # The raw data frame (for the heat map which needs NAs)
  df <- read.csv(here(raw_path))
  # The cleaned data frame (for most plots)
  df_clean <- read.csv(here(clean_path))
  
  # 1.Correllogram: `DEWP`, `TEMP`, `PRES`, and `pm2.5`.
  png(here(glue(image_folder_path, "/corr.png")))
  corr(df_clean)
  dev.off()
  
  # 2.Faceted histogram: distribution of [pm2.5] in different wind directions.
  facted_hist <- facted_hist(df_clean)
  ggsave(plot = facted_hist, filename = "facted_hist.png", path = here(image_folder_path))
  
  # 3.Heat map: hourly [pm2.5] from 2013 to 2014. 
  heat_map <- heat_map(df)
  ggsave(plot = heat_map, filename = "heatmap.png", width=16, height=12, path = here(image_folder_path))
  
  # 4.Bar chart: season VS. pm2.5
  season_pm2.5 <- season_pm2.5(df_clean)
  ggsave(plot = season_pm2.5, filename = "season_pm2.5.png", path = here(image_folder_path))
  
  # 5.Line chart: year VS. pm2.5
  year_pm2.5 <- year_pm2.5(df_clean)
  ggsave(plot = year_pm2.5, filename = "year_pm2.5.png", width = 12, height = 4, path = here(image_folder_path))
  
  
  # message for users
  print(glue("EDA has run successfully! Plots are saved in the {image_folder_path} folder."))
}


## Functions in main()
#' 1. Correlogram
#' Creating correlations between weather conditions and PM2.5 concentration
#' @param df_clean is the cleaned data frame used for plotting.
#' @examples corr(df_clean)

corr <- function(df_clean){
  # get the correlation of the four columns DEWP, TEMP, PRES, and pm2.5 against each other.
  df_corr<- cor(df_clean[6:9]) %>% 
    round(2)
  # Create corrplot
  corr<-corrplot(df_corr,
                 type = "upper",
                 method = "color",
                 addCoef.col = "black",
                 diag = FALSE, 
                 title = "Correlation of [PM2.5] and meteorological conditions",
                 mar = c(0,0,5,0)) # Position title inside window page)
}


#' 2. Faceted histogram
#' Creating PM2.5 counts vs. concentration for different wind directions.
#' @param df_clean is the cleaned data frame used for plotting.
#' @examples facted_hist(df_clean)    

facted_hist <- function(df_clean){
  df_clean %>% ggplot(aes(pm2.5))+
    geom_histogram()+
    # factes are wind directions
    facet_wrap(~cbwd)+
    labs(title = "PM2.5 pollution for different wind directions", x = "PM2.5")+
    theme_classic(base_size = 17)
}

#' 3. Heat map
#' Showing the distribution of PM2.5 concentration at different times (hours, days, months, years).
#' @param df is the raw data frame used for plotting.
#' @examples heat_map(df)

heat_map <- function(df){
  df %>% filter(year>=2013) %>% 
    ggplot(aes(day,hour,fill=pm2.5))+
    geom_tile(color= "white",size=0.1) +
    # Sets the order of colours in the scale reverse
    scale_fill_viridis(name="Hourly pm2.5", direction = -1)+ 
    facet_grid(year~month)+
    scale_y_continuous(trans = "reverse", breaks = unique(df$hour))+
    scale_x_continuous(breaks =c(1,10,20,31))+
    theme_minimal(base_size = 8)+
    labs(title= "Hourly [PM2.5] in 2013 and 2014", x="Day", y="Hour")+
    theme(legend.position = "bottom")+
    theme_minimal(base_size = 20)
}

#' 4. Bar plot
#' Season vs. PM2.5 concentration
#' @param df_clean is the cleaned data frame used for plotting.
#' @examples season_pm2.5(df_clean)

season_pm2.5 <- function(df_clean){
  ## add "season" to df_clean
  df_bar <- df_clean %>%
    mutate(season = case_when(month == 12 ~ 'Winter', month >= 9 ~ 'Autumn', month >= 6 ~ 'Summer', month >= 3 ~ 'Spring',TRUE ~ 'Winter'))  # Group dates to seasons
  ## calculate the mean [pm2.5] for each season
  df_bar = aggregate(df_bar$pm2.5,by = list(df_bar$season),FUN = mean)
  ## rename season and pm2.5 column
  names(df_bar) <- c("season", "pm2.5")
  ## reorder the season
  df_bar$season = factor(df_bar$season, levels = c("Spring", "Summer", "Autumn", "Winter"))
  ## plotting
  ggplot(data = df_bar, aes(x=season, y = pm2.5)) +
    geom_bar(stat="identity")+
    coord_cartesian(ylim=c(80,120))+ # limit the range of [pm2.5]
    labs(x = "Season",
         y = "[pm2.5]",
         title = "pm2.5 VS Season")+
    theme_classic(base_size = 22)
}

#' 5. Line chart
#' Time vs. PM2.5 concentration
#' @param df_clean is the cleaned data frame used for plotting.
#' @examples syear_pm2.5(df_clean)

year_pm2.5 <- function(df_clean){
  df_year_change <- df_clean
  ## add "date" column
  df_year_change$date = as.Date(with(df_year_change, paste(year, month, day,sep="-")), "%Y-%m-%d") # Combine day, month and year to date
  ## calculate the mean for each date
  df_year_change = aggregate(df_year_change$pm2.5,
                             by = list(df_year_change$date),
                             FUN = mean) # Mean [pm2.5] of each date
  ## rename date and pm2.5 column
  names(df_year_change) <- c("date", "pm2.5")
  ## plotting
  ggplot(data = df_year_change) +
    geom_line(aes(x=date, y=pm2.5),
              alpha = 0.6,
              size = 0.6) +
    geom_vline(xintercept = as.numeric(as.Date("2013-09-01")), linetype=4, color = "blue", size = 1) +
    # add a vertical line showing the time when Chinese overnment launched the plan to control pm2.5
    labs(x = "Time",
         y = "[pm2.5]",
         title = "[pm2.5] VS Time") +
    theme_classic(base_size = 22)
  
}


#' @param raw_path is the full path to the raw data file.
#' @example read.csv(here(data/raw_data.csv))
#' 
#' @param clean_path is the full path to the cleaned data file.
#' @example read.csv(here(data/cleaned_data.csv))
#' 
#' @param image_folder_path is the full path name to the folder where users would like to save the images. 
#' @example ggsave(plot, "filename.png", path = here(images))

# Call the main function
main(opt$raw_path, opt$clean_path, opt$image_folder_path)
