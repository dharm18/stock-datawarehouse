install.packages("Rserve")
library(Rserve)

Rserve()

setwd("D:\\Ms in Data Analytics\\DWBI\\DWBI Project\\Datasets\\processed_data\\")
stocktwits_files <- list.files(path = ".",pattern = "\\.json$")

stocks <- read.csv(file = "daily_stocks_by_company.csv")
sentiments <- read.csv(file = "daily_sentiments_by_stocks.csv")
str(stocks)
stocks_sentiments <- merge(stocks,sentiments,by.x = c("Date","symbol_code"),by.y = c("date","company_code"))
str(stocks_sentiments)
#considering only one company GOOGL
stocks_sentiments <- stocks_sentiments[(stocks_sentiments$symbol_code=='AAPL'),]

stocks_sentiments$Date <- as.Date(stocks_sentiments$Date, "%Y-%m-%d")
stocks_sentiments<- stocks_sentiments[(stocks_sentiments$Date >= "2018-01-01" & stocks_sentiments$Date <= "2018-11-19"),]

stocks_sentiments[with(stocks_sentiments,order("Date"))]

plot(stocks_sentiments$afinnSentiment,stocks_sentiments$Volume)

abline(lm(stocks_sentiments$Volume ~ stocks_sentiments$afinnSentiment))

cor(stocks_sentiments$afinnSentiment, stocks_sentiments$Close)

stocks_sentiments$Volume <- as.numeric(stocks_sentiments$Volume)
#cor(stocks_sentiments[,2:6])

#install.packages("GGally")
library("GGally")


#correlation coefficient matrix
#it shows positive,negative,strong weak relations
ggcorr(stocks_sentiments,label = TRUE, label_alpha = TRUE)


library(ggplot2)
qplot(stocks_sentiments$afinnSentiment, 
      stocks_sentiments$Volume, 
      data = stocks_sentiments,
      method = "lm",
      geom = c("point", "smooth"), 
      alpha = I(1 / 5),
      se= FALSE
      )

ggpairs(stocks_sentiments, 
        columns = c("afinnSentiment", "Volume", "Close"), 
        upper = list(continuous = wrap("cor", 
                                       size = 10)), 
        lower = list(continuous = "smooth"))

NROW(cbind(stocks_sentiments$close[0],diff(stocks_sentiments$Close)))
NROW(diff(stocks_sentiments$Close))

stocks_sentiments$close_change <- c(stocks_sentiments$Close[1],diff(stocks_sentiments$Close)) 

ggpairs(stocks_sentiments, 
        columns = c("afinnSentiment", "Volume", "close_change"), 
        upper = list(continuous = wrap("cor", 
                                       size = 10)), 
        lower = list(continuous = "smooth"))
