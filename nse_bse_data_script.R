####################################################################################
#Dhruv Haldar
#haldar@kth.se
####################################################################################

# Package names
packages <- c("ggplot2", "readxl", "dplyr", "nser", "lattice", 
              "reshape2", "hablar", "dplyr", 
              "tidyquant","tidyverse", "scales",
              "padr", "tcltk", "svDialogs","utils", 
              "quantmod","broom", "magrittr",
              "diffr", "diffobj","alphavantager"
              ,"plotly","ggpubr","TTR")

# Install packages not yet installed
installed_packages <- packages %in% rownames(installed.packages())
if (any(installed_packages == FALSE)) {
  install.packages(packages[!installed_packages])
}

# Packages loading
invisible(lapply(packages, library, character.only = TRUE))

# Alpha Vantage API key
api_key="MB7IR06HYB54IUJG"
av_api_key(api_key)

# Clear Workspace 
rm(list=ls()) 
cat("\014")
#####################################################################################
# 
# # Actual Code Starts here
# options(stringsAsFactors = FALSE)
# 
# fdii = fdii()
# 
# date = fdii[3:20,1]
# date <- gsub("-", "", date)                          # Applying gsub function
# date = as.Date(date, "%d%b%y")
# 
# 
# net_FII = fdii[3:20,4]
# net_FII = factor(net_FII)
# net_FII <- gsub(",","", net_FII)                   # Applying gsub function
# options(digits=7)
# net_FII=as.double(net_FII)
# 
# net_DII = fdii[3:20,7]
# net_DII = factor(net_DII)
# net_DII <- gsub(",","", net_DII)                   # Applying gsub function
# options(digits=7)
# net_DII=as.double(net_DII)
# 
# fdii_main <- data.frame(date,net_FII,net_DII)
# 
# p <- ggplot(fdii_main,
#             aes(x = date, y = net_FII)) +
#   geom_bar(stat = "identity", fill = "steelblue") +
#   geom_text(aes(label=net_FII+net_DII), 
#             vjust=0.006, 
#             size=3.5,
#             color="white")+
#   scale_x_date(date_labels="%b %d",date_breaks  ="1 day") +
#   labs(x = "Date",
#        title = "Gross Purchase FII+DII (Crores)",
#        y = "Gross Purchase (Crores)",
#        subtitle = paste("Last updated",Sys.time()),
#        panel.grid.major = element_blank(),
#        panel.grid.minor = element_blank()
#   )
# 
# p+ theme_classic()
# 
# p+ geom_bar(aes(fill = net_FII > 0), stat = "identity") + 
#   scale_fill_manual(
#     guide = "none", 
#     breaks = c(TRUE, FALSE), 
#     values=c("green", "red"))
# 
# # #####################################################################################
# 
# # #Remove unnecessary variables
# rm(date)
# rm(fdii)
# rm(fdii_main)

# #####################################################################################

cat("\014") #Clear Workspace

#Option Strategy Builder
# R program to illustrate
# taking input from the user

# taking input using readline()
# this command will prompt you
# to input a desired value
var = readline();

# convert the inputted value to integer
var = as.integer(var);

# print the value
print(var)


