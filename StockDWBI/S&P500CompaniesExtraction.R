# automatically installed required packages
list.of.packages <- c("htmltab","stringr","dplyr")
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages)

# load the list of required libraries
library(htmltab)
library(stringr)
library(dplyr)

# URL to S&P 500 List companies
website_url <- "https://en.wikipedia.org/wiki/List_of_S%26P_500_companies"

stocks_companies <- htmltab(doc=website_url, which=1, rm_nodata_cols = F)

# remove the unneccesary columns
stocks_companies <- stocks_companies[,-3]

colnames(stocks_companies) <- c("stock_symbol","Company","Sector","Industry","Location","added_date","central_index_key","founded")

location <- str_split_fixed(stocks_companies$Location,", ",2)
head(location)
colnames(location) <- c("city","location")
stocks_companies <- cbind(stocks_companies,location)
stocks_companies <- stocks_companies[,-5]
#remove columns
stocks_companies <- stocks_companies[,-5]
stocks_companies <- stocks_companies[,-5]
stocks_companies <- stocks_companies[,-5]

#stocks_companies$added_date <- as.Date(stocks_companies$added_date,"%Y-%m-%d")

# remove the unneccesary rows
isEligibleCountry <- stocks_companies$location != 'Ireland' & stocks_companies$location != 'United Kingdom' & stocks_companies$location != 'Surrey, United Kingdom' & stocks_companies$location != 'Kent, United Kingdom' & stocks_companies$location != 'Netherlands' & stocks_companies$location != 'Kingdom of the Netherlands' & stocks_companies$location != 'UK' & stocks_companies$location != 'Bermuda' & stocks_companies$location != 'Kingdom of the Netherlands' & stocks_companies$location != 'Switzerland'

stocks_companies <- stocks_companies[isEligibleCountry,]


setwd("D:\\Ms in Data Analytics\\DWBI\\DWBI Project\\Datasets\\")
# save the file in csv format
write.csv(stocks_companies, file = "processed_data/stocks_by_company.csv",row.names=FALSE, na="")