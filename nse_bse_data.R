############################################################
#Dhruv Haldar
#haldar@kth.se
############################################################

# Package names
packages <- c("ggplot2", "readxl", "dplyr", "nser", "lattice", 
              "reshape2", "hablar", "dplyr", 
              "tidyquant","tidyverse", "scales",
              "padr", "tcltk", "svDialogs","utils", 
              "quantmod","broom", "magrittr",
              "diffr", "diffobj",
              "alphavantager"
              ,"plotly","ggpubr",
              "derivmkts","TTR",
              "optionstrat","knitr",
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

#Remove unnecessary variables
rm(installed_packages)
rm(packages)

#Clear Workspace
rm(list=ls()) 
cat("\014")

# Clear all plots
try(dev.off(dev.list()["RStudioGD"]),silent=TRUE)
try(dev.off(),silent=TRUE)

############################################################
############################################################

# Actual Code Starts here
options(stringsAsFactors = FALSE)

fdii = fdii()

date = fdii[3:20,1]
date <- gsub("-", "", date)                          # Applying gsub function
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

p+ geom_bar(aes(fill = net_FII > 0), stat = "identity") +
  scale_fill_manual(
    guide = "none",
    breaks = c(TRUE, FALSE),
    values=c("green", "red"))

#netFII

p1 <- ggplot(fdii_main,
            aes(x = date, y = net_FII)) +
  geom_text(aes(label=net_FII),
            vjust=0.006,
            size=3.5,
            color="white")+
  scale_x_date(date_labels="%b %d",date_breaks  ="1 day") +
  labs(x = "Date",
       title = "FII (Crores)",
       y = "Purchase (Crores)",
       subtitle = paste("Last updated",Sys.time()),
       panel.grid.major = element_blank(),
       panel.grid.minor = element_blank()
  )

#p1+ theme_classic()

p1+ geom_bar(aes(fill = net_FII > 0), stat = "identity") +
  scale_fill_manual(
    guide = "none",
    breaks = c(TRUE, FALSE),
    values=c("green", "red"))

############################################################

# #Remove unnecessary variables
# rm(date)
# rm(fdii)
# rm(fdii_main)

# ############################################################
# # FO Bhavcopy Hist. (1 Jan 2016 Onwards)
# Hist_date=28042022
# fobhavhist = fobhav(Hist_date)
# bhavhist = bhav(Hist_date)
# ############################################################
# #FO Bhavcopy Today (updated every evening)
# fobhavtoday = fobhavtoday()
# 
# ############################################################
# #NSE Indices today
# nseindex = nseindex()
# nseindex_name = nseindex[1:55,1]
# nseindex_change = nseindex[1:55,4]
# 
# 
# #Stock price chart
# #ggplot(data = tsla_stock_metrics, aes(x = date, y = close_price)) +
# # geom_line()
# 
# ############################################################
#NSE
options(warn=-1) #supress coercion warnings, fix later
nsepreopen = nseopen(x = "all") #preopen
nseopen_fo = nseopen("fo") #FO stocks
nselive = nselive() #Nifty stocks
nseipo = nseipo() #ipo
# ############################################################
# #Heatmap
# #nsetree = nsetree()
#nsetreefo = nsetree("fo")

# IF US VIX FALLS BELOW 25 = positivity, less voilatility
# Any Change in OI with highest volume, acts as support/resistance  