# #####################################################################################
# #FO Bhavcopy Hist. (1 Jan 2016 Onwards)
# # Hist_date=28042022
# # fobhavhist = fobhav(Hist_date)
# # bhavhist = bhav(Hist_date)
# #####################################################################################
# #FO Bhavcopy Today (updated every evening)
# #fobhavtoday = fobhavtoday()
# 
# #####################################################################################
# #NSE Indices today
# nseindex = nseindex()
# #nseindex_name = nseindex[1:55,1]
# #nseindex_change = nseindex[1:55,4]
# 
# 
# #Stock price chart 
# # ggplot(data = tsla_stock_metrics, aes(x = date, y = close_price)) +
# #geom_line()
# 
# #####################################################################################
# #NSE PreOpen
# # nsepreopen = suppressWarnings(nseopen(x = "all"))
# # nseopen_fo = suppressWarnings(nseopen("fo"))
# # nselive = suppressWarnings(nselive())
# 
# #####################################################################################
# #Heatmap
# #nsetree = nsetree()
# #nsetreefo = nsetree("fo") 
# 
# #####################################################################################
# #Intraday data (15 min)
# time_series_intraday <- av_get(symbol     = "IBM",
#                                av_fun     = "TIME_SERIES_INTRADAY",
#                                interval   = "15min")
# #outputsize = "full")
# 
# # #####################################################################################
# # #Crypto
# # # Functions --------------------------------------------------------------
# # {
# #   # Pull hourly data
# #   get_crypto_hourly <- function(symbol, av_fun, interval) {
# #     data <- av_get(symbol=symbol, av_fun = av_fun,
# #                    market='USD', interval=interval,
# #                    outputsize='full')
# #     return(data)
# #   }
# #   
# #   # Pull daily data
# #   get_crypto_daily <- function(symbol, av_fun, market) {
# #     data <- av_get(symbol=symbol, av_fun = av_fun,
# #                    market=market, outputsize='full')
# #     # clean some columns
# #     data <- data %>%
# #       select(-c(6:9, 11)) %>%
# #       rename(open = open__usd____2,
# #              high = high__usd____3,
# #              low = low__usd____4,
# #              close = close__usd____5)
# #     return(data)
# #   }
# #   
# #   # Plot interactive candlestick plot
# #   hourly_candle <- function(df) {
# #     df_c <- df %>%
# #       plot_ly(x=~timestamp, type='candlestick',
# #               open=~open, close=~close,
# #               high=~high, low=~low)
# #     
# #     df_c <- df_c %>%
# #       layout(xaxis=list(rangeslider(list(visible=F))))
# #     
# #     df_vol <- df %>%
# #       plot_ly(x=~timestamp, type='bar',
# #               y=~volume)
# #     
# #     fig <- subplot(df_c, df_vol, nrows=2)
# #     fig
# #   }
# #   
# #   
# #   daily_line <- function(df) {
# #     df_daily_l <- df %>%
# #       ggplot(aes(x=timestamp, y=close)) +
# #       geom_line(color='orange') +
# #       theme_minimal()
# #     
# #     df_daily_vol <- df %>%
# #       ggplot(aes(x=timestamp, y=volume)) +
# #       geom_col() +
# #       theme_minimal()
# #     
# #     plt <- ggarrange(df_daily_l, df_daily_vol, nrow=2)
# #     plt
# #   }
# #   
# #   # interval - '60min', daily, weekly, monthly
# #   # time-period - number of past data points
# #   # series_type - close, open, ...
# #   sma <- function(df, time) {
# #     TTR::SMA(df$close, time)
# #   }
# #   
# # }
# # 
# # 
# # # BTC ---------------------------------------------------------------------
# # # BTCUSD hourly data
# # btc_hourly <- get_crypto_hourly('BTC', 'CRYPTO_INTRADAY', '60min')
# # # plot
# # hourly_candle(btc_hourly)
# # 
# # # BTCUSD daily data
# # btc_daily <- get_crypto_daily('BTC', 'DIGITAL_CURRENCY_DAILY', 'USD')
# # # plot
# # daily_line(btc_daily)
# # 
# # 
# # 
# # # DOGE --------------------------------------------------------------------
# # # DOGEUSD hourly
# # 
# # doge_hourly <- get_crypto_hourly('DOGE', 'CRYPTO_INTRADAY', '60min')
# # 
# # hourly_candle(doge_hourly)
# # 
# # # DOGE daily data
# # doge_daily <- get_crypto_daily('DOGE', 'DIGITAL_CURRENCY_DAILY', 'USD')
# # 
# # daily_line(doge_daily)
# # 
# # 
# # # Technical Indicator
# # # Add SMA
# # doge_daily$sma <- sma(doge_daily, 20)
# # doge_daily
# # 
# # plot(doge_daily$timestamp, doge_daily$sma, type = 'l')
# # 
# # doge_daily$ema <- TTR::EMA(doge_daily$close,n=20)
# # 
# # plot(doge_daily$timestamp, doge_daily$ema, type = 'l')
# # 
# # doge_daily %>%
# #   filter(timestamp > as.Date('2021-01-01')) %>%
# #   ggplot(aes(x=timestamp)) +
# #   geom_line(aes(y=close), color='darkgreen') +
# #   geom_line(aes(y=sma, color=), color='red') +
# #   geom_line(aes(y=ema), color='blue')
# # 
# # 
# # 
# # doge_daily1 <- doge_daily %>%
# #   mutate(pct_change = round(((close/lag(close) - 1)*100), 2)) %>%
# #   drop_na() %>%
# #   mutate(norm = (close - min(close)) / (max(close) - min(close)))
# # 
# # doge_daily1 %>%
# #   ggplot(aes(x=timestamp, y=norm)) +
# #   geom_line()
# # 
# # hist(doge_daily1$norm)
# # 
# # a <- doge_daily1 %>%
# #   filter(timestamp > as.Date('2021-03-01')) %>%
# #   ggplot(aes(x=timestamp, y=mean_pct)) +
# #   geom_line()
# # 
# # b <- doge_daily1 %>%
# #   filter(timestamp > as.Date('2021-03-01')) %>%
# #   ggplot() +
# #   geom_line(aes(x=timestamp, y=close), color='red', size=0.4) +
# #   geom_line(aes(x=timestamp, y=open), color='skyblue', size=0.4)
# # 
# # c <- doge_daily1 %>%
# #   filter(timestamp > as.Date('2021-03-01')) %>%
# #   ggplot(aes(x=timestamp, y=volume)) +
# #   geom_line()
# # 
# # #ggarrange(b,a,c, nrow = 3)
# # 
# # #doge_daily1 %>% View()