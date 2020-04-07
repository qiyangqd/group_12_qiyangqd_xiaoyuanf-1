# author: Qi Yang
# date: 2020/03/16

.PHONY: all clean

## `all` target
all: docs/finalreport.html docs/finalreport.pdf docs/finalreport.md

# Download data
data/raw_data.csv : scripts/load_data.R
	Rscript scripts/load_data.R --data_url="https://archive.ics.uci.edu/ml/machine-learning-databases/00381/PRSA_data_2010.1.1-2014.12.31.csv"

# Clean data
data/cleaned_data.csv : data/raw_data.csv scripts/data_wrangle.R
	Rscript scripts/data_wrangle.R --raw_path="data/raw_data.csv" --clean_path="data/cleaned_data.csv" 

# EDA
images/corr.png images/facted_hist.png images/heatmap.png images/season_PM2.5.png images/year_PM2.5.png : data/cleaned_data.csv data/raw_data.csv scripts/eda.R
	Rscript scripts/eda.R --raw_path="data/raw_data.csv" --clean_path="data/cleaned_data.csv" --image_folder_path="images"

# Generate model
data/model.rds : data/cleaned_data.csv scripts/model.R
	Rscript scripts/model.R --clean_path="data/cleaned_data.csv" --model_path="data/model.rds"

# Knit report
docs/finalreport.html docs/finalreport.pdf docs/finalreport.md : images/corr.png images/facted_hist.png images/heatmap.png images/season_PM2.5.png images/year_PM2.5.png docs/finalreport.Rmd data/cleaned_data.csv data/raw_data.csv scripts/knit.R data/model.rds
	Rscript scripts/knit.R --rmd_path="docs/finalreport.Rmd"

# Clean targets    
clean :
	rm -f data/*
	rm -f images/*
	rm -f docs/*.md
	rm -f docs/*.html
	rm -f docs/*.pdf
	rm -f docs/*.rds