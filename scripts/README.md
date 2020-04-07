# Scripts    

This folder contains the scripts we used for the Beijing PM2.5 project.

## Content      

#### Project:    

- `data_wrangle.R`: Process the [raw dataset](https://stat547-ubc-2019-20.github.io/group_12_qiyangqd_xiaoyuanf/data/raw_data.csv) according to our needs and generate a [clean dataset](https://stat547-ubc-2019-20.github.io/group_12_qiyangqd_xiaoyuanf/data/cleaned_data.csv)     
- `eda.R`: Exploration of data analysis (plots).    
- `knit.R`: Knit our final report to `.html` and `.pdf`.    
- `load_data.R`: Load in datasets.    
- `model.R`: Build the model for our project.    

#### Dashboard:    

- `app.R`: Dashboard.    
- `dash_components.R`: Dashboard components.    
- `dash_functions.R`: Dashboard functions.    

#### Dashboard deployment:    

- `apt-packages`: List of (ubuntu) system packages that need to be installed.    
- `init.R`: List of R packages that need to be installed.    
- `Dockerfile`: List of “scripts” that needs to be run for the `app.R` to run successfully.    
- `heroku.yml`: Tells Heroku that this is a web application that uses a Dockerfile for configuration.    
- `app.json`: Description of the app.    