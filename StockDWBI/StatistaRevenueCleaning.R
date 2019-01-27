# automatically installed required packages
list.of.packages <- c("xlsx")
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages)

library("xlsx")

setwd("D:\\Ms in Data Analytics\\DWBI\\DWBI Project\\Datasets\\")

readRevenueDataCompanyWise <- function(revenue_data,company_code, is_value_in_millions){

  colnames(revenue_data) <- c("quarter","revenue")
  revenue_data$quarter <- gsub("[^[:alnum:]///]", "", revenue_data$quarter)
  
  rownames(revenue_data) <- revenue_data$quarter
  
  revenue_data$year <- paste0(20,substr(revenue_data$quarter,3,4))
  revenue_data$quarter <- substr(revenue_data$quarter,0,2)
  if(is_value_in_millions)
    revenue_data$revenue <- (revenue_data$revenue/1000)
  else
    revenue_data$revenue <- (revenue_data$revenue)
  
  revenue_data$revenue <- round(revenue_data$revenue,2)
  revenue_data$company_code <- rep(company_code,nrow(revenue_data))
    
  return(revenue_data)
    
}

revenue_data <- read.xlsx("statistic_id540128_alphabet_-quarterly-revenue-2014-2018.xlsx", sheetIndex = 2, startRow = 5)

alphabet_revenue <- readRevenueDataCompanyWise(revenue_data,"GOOGL",TRUE)

revenue_data <- read.xlsx("statistic_id263426_revenue-of-apple-by-fiscal-quarter-2005-2018.xlsx", sheetIndex = 2, startRow = 5)

apple_revenue <- readRevenueDataCompanyWise(revenue_data,"APPL",FALSE)

revenue_data <- read.xlsx("statistic_id273963_amazon_-quarterly-net-revenue-2007-2018.xlsx", sheetIndex = 2, startRow = 5)

amazon_revenue <- readRevenueDataCompanyWise(revenue_data,"AMZN",FALSE)

revenue_data <- read.xlsx("statistic_id422035_facebook_-worldwide-quarterly-revenue-2011-2018.xlsx", sheetIndex = 2, startRow = 5)

facebook_revenue <- readRevenueDataCompanyWise(revenue_data,"FB",TRUE)

final_data <- rbind(alphabet_revenue,apple_revenue)
final_data <- rbind(final_data,amazon_revenue)
final_data <- rbind(final_data,facebook_revenue)

#EA
revenue_data <- read.xlsx("statistic_id272936_electronic-arts---quarterly-income-loss-q2-2010---q2-2019.xlsx", sheetIndex = 2, startRow = 5)
final_data <- rbind(final_data,readRevenueDataCompanyWise(revenue_data,"EA",TRUE))

revenue_data <- read.xlsx("statistic_id265041_intels-net-revenue-from-2008-2018-by-quarter.xlsx", sheetIndex = 2, startRow = 5)
final_data <- rbind(final_data,readRevenueDataCompanyWise(revenue_data,"INTC",FALSE))

revenue_data <- read.xlsx("statistic_id269730_oracles-revenue-by-quarter-2007-2018.xlsx", sheetIndex = 2, startRow = 5)
final_data <- rbind(final_data,readRevenueDataCompanyWise(revenue_data,"ORCL",FALSE))

revenue_data <- read.xlsx("statistic_id272974_quarterly-revenue-of-cisco-systems-worldwide-2009-2018.xlsx", sheetIndex = 2, startRow = 5)
final_data <- rbind(final_data,readRevenueDataCompanyWise(revenue_data,"CSCO",FALSE))

revenue_data <- read.xlsx("statistic_id272963_adobe-systems_-revenue-worldwide-2009-2018-by-quarter.xlsx", sheetIndex = 2, startRow = 5)
final_data <- rbind(final_data,readRevenueDataCompanyWise(revenue_data,"ADBE",TRUE))

revenue_data <- read.xlsx("statistic_id272662_viacom_-quarterly-revenue-q1-2010--q3-2018.xlsx", sheetIndex = 2, startRow = 5)
final_data <- rbind(final_data,readRevenueDataCompanyWise(revenue_data,"VIAB",FALSE))

