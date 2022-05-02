############################################################
#Dhruv Haldar
#haldar@kth.se
############################################################

packages <- function()
{# Package names
  packages <- c("ggplot2", "readxl", "nser", "lattice", 
                "reshape2", "hablar", "dplyr", 
                "tidyquant","tidyverse", 
                "httr","RCurl",
                "scales",
                "padr", "tcltk",
                "purrr",
                "svDialogs","utils", 
                "quantmod","broom", "magrittr",
                "diffr", "diffobj",
                "alphavantager"
                ,"plotly",
                "ggpubr",
                "derivmkts","TTR",
                "optionstrat","knitr",
                "rmarkdown",
                "reticulate",
                "nse2r",
                "shiny","shinyBS","shinycssloaders",
                "shinythemes",
                "rmarkdown")
  
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
  }

clear <- function()
{#Remove unnecessary variables
  #rm(installed_packages)
  #rm(packages)
  
  #Clear Workspace
  rm(list=ls()) 
  cat("\014")
  
  # Clear all plots
  try(dev.off(dev.list()["RStudioGD"]),silent=TRUE)
  try(dev.off(),silent=TRUE)
  
  options(stringsAsFactors = FALSE)}


netFIIDIIfn <- function(fdii) #function
{
date = fdii[3:20,1]
date <- gsub("-", "", date)                        # Applying gsub function
date = as.Date(date, "%d%b%y")


net_FII = fdii[3:20,4]
net_FII = factor(net_FII)
net_FII <- gsub(",","", net_FII)                   # Applying gsub function
options(digits=7)
net_FII=as.double(net_FII)

net_DII = fdii[3:20,7]
net_DII = factor(net_DII)
net_DII <- gsub(",","", net_DII)                   # Applying gsub function
options(digits=7)
net_DII=as.double(net_DII)

fdii_main <- data.frame(date,net_FII,net_DII)

#netFII+netDII

p <- ggplot(fdii_main,
            aes(x = date, y = net_FII+net_DII)) +
  geom_text(aes(label=net_FII+net_DII),
            vjust=0.006,
            size=3.5,
            color="white")+
  scale_x_date(date_labels="%b %d",date_breaks  ="1 day") +
  labs(x = "Date",
       title = "Gross Purchase FII+DII (Crores)",
       y = "Gross Purchase (Crores)",
       subtitle = paste("Last updated",Sys.time()),
       panel.grid.major = element_blank(),
       panel.grid.minor = element_blank()
  )

p+ theme(legend.position="none")

p+ geom_bar(aes(fill = net_FII+net_DII > 0), stat = "identity") +
  scale_fill_manual(
    guide = "none",
    breaks = c(TRUE, FALSE),
    values=c("green", "red"))
                            
}

# #Remove unnecessary variables
# rm(date)
# rm(fdii)
# rm(fdii_main)

data_bhavtoday_nser <- function() #function
{
  get_data <- function(get_data) 
    {
#FO Bhavcopy Today (updated every evening,not working in weekend)
    fobhavtoday <-- fobhavtoday()

#Indices Data
    fo_indices = fobhavtoday[1:19,]
    }
  get_data2 <- possibly(get_data, otherwise = NA)
}

# FO Bhavcopy Hist. (1 Jan 2016 Onwards)
# Hist_date=28042022
data_bhavtoday_nser <- function() #function
{
  fobhavhist = fobhav(Hist_date)
  bhavhist = bhav(Hist_date)
}

#NSE Markets
markets_today_nser <- function() #function
{
library(nse2r)
options(warn=-1) #supress coercion warnings, fix later
nsepreopen = nse_preopen_nifty(clean_names = TRUE) #preopen NIFTY
nsepreopenbk = nse_preopen_nifty_bank(clean_names = TRUE) #preopen NIFTYBK
nseopen_fo = nseopen("fo") #FO stocks
nselive = nselive() #Nifty stocks
nseipo = nseipo() #ipo
}

# Heatmap
markets_heatmap <- function() #function
{
  nsetree = nsetree()
}
fo_heatmap <- function() #function
{
  nsetreefo = nsetree("fo")
}

# NSE Indices today
cashmarkets_stocks <- function() #function
{
  nseindex = nseindex()
  nseindex_name = nseindex[1:55,1]
  nseindex_change = nseindex[1:55,4]
  nseindex = nse_index_quote(clean_names = TRUE)

#Stock symbol list
  nsestockcode = nse_stock_code(clean_names = TRUE)

#Stock price
  stock_code="SCHAEFFLER"
  stock_price = nse_stock_quote(stock_code, source = c("yahoo",
                                                       "rediff"))
  print(paste(stock_code,"is trading at",
            stock_price,"INR at NSE",", last updated",Sys.time()))

#52 Week high
  nseyearhigh = nse_stock_year_high(clean_names = TRUE)
#52 Week low
  nseyearlow = nse_stock_year_low(clean_names = TRUE)
#Most Traded Stocks
  nsemosttraded = nse_stock_most_traded(clean_names = TRUE)
#Top Gainers
  nsetopgainers = nse_stock_top_gainers(clean_names = TRUE)
#Top Losers
  nsetoplosers = nse_stock_top_losers(clean_names = TRUE)
}

jugaad_data <- function(symbol) #function python-reticulate
{ symbol <- symbol
  #Install "pandas" using pip or anaconda
  reticulate::source_python('~/GitHub/NSE-BSE-Real-Time-prices/jugaad_data_python.py')
}
  


##Data & Function Calls
clear()
packages()
symbol="UPL"
jugaad_data(symbol)

#fdii = fdii()
#netFIIDIIfn(fdii)
#fo_heatmap()
#markets_heatmap()
#markets_today_nser()
#data_bhavtoday_nser()
#cashmarkets_stocks()











#Notes
#Option Chain test
#fo_oi <- head(read.csv("https://www.nseindia.com/api/option-chain-indices?symbol=NIFTY.csv"))


# #ggplot(data = tsla_stock_metrics, aes(x = date, y = close_price)) +
# # geom_line()
# IF US VIX FALLS BELOW 25 = positivity, less voilatility
# Any Change in OI with highest volume, acts as support/resistance 

#tseries package get.hist.quote("IBM")

#py_install("jugaad-data",pip=TRUE)
#source_python("D:/Users/dhruv/Documents/GitHub/
#NSE-BSE-Real-Time-prices/
#jugaad_data_python.py")

## Historical F&O


##Chart Data
#source_python("jugaad_data_python.
#py")
#jugaad_data_python <- read_jugaad_data_python("jugaad_
# data_python.csv")

#py_run_file("jugaad_data_python.py")
#Code end

