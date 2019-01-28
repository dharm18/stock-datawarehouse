# automatically installed required packages
list.of.packages <- c("RMySQL", "tidytext","dplyr","reshape","ggplot2","tidyr","textcat","cld2","cld3","tidyverse","zoo")
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages)

library(RMySQL)
library(tidytext)
library(dplyr)
library(reshape)
library(ggplot2)
library(tidyr)
library(textcat)
library(cld2)
library(cld3)
library(tidyverse)
library(zoo)

# DB connection to MYSQL
con <- dbConnect(MySQL(),username="root",password="",dbname="x18108181dwbi",host="localhost")
on.exit(dbDisconnect(con))

query <- "SELECT `tweet_text`, `created_at`, `basic_sentiment`,`stock_symbol` FROM `stocktwits`"
resultset <- dbSendQuery(con,query)
stocktwits_data <- fetch(resultset,n=-1)

summary(stocktwits_data)
#textcat=textcat(x=tweet_text),
#stocktwits_data <- stocktwits_data %>% mutate(
 #                                             cld2= cld2::detect_language(text = tweet_text, plain_text = FALSE),
  #                                            cld3= cld3::detect_language(text = tweet_text)) %>%
#  select(tweet_text,cld2,cld3,created_at) %>%
#  filter(cld2 == "en" && cld3 == "en")
#stockist_data$textcat <- textcat(x=tweet_text)

stocktwits_data$qt <- as.yearqtr(stocktwits_data$created_at,'%Y-%m-%d')
stocktwits_data$year <- substr(stocktwits_data$qt,1,4)
stocktwits_data$quarter <- substr(stocktwits_data$qt,6,7)

unique(stocktwits_data$qt)

noStockTwits <- table(stocktwits_data$qt)
noStockTwits

text_df <- data_frame(quarter=stocktwits_data$qt, text=stocktwits_data$tweet_text,company_code=stocktwits_data$stock_symbol)
text_df <- text_df %>% unnest_tokens(word,text)

afin <- get_sentiments("afinn")
bing <- get_sentiments("bing")
nrc <- get_sentiments("nrc")

afinSent <- text_df %>%
  inner_join(afin) %>%
  group_by(index = quarter,company_code) %>%
  summarise(sentiment = avg(score))

tail(afinSent)

# bingSent <- text_df %>%
#   inner_join(bing) %>%
#   count(index = quarter, sentiment) %>%
#   spread(sentiment, n, fill = 0) %>%
#   mutate(sentiment = positive - negative)
# 
# nrcSent <- text_df %>%
#   inner_join(nrc) %>%
#   count(index = quarter, sentiment) %>%
#   spread(sentiment, n, fill = 0) %>%
#   mutate(sentiment = positive - negative)
# noStockTwits

for(i in 1:length(noStockTwits)) {
  afinSent$sentiment[i] <- afinSent$sentiment[i] / noStockTwits[[i]] * 100
  # bingSent$sentiment[i] <- bingSent$sentiment[i] / noStockTwits[[i]] * 100
  # nrcSent[i, 2:12] <- nrcSent[i, 2:12] / noStockTwits[[i]] * 100
}

str(nrcSent)

sentimentTweets <- data.frame(afinSent)
# sentimentTweets <- merge(sentimentTweets, bingSent[,c("index", "sentiment")], by="index")
# sentimentTweets <- merge(sentimentTweets, nrcSent[, c("index", "sentiment")], by="index")

#names(sentimentTweets) <- c("qt", "afinn", "bing", "nrc")
names(sentimentTweets) <- c("qt", "company_code","afinn")

sentimentTweets$year <- substr(sentimentTweets$qt,1,4)
sentimentTweets$quarter <- substr(sentimentTweets$qt,6,7)

head(sentimentTweets)
sentimentTweets <- sentimentTweets[,-1]
# tweetData <- melt(sentimentTweets, id="qt")
# ggplot(tweetData, aes(x=qt, y=value, fill=variable)) +
#   geom_bar(stat='identity', position='dodge')
sentimentTweets <- sentimentTweets[!(sentimentTweets$company_code=='GOOG'),]


write.csv(sentimentTweets, file = "../processed_data/quarterly_sentiments_by_company.csv",row.names=FALSE, na="", quote = FALSE)
