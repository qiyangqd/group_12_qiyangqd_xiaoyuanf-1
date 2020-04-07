# author: Qi Yang
# date: 2020-03-05

"This script loads in a raw dataset from an external URL and saves it as data/raw_data.csv.
The URL is: https://archive.ics.uci.edu/ml/machine-learning-databases/00381/PRSA_data_2010.1.1-2014.12.31.csv

Usage: load_data.R --data_url=<load_data_url>
"-> doc

# Load packages
# Create package list
c <- c("tidyverse", "here", "docopt", "glue")
# Suppress output package list
invisible(lapply(c, require, character.only = TRUE)) 

# Read in command line arguments
opt <- docopt(doc)

# Main function
main <- function(data_url){
  
  # Read in csv from the URL
  df<-read.csv(url(data_url))
  
  # Write csv to data folder
  write.csv(df, here("data", "raw_data.csv"))
  
  # Give message to users
  print(glue("The dataset has been loaded to {here('data', 'raw_data.csv')}!"))
}

#' @data_url data_url is the URL to the dataset. 
#' @example read.csv(url(https://archive.ics.uci.edu/ml/machine-learning-databases/00381/PRSA_data_2010.1.1-2014.12.31.csv))

# Call main function
main(opt$data_url)