# automatically installed required packages
list.of.packages <- c("dplyr","zoo","RCurl","properties")
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages)

library(dplyr)
library(zoo)
library(RCurl)
library(XML)
library(properties)

setwd("D:\\Ms in Data Analytics\\DWBI\\DWBI Project\\Source Code\\config")
sysProps <- read.properties("config.properties")
sysProps
setwd("D:\\Ms in Data Analytics\\DWBI\\DWBI Project\\Datasets\\Stocks")


curl = getCurlHandle()
curlSetOpt(cookiefile="cookies.txt"
           , curl=curl, followLocation = TRUE)

generateYStocksDataCompanyWise <- function(symbol_code){
  
  yahoo_symbol_file <- paste0(symbol_code,'.csv')
  print(symbol_code)
  if(!file.exists(yahoo_symbol_file) || file.size(yahoo_symbol_file) == 0)  
    return(NULL)
  
  y_stocks_data <- read.delim(yahoo_symbol_file, header = TRUE, sep = ",")
  y_stocks_data$Date <- as.Date(y_stocks_data$Date, "%Y-%m-%d")
  if(sysProps$is_live_stock_enabled=='0')
    y_stocks_data<- y_stocks_data[(y_stocks_data$Date >= "2017-01-01" & y_stocks_data$Date <= "2018-11-19"),]
  y_stocks_data <- y_stocks_data[,-6]
  y_stocks_data$symbol_code <- rep(symbol_code,nrow(y_stocks_data))
  y_stocks_data$Open <- as.double(y_stocks_data$Open)
  y_stocks_data$High <- as.double(y_stocks_data$High)
  y_stocks_data$Low <- as.double(y_stocks_data$Low)
  y_stocks_data$Close <- as.double(y_stocks_data$Close)
  y_stocks_data$Volume <- as.integer(y_stocks_data$Volume)
  
  return(unique(y_stocks_data))
}


stocks_file_names <- read.csv(file = "../processed_data/stocks_by_company.csv")

stocks_files <- stocks_file_names$stock_symbol

#download files
for(stock_symbol in stocks_files) {
  
  file_name <- paste0(stock_symbol,".csv")
  
  if(!file.exists(file_name) || file.size(file_name) ==0 || sysProps$is_live_stock_enabled=='1') {
    endDate=format(Sys.time(),"%s")
    appURL <- paste0("https://query1.finance.yahoo.com/v7/finance/download/",stock_symbol,"?period1=1483228800&period2=",endDate,"&interval=1d&events=history&crumb=NIzM/9c35H4")
    pdfData <- getBinaryURL(appURL, curl = curl, .opts = list(cookie = "B=9ano5o1dl9kuh&b=3&s=g4; GUC=AQABAQFb3zJct0IfJQSe&s=AQAAAIm0uL0y&g=W93sCg"))
    writeBin(pdfData, file_name)
  }
  else
   print(paste0("file already exists :",file_name))
}

insert_count <- 0
error_count <- 0
tryCatch({ 
  for(stock_symbol in stocks_files) {
    
    print(stock_symbol)

    t <- generateYStocksDataCompanyWise(stock_symbol)
    
    print(head(t))
    if(is.null(t))
      next
    
    t <- unique(t)
    
    if(insert_count == 0)
      final_data <- t
    else
      final_data <- rbind(final_data,t)
    insert_count<- insert_count+1
  }
}, error = function(e) {
  error_count<-error_count+1
  print("An error has occured! Logging details..")
  print(e)
})

#save processed files
write.csv(final_data, file = "../processed_data/daily_stocks_by_company.csv",row.names=FALSE, na="", quote = FALSE)