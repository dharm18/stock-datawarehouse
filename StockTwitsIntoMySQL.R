library(RMySQL)
library(rjson)

setwd("D:\\Ms in Data Analytics\\DWBI\\DWBI Project\\Datasets\\StockTwits\\")
con <- dbConnect(MySQL(),username="root",password="",dbname="x18108181dwbi",host="localhost")
on.exit(dbDisconnect(con))


stocktwits_files <- list.files(path = ".",pattern = "*.json")
#head(stocktwits_files)
insert_count <- 0
error_count <- 0
error_list <- list()

tryCatch({ 
for(file_name in stocktwits_files) {
  
  print(paste0("reading file : ", file_name))
  stocktwits_json <- fromJSON(file = file_name)
  stock_code <- stocktwits_json$symbol$symbol
  stock_title <- stocktwits_json$symbol$title
  for(stocktwit in stocktwits_json$messages ){
  
    query <- paste0("INSERT INTO `stocktwits` (`tweet_text`, `created_at`, `basic_sentiment`,`stock_symbol`,`stock_title`) VALUES ('",stocktwit$body,"','",stocktwit$created_at,"','",stocktwit$entities$sentiment,"','",stock_code,"','",stock_title,"')")
    #print(query)
    query <- eval(parse(text=gsub("\\", "", deparse(query), fixed=TRUE)))
    dbSendQuery(con,query)
    insert_count <- insert_count+1
  }
  print(paste0("proccessed file : ", file_name))
}

}, error = function(e) {
  error_count<-error_count+1
  print("An error has occured! Logging details..")
  print(e)
  error_list <- c(error_list,e)
})

print(paste0("Insert process complete. Total inserts : ", insert_count))
print(paste0("Total erros : ", error_count))
for(err in error_list){
  print(err)
}





