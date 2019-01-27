# automatically installed required packages
list.of.packages <- c("rjson","RJSONIO","properties")
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages)

library(rjson)
library(RJSONIO)
library(properties)

setwd("D:\\Ms in Data Analytics\\DWBI\\DWBI Project\\Source Code\\config")
sysProps <- read.properties("config.properties")
if(sysProps$is_live_stock_enabled=='0'){
  quit(status=0)
}

setwd("D:\\Ms in Data Analytics\\DWBI\\DWBI Project\\Datasets\\StockTwits\\")

sysProps <- read.properties("D:\\Ms in Data Analytics\\DWBI\\DWBI Project\\Source Code\\config\\config.properties")
last_updated_record_id <- sysProps$last_updated_record_id

url <- "https://api.stocktwits.com/api/2/streams/symbol/AAPL.json?max="

proc_count <- 0
counter <- 1
starting_index <- -1
top_index <- -1

repeat{
  
  print(counter)
  
  start_time <- lubridate::now()
  print(start_time)
  encoded_url <- paste0(url,starting_index,"&filter=top")
  print(encoded_url)
  
  tryCatch( { 
  
      #call api and get the json input
      stocktwits_data <- jsonlite::fromJSON(encoded_url)
      
      print(tail(stocktwits_data$messages,1)$id)
      starting_index <- tail(stocktwits_data$messages,1)$id
      
      if(proc_count == 0)
        top_index <- starting_index
      #head(stocktwits_data)
      #save in local file )
      #class(stocktwits_data)
      write(jsonlite::toJSON(stocktwits_data), paste0(starting_index,".json"))
      
      counter <- counter+1
      proc_count <- proc_count+1
      #Sys.sleep(6)
      
      if(counter == 200){
        counter <- 1
        print("Sleeping for 1 min.")
        Sys.sleep(360)
      }
      
      if(last_updated_record_id>=starting_index){
        print("StockTwits are updated.")
        sysProps$last_updated_record_id = top_index
        #write.properties(file="D:\\Ms in Data Analytics\\DWBI\\DWBI Project\\Source Code\\config\\config.properties",properties=list(sysProps))
        quit(status=0)
        break
      }
  
  }, error = function(e) {
      print("An error has occured! Resetting the counter and waiting for 2 minutes")
      print(e)
      counter <- 1
      Sys.sleep(120)
  })
}

