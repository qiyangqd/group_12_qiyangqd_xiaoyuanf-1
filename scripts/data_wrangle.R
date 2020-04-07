# author: Margot Chen
# date: 2020-03-08

"This script reads in the raw data file (in the data folder), cleans the raw dataset by deleting the first column and NAs of the `raw_data.csv`.
It is recommended to save the cleaned data file in the data folder as well.

Usage: data_wrangle.R --raw_path=<path_to_raw_data_file> --clean_path=<path_to_clean_data_file>
" -> doc

# Load packages
# Create package list
c <- c("tidyverse", "here", "docopt", "glue") 
# Suppress output package list
invisible(lapply(c, require, character.only = TRUE)) 

# Read in command line arguments
opt <- docopt(doc)

# Main function
main <- function(raw_path, clean_path) {
  
  # Read in the raw data
  df<-read_data(raw_path)
  
  # Clean out NAs
  df<-df %>% drop_na() %>% 
    select(2:14)  # the raw data duplicates the first column which is row number
    
  # Change the names of the wind direction
  levels(df$cbwd) <- c("Calm and variable", "Northeast", "Northwest", "Southeast") 
  
  # Save the cleaned data  
  save_data(df, clean_path)
  
  # Message to the user
  print(glue("The cleaned dataset is saved to ", clean_path, "."))

}


#' @param raw_path indicates where the raw data is. 
#' @example read_data('data/raw_data.csv')
#' 
#' @param clean_path indicates where the wrangled data should be saved.
#' @example save_data("data/cleaned_data.csv")

# Read in the raw dataset
read_data <- function(raw_path) {
  read.csv(here(raw_path))
}

# Save the cleaned dataset
save_data <- function(df, clean_path) {
  write.csv(df, here(clean_path), row.names=FALSE)
}

# Call the main function
main(opt$raw_path, opt$clean_path)

