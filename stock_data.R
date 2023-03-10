# Load the packages
library(jsonlite)
library(httr)
library(data.table)

get_stocks <- function() {
  # query string
  json_string <- '{"filter":[{"left":"market_cap_basic","operation":"nempty"},{"left":"type","operation":"in_range","right":["stock","dr","fund"]},{"left":"subtype","operation":"in_range","right":["common","","etf","unit","mutual","money","reit","trust"]},{"left":"exchange","operation":"in_range","right":["AMEX","NASDAQ","NYSE"]}],"options":{"lang":"en"},"symbols":{"query":{"types":[]},"tickers":[]},"columns":["logoid","name","close","change","change_abs","Recommend.All","volume","market_cap_basic","price_earnings_ttm","earnings_per_share_basic_ttm","number_of_employees","industry","sector","SMA50","SMA100","SMA200","RSI","Perf.Y","Perf.3M","Perf.6M","Perf.1M","Perf.W","High.3M","High.6M","price_52_week_high","description","name","type","subtype","update_mode","pricescale","minmov","fractional","minmove2","SMA50","close","SMA100","SMA200","RSI","RSI[1]"],"sort":{"sortBy":"market_cap_basic","sortOrder":"desc"},"range":[0,8000]}'
  
  # post to get the data
  res <- httr::POST(url = 'https://scanner.tradingview.com/america/scan', body = json_string)
  
  # create dataframe
  t <- fromJSON(content(res, 'text'))
  df_data <-
    rbindlist(lapply(t$data$d, function(x){
      data.frame(t(data.frame(x)), stringsAsFactors = F)
    }))
  
  # fix colnames
  names(df_data) <-  fromJSON(json_string)$columns
  final_data <- cbind( data.table('exchange' = sapply(strsplit(t$data$s, ':'), '[[', 1)),  df_data)
  return(final_data)
}