revenue_data <- read.xlsx("statistic_id206178_dish-networks-revenue-q1-2010-q3-2018.xlsx", sheetIndex = 2, startRow = 5)
final_data <- rbind(final_data,readRevenueDataCompanyWise(revenue_data,"DISH",FALSE))

revenue_data <- read.xlsx("statistic_id276456_comcast-corporations-revenue-q1-2010---q3-2018.xlsx", sheetIndex = 2, startRow = 5)
final_data <- rbind(final_data,readRevenueDataCompanyWise(revenue_data,"CMCSA",FALSE))

revenue_data <- read.xlsx("statistic_id273883_netflixs-revenue-q1-2011--q3-2018.xlsx", sheetIndex = 2, startRow = 5)
final_data <- rbind(final_data,readRevenueDataCompanyWise(revenue_data,"NFLX",TRUE))

revenue_data <- read.xlsx("statistic_id795856_seagate_-global-quarterly-revenue-by-segment-2015-2018.xlsx", sheetIndex = 2, startRow = 5)
final_data <- rbind(final_data,readRevenueDataCompanyWise(revenue_data,"STX",TRUE))

revenue_data <- read.xlsx("statistic_id218517_paypal_-quarterly-net-revenue-2010-2018.xlsx", sheetIndex = 2, startRow = 5)
final_data <- rbind(final_data,readRevenueDataCompanyWise(revenue_data,"PYPL",TRUE))

revenue_data <- read.xlsx("statistic_id249582_bank-of-america_-revenue-net-of-interest-expense-2015-2018.xlsx", sheetIndex = 2, startRow = 5)
final_data <- rbind(final_data,readRevenueDataCompanyWise(revenue_data,"BAC",FALSE))

revenue_data <- read.xlsx("statistic_id475574_ebay_-quarterly-net-revenue-2014-2018.xlsx", sheetIndex = 2, startRow = 5)
final_data <- rbind(final_data,readRevenueDataCompanyWise(revenue_data,"EBAY",TRUE))

revenue_data <- read.xlsx("statistic_id272746_microsofts-revenue-2008-2019-by-fiscal-quarter.xlsx", sheetIndex = 2, startRow = 5)
final_data <- rbind(final_data,readRevenueDataCompanyWise(revenue_data,"MSFT",FALSE))

revenue_data <- read.xlsx("statistic_id269222_pepsicos-quarterly-net-revenue-worldwide-2011-2017.xlsx", sheetIndex = 2, startRow = 5)
final_data <- rbind(final_data,readRevenueDataCompanyWise(revenue_data,"PEP",TRUE))

revenue_data <- read.xlsx("statistic_id560988_hpe_-quarterly-net-revenue-2015-2018.xlsx", sheetIndex = 2, startRow = 5)
final_data <- rbind(final_data,readRevenueDataCompanyWise(revenue_data,"HPE",FALSE))

revenue_data <- read.xlsx("statistic_id224397_walt-disney-company_-quarterly-revenue-2010-2018.xlsx", sheetIndex = 2, startRow = 5)
final_data <- rbind(final_data,readRevenueDataCompanyWise(revenue_data,"DIS",FALSE))

revenue_data <- read.xlsx("statistic_id205929_cbs-corporation%3B-quarterly-revenue-2010-2018.xlsx", sheetIndex = 2, startRow = 5)
final_data <- rbind(final_data,readRevenueDataCompanyWise(revenue_data,"CBS",FALSE))

revenue_data <- read.xlsx("statistic_id274568_twitter_-quarterly-revenue-2011-2018.xlsx", sheetIndex = 2, startRow = 5)
final_data <- rbind(final_data,readRevenueDataCompanyWise(revenue_data,"TWTR",TRUE))

final_data <- final_data[order(final_data[,4],final_data[,3],final_data[,1]),]

unique(final_data$year)
unique(final_data$quarter)

head(final_data)

#save processed files
write.csv(final_data, file = "processed_data/quarterly_revenue_by_company.csv",row.names=FALSE, na="", quote = FALSE)
