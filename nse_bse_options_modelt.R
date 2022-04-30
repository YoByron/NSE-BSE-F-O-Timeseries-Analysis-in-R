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

############################################################
#Option Strategy Builder

#CE Buy Price
#cebuyprice = scan(prompt="Input CE Buy Price: ")
CE_buy_stoploss <- function(cebuyprice) {
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
}
#CE Sell Price
#cesellprice = scan(prompt="Input CE Sell Price: ")
CE_sell_stoploss <- function(cesellprice) {
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
}
# Option strategy 1 : Bull Call Spread Code

BullCallSpread <- function(seq,k_low,k_high,premium_low,
                           premium_high) {
  # Intrinsic Value and Payoff long call
  intrinsicValueLongCall <- prices - k_low - premium_low
  payoffLongCall <- pmax(-premium_low,intrinsicValueLongCall)
  
  # Intrinsic Value and Payoff short call
  intrinsicValueShortCall <- prices - k_high - premium_high
  payoffShortCall <- pmin(premium_high,
                          -intrinsicValueShortCall)
  
  # Strategy Payoff
  payoff <- rowSums(cbind(payoffLongCall,
                          payoffShortCall))
  
  # Generate a dataframe with 
  #the payoffLongCall, payoffShortCall and payoff vectors
  # in order to plot the strategy payoffs using ggplot
  
  results <- data.frame(cbind(payoffLongCall,
                              payoffShortCall,payoff))
  ggplot(results, aes(x=prices)) + 
    geom_line(aes(y = payoffLongCall, 
                  color = "LongCall")) + 
    geom_line(aes(y = payoffShortCall, 
                  color="ShortCall"))+
    geom_line(aes(y=payoff, color = 'Payoff'), lwd=1) +
    scale_colour_manual("", breaks = c("LongCall", 
                                       "ShortCall", 
                                       "Payoff"),
                        values = c("red", 
                                   "green", 
                                   "blue")) + 
    ylab("Payoff")+
    ggtitle("Bull Call Spread Payoff")  
}  

# Option strategy 2 : Long Straddle Code
LongStraddle <- function(prices,strike,premium_call,
                             premium_put) {   
  
# call option payoff at expiration 
intrinsicValuesCall <- prices - strike - premium_call
payoffLongCall <- pmax(-premium_call,
                         intrinsicValuesCall)
  
# put option payoff at expiration
intrinsicValuesPut <- strike - prices - premium_put
payoffLongPut <- pmax(-premium_put,
                        intrinsicValuesPut)
  
# The payoff of the Strategy is 
#the sum of the call and put payoff. Need
# to sum wise element by element between the two vectors
payoff <- rowSums(cbind(payoffLongCall,
                          payoffLongPut))
  
# Make a DataFrame with all the variable to plot it with ggplot
results <- data.frame(cbind(prices,
                              payoffLongCall,
                              payoffLongPut,payoff))
  
ggplot(results, aes(x=prices)) + 
geom_line(aes(y = payoffLongCall, color = "LongCall")) + 
geom_line(aes(y = payoffLongPut, color="LongPut"))+
    geom_line(aes(y=payoff, color = 'Payoff'), size=1.5) +
    scale_colour_manual("", 
                        breaks = c("LongCall",
                                   "LongPut", 
                                   "Payoff"),
                        values = c("darkred", 
                                   "darkblue", 
                               "darkgreen")) + ylab("Payoff")+
ggtitle("Long Straddle Payoff")  
}

#Option Greeks
Option_greeks <- function(s,k,v,r,tt,d,S){
greeks(bscall(s, k, v, r, tt, d), 
       complete=FALSE, long=FALSE, initcaps=TRUE)
greeks2(bscall, list(s=s, 
                     k=k, v=v, r=r, tt=tt, d=d))
greeks2(bscall, list(s=s, 
                     k=k, v=v, 
                     r=r, tt=tt, 
                     d=d))[c('Delta', 'Gamma'), ]
bsopt(s, k, v, r, tt, d)
bsopt(s, c(35, 40, 45), v, r, tt, d)
bsopt(s, c(35, 40, 45), v, r, 
      tt, d)[['Call']][c('Delta', 'Gamma'), ]

}

