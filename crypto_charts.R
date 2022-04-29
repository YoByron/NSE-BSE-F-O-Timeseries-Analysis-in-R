

############################################################
#Intraday data (15 min)
time_series_intraday <- av_get(symbol     = "IBM",
                               av_fun     = "TIME_SERIES_INTRADAY",
                               interval   = "15min")

############################################################
#Crypto Functions
{
  # Pull hourly data
  get_crypto_hourly <- function(symbol, av_fun, interval) {
    data <- av_get(symbol=symbol, av_fun = av_fun,
                   market='USD', interval=interval,
                   outputsize='full')
    return(data)
  }
  
  # Pull daily data
  get_crypto_daily <- function(symbol, av_fun, market) {
    data <- av_get(symbol=symbol, av_fun = av_fun,
                   market=market, outputsize='full')
    # clean some columns
    data <- data %>%
      select(-c(6:9, 11)) %>%
      rename(open = open__usd____2,
             high = high__usd____3,
             low = low__usd____4,
             close = close__usd____5)
    return(data)
  }
  
  # Plot interactive candlestick plot
  hourly_candle <- function(df) {
    df_c <- df %>%
      plot_ly(x=~timestamp, type='candlestick',
              open=~open, close=~close,
              high=~high, low=~low)
    
    df_c <- df_c %>%
      layout(xaxis=list(rangeslider(list(visible=F))))
    
    df_vol <- df %>%
      plot_ly(x=~timestamp, type='bar',
              y=~volume)
    
    fig <- subplot(df_c, df_vol, nrows=2)
    fig
  }
  
  
  daily_line <- function(df) {
    df_daily_l <- df %>%
      ggplot(aes(x=timestamp, y=close)) +
      geom_line(color='orange') +
      theme_minimal()
    
    df_daily_vol <- df %>%
      ggplot(aes(x=timestamp, y=volume)) +
      geom_col() +
      theme_minimal()
    
    plt <- ggarrange(df_daily_l, df_daily_vol, nrow=2)
    plt
  }
  
  # interval - '60min', daily, weekly, monthly
  # time-period - number of past data points
  # series_type - close, open, ...
  sma <- function(df, time) {
    TTR::SMA(df$close, time)
  }
  
}


# BTC ---------------------------------------------------------------------
# BTCUSD hourly data
btc_hourly <- get_crypto_hourly('BTC', 'CRYPTO_INTRADAY', '60min')
# plot
hourly_candle(btc_hourly)

# BTCUSD daily data
btc_daily <- get_crypto_daily('BTC', 'DIGITAL_CURRENCY_DAILY', 'USD')
# plot
daily_line(btc_daily)



# DOGE --------------------------------------------------------------------
# DOGEUSD hourly

doge_hourly <- get_crypto_hourly('DOGE', 'CRYPTO_INTRADAY', '60min')

hourly_candle(doge_hourly)

# DOGE daily data
doge_daily <- get_crypto_daily('DOGE', 'DIGITAL_CURRENCY_DAILY', 'USD')

daily_line(doge_daily)


# Technical Indicator
# Add SMA
doge_daily$sma <- sma(doge_daily, 20)
doge_daily

plot(doge_daily$timestamp, doge_daily$sma, type = 'l')

doge_daily$ema <- TTR::EMA(doge_daily$close,n=20)

plot(doge_daily$timestamp, doge_daily$ema, type = 'l')

doge_daily %>%
  filter(timestamp > as.Date('2021-01-01')) %>%
  ggplot(aes(x=timestamp)) +
  geom_line(aes(y=close), color='darkgreen') +
  geom_line(aes(y=sma, color=), color='red') +
  geom_line(aes(y=ema), color='blue')



doge_daily1 <- doge_daily %>%
  mutate(pct_change = round(((close/lag(close) - 1)*100), 2)) %>%
  drop_na() %>%
  mutate(norm = (close - min(close)) / (max(close) - min(close)))

doge_daily1 %>%
  ggplot(aes(x=timestamp, y=norm)) +
  geom_line()

hist(doge_daily1$norm)

a <- doge_daily1 %>%
  filter(timestamp > as.Date('2021-03-01')) %>%
  ggplot(aes(x=timestamp, y=mean_pct)) +
  geom_line()

b <- doge_daily1 %>%
  filter(timestamp > as.Date('2021-03-01')) %>%
  ggplot() +
  geom_line(aes(x=timestamp, y=close), color='red', size=0.4) +
  geom_line(aes(x=timestamp, y=open), color='skyblue', size=0.4)

c <- doge_daily1 %>%
  filter(timestamp > as.Date('2021-03-01')) %>%
  ggplot(aes(x=timestamp, y=volume)) +
  geom_line()

#ggarrange(b,a,c, nrow = 3)

#doge_daily1 %>% View()