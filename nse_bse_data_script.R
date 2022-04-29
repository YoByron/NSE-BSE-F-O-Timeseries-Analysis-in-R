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

#Remove unnecessary variables
rm(installed_packages)
rm(packages)

#Clear Workspace
rm(list=ls()) 
cat("\014")

#####################################################################################
#Option Strategy Builder

#CE Buy Price
#cebuyprice = scan(prompt="Input CE Buy Price: ")
cebuyprice = 36.5

cebuytriggerprice = cebuyprice*0.5
cebuySLprice = cebuyprice/2 - 0.1
cebuyLogic <- cebuytriggerprice >= cebuySLprice

print("#########NIFTY Buy CE Stoploss#########")
if (cebuyLogic==TRUE) {
  print(paste("SL price",
              cebuySLprice,"and the Trigger price",
              cebuytriggerprice,
              "for CE Buy of",cebuyprice))
  } 

#CE Sell Price
#cesellprice = scan(prompt="Input CE Sell Price: ")

cesellprice = 42

cesellSLprice = cesellprice*2 + 0.1
ceselltriggerprice = cesellprice*2
cesellLogic <- ceselltriggerprice <= cesellSLprice

print("#########NIFTY Sell CE Stoploss#########")
if (cesellLogic==TRUE) {
  print(paste("SL price",
              cesellSLprice,
              "and the Trigger price",
              ceselltriggerprice,
              "for CE Sell of",cesellprice))
} 

#Option strategy 1 : Bull Call Spread

prices <- seq(400, 550,1) # Vector of prices
k_low = 450  # Low Strike price for call
k_high = 500 # High Strike Price for call 
premium_low = 10
premium_high = 1

# Intrinsic Value and Payoff long call
intrinsicValueLongCall <- prices - k_low - premium_low
payoffLongCall <- pmax(-premium_low,intrinsicValueLongCall)

# Intrinsic Value and Payoff short call
intrinsicValueShortCall <- prices - k_high - premium_high
payoffShortCall <- pmin(premium_high,-intrinsicValueShortCall)

# Strategy Payoff
payoff <- rowSums(cbind(payoffLongCall,payoffShortCall))

# Generate a dataframe with the payoffLongCall, payoffShortCall and payoff vectors
# in order to plot the strategy payoffs using ggplot

results <- data.frame(cbind(payoffLongCall,payoffShortCall,payoff))
ggplot(results, aes(x=prices)) + 
  geom_line(aes(y = payoffLongCall, color = "LongCall")) + 
  geom_line(aes(y = payoffShortCall, color="ShortCall"))+
  geom_line(aes(y=payoff, color = 'Payoff'), lwd=1) +
  scale_colour_manual("", 
                      breaks = c("LongCall", "ShortCall", "Payoff"),
                      values = c("red", "green", "blue")) + ylab("Payoff")+
  ggtitle("Bull Call Spread Payoff")  

#Option strategy 2 : Long Straddle
prices = 0
strike = 0
prices <- seq(700,950,1) # Vector of prices
strike <- 850 # strike price for both put and call 
premium_call <- 20 # option price call
premium_put <- 10  # option price put 

# call option payoff at expiration 
intrinsicValuesCall <- prices - strike - premium_call
payoffLongCall <- pmax(-premium_call,intrinsicValuesCall)

# put option payoff at expiration
intrinsicValuesPut <- strike - prices - premium_put
payoffLongPut <- pmax(-premium_put,intrinsicValuesPut)

# The payoff of the Strategy is the sum of the call and put payoff. Need
# to sum wise element by element between the two vectors
payoff <- rowSums(cbind(payoffLongCall,payoffLongPut))

# Make a DataFrame with all the variable to plot it with ggplot
results <- data.frame(cbind(prices,payoffLongCall,payoffLongPut,payoff))

ggplot(results, aes(x=prices)) + 
  geom_line(aes(y = payoffLongCall, color = "LongCall")) + 
  geom_line(aes(y = payoffLongPut, color="LongPut"))+
  geom_line(aes(y=payoff, color = 'Payoff')) +
  scale_colour_manual("", 
                      breaks = c("LongCall", "LongPut", "Payoff"),
                      values = c("darkred", "darkblue", "darkgreen")) + ylab("Payoff")+
  ggtitle("Long Straddle Payoff")  