## This plot can generate a "figure margins too large" error
## in Rstudio
Option_greeks2 <- function(s,k,v,r,tt,d,S){
Call <- greeks(bscall(S, k, v, r, tt, d))
Put <- greeks(bsput(S, k, v, r, tt, d))
y <- list(Call=Call, Put=Put)
par(mfrow=c(4, 4), mar=c(2, 2, 2, 2))  ## create a 4x4 plot
for (i in names(y)) {
  for (j in rownames(y[[i]])) {  ## loop over greeks
    plot(S, y[[i]][j, ], main=paste(i, j), ylab=j, type='l')
  }
}
## Not run: 
## Using complete option for calls
call_long <- greeks(bscall(S, k, v, r, tt, d), long=TRUE)
ggplot2::ggplot(call_long, aes(x=s, y=value)) +
  geom_line() + facet_wrap(~greek, scales='free')

## End(Not run)
}
########################Data starts here########################
#Option Stoploss
#Buy CE
cebuyprice = 36.5
CE_buy_stoploss(cebuyprice)

#Buy PE
cesellprice = 42
CE_sell_stoploss(cesellprice)

#Option strategy 1 : Bull Call Spread DATA
prices <- seq(400, 550,1) # Vector of prices
k_low = 450  # Low Strike price for call
k_high = 500 # High Strike Price for call 
premium_low = 10
premium_high = 1

BullCallSpread(seq,k_low,k_high,premium_low,
               premium_high) #function

#Option strategy 2 : Long Straddle DATA
prices = 0
strike = 0
prices <- seq(700,950,1) # Vector of prices
strike <- 850 # strike price for both put and call 
premium_call <- 20 # option price call
premium_put <- 10  # option price put

LongStraddle(prices,strike,premium_call,
                         premium_put) #function

#Option Greeks
s=40; k=40; v=0.30; r=0.08; tt=0.25; d=0;
Option_greeks(s,k,v,r,tt,d)

## plot Greeks for calls and puts for 500 different stock prices
k <- 100; v <- 0.30; r <- 0.08; tt <- 2; d <- 0
S <- seq(.5, 250, by=.5)
Option_greeks2(s,k,v,r,tt,d,S)

#Optionstrat
# Utilizes the Black-Scholes-Merton option pricing model to
# calculate key option analytics and
#perform graphical analysis of various option strategies.
# Provides functions to calculate the option premium and option
# greeks of European-style options.


#Binomial Option Pricing Model in R
build_stock_tree <- function(S, sigma, delta_t, N) {
  tree = matrix(0, nrow=N+1, ncol=N+1)
  U = exp(sigma*sqrt(delta_t))
  D = exp(-sigma*sqrt(delta_t))
  for (i in 1:(N+1)) {
    for (j in 1:i) {
      tree[i, j] = S * U^(j-1) * D^((i-1)-(j-1))
    }  }
  return(tree)
}

q_prob <- function(r, delta_t, sigma) {
  u = exp(sigma*sqrt(delta_t))
  d = exp(-sigma*sqrt(delta_t))
  return((exp(r*delta_t) - d)/(u-d))
}

value_binomial_option <- function(tree, 
                                  sigma, 
                                  delta_t, r, X, type) {
  q = q_prob(r, delta_t, sigma)
  option_tree = matrix(0, 
                       nrow=nrow(tree), ncol=ncol(tree))
  if(type == 'put') {
    option_tree[nrow(option_tree),
                ] = pmax(X - tree[nrow(tree),], 0)
  } else {  option_tree[nrow(option_tree),
                        ] = pmax(tree[nrow(tree),] - X, 0)
  }
  for (i in (nrow(tree)-1):1) {
    for(j in 1:i) {
      option_tree[i,
                  j]=((1-q)*option_tree[i+1,j] +
                        q*option_tree[i+1,
                                      j+1])/exp(r*delta_t)
    }
  }
  return(option_tree)
}

#probability of an up movement in the price(q) 
#and the probability of a down movement in the  price(1-q) 
#on the next period divided by R
binomial_option <- function(type, sigma, T,
                            r, X, S, N) {
  sigma=0.15 
  type='call'
  X=100
  T=1 
  r=0.1
  S=110
  N=5
  q <- q_prob(r=r, delta_t=T/N, sigma=sigma)
  tree <- build_stock_tree(S=S, sigma=sigma, 
                           delta_t=T/N, N=N)
  option <- value_binomial_option(tree, 
                                  sigma=sigma, 
                                  delta_t=T/N, 
                                  r=r, X=X, type=type)
  return(list(q=q, stock=tree, option=option, price=option[1,1]))
}

results <- binomial_option(type='call', 
                           sigma=0.15, 
                           T=1, 
                           r=0.1, X=100, S=110, N=5)



