#packages <- c("quantmod","PerformanceAnalytics","dygraphs",
#              "MASS","robustbase")

library(quantmod)
library(PerformanceAnalytics)
library(dygraphs)
monthly_returns <- function(ticker, base_year)
{
  # Obtain stock price data from Yahoo! Finance
  stock <- getSymbols(ticker, src = "yahoo", auto.assign = FALSE) 
  # Remove missing values
  stock <- na.omit(stock)
  # Keep only adjusted closing stock prices
  stock <- stock[, 6]
  
  # Confine our observations to begin at the base year and end at the last available trading day
  horizon <- paste0(as.character(base_year), "/", as.character(Sys.Date()))
  stock <- stock[horizon]
  
  # Calculate monthly arithmetic returns
  data <- periodReturn(stock, period = "monthly", type = "arithmetic")
  
  # Assign to the global environment to be accessible
  assign(ticker, data, envir = .GlobalEnv)
}

# Call our function for each stock
monthly_returns("SBUX", 2015)
monthly_returns("CCL", 2015)
monthly_returns("AAPL", 2015)

# Get S&P 500 Data
monthly_returns("SPY", 2015)

# Merge all the data and rename columns
returns <- merge.xts(SBUX, CCL, AAPL, SPY)
colnames(returns) <- c("SBUX", "CCL", "AAPL", "SP500")

# Produce interactive chart of stock returns
dygraph(returns, main = "Starbucks vs. Carnival vs. Apple vs. S&P 500") %>%
  dyAxis("y", label = "Return", valueRange = c(-1,0.5)) %>%
  dyRangeSelector(dateWindow = c("2015-01-01", "2020-07-01")) %>%
  dyOptions(colors = RColorBrewer::brewer.pal(4, "Set2")) 

# Print last 5 rows of the data, rounded to 4 decimal places
round(tail(returns, n = 5), 4)

# Assign weights
wts <- c(1/3, 1/3, 1/3)

# Construct a portfolio using our returns object and weights
# Only select first three columns to isolate our individual stock data
portfolio_returns <- Return.portfolio(R = returns[,1:3], weights = wts, wealth.index = TRUE)

# Then isolate our S&P 500 data
benchmark_returns <- Return.portfolio(R = returns[,4], wealth.index = TRUE)

# Merge the two
comp <- merge.xts(portfolio_returns, benchmark_returns)
colnames(comp) <- c("Portfolio", "Benchmark")

# Build an interactive graph to compare performance
dygraph(comp, main = "Portfolio Performance vs. Benchmark") %>%
  dyAxis("y", label = "Amount ($)")

## Measuring Financial Risk
library(ggplot2)

wilshire <- getSymbols(Symbols = "WILL5000IND", src = "FRED", auto.assign = FALSE)
wilshire <- na.omit(wilshire)
wilshire <- wilshire["1980-01-01/2020-06-01"]

ggplot(data = wilshire, aes(x = Index, y = WILL5000IND)) +
  geom_line(size = 1.0) +
  xlab("") + 
  ylab("") +
  ggtitle("Wilshire 5000 Index")
# Calculate daily log returns
log_returns <- diff(log(wilshire))[-1]

# Calculate mean and std. deviation
mu <- round(mean(log_returns), 6) # Mean: 0.000428
sigma <- round(sd(log_returns), 6) # Standard Deviation: 0.011063

# Produce histogram of returns overlaid with a kernel density plot
ggplot(data = log_returns, aes(x = WILL5000IND)) +
  geom_histogram(aes(y = ..density..),
                 binwidth = 0.01,
                 color = "black",
                 fill = "lightblue") +
  geom_density(size = 1.0) + 
  xlab("Daily Log Returns") +
  ggtitle("Wilshire 5000 Index",
          subtitle = "Mean = 0.000428, Std. Deviation = 0.011063")

library(moments)

# Print skewness and kurtosis
cat("Skewness:", skewness(log_returns),
    "Kurtosis:", kurtosis(log_returns),
    sep = "\n")

# Perform Jarque-Bera test of normality
jarque.test(as.vector(log_returns))

# Method 1: Sampling from the empirical distribution

# Set seed to ensure reproducibility
set.seed(123)

# 95% confidence level
alpha <- 0.05

# Take a random sample of 100,000 observations from the empirical distribution with replacement
sample.empirical <- sample(as.vector(log_returns), 1000000, replace = TRUE)

# Calculate VaR 
VaR.empirical <- round(quantile(sample_returns, alpha), 6)

# Calculate ES
ES.empirical <- round(mean(sample.empirical[sample.empirical < VaR.empirical]), 6)

# Print results
cat("Value at Risk:", 
    VaR.empirical, 
    "Expected Shortfall:", ES.empirical, sep = "\n")

#This tells us that the 1-day 
#VaR for the Wilshire 5000 is -1.64 
#at the 95% confidence level 
#and the ES is -2.67%. 
#In words, this means we shouldn’t 
#expect to suffer a decline worse 
#than 1.64% on any given trading day 
#95% of the time. 
#Our ES states tells us 1-day 
#declines of more than 2% are 
#possible, but very unlikely.

# Method 2 Sampling from the student-t distribution
# Loading packages
library(MASS)
library(metRology)

# Fit Student-t distribution to log returns data
t.fit <- fitdistr(as.vector(log_returns), "t")

# Scale distribution based on 100,000 observation sample
sample.t <- rt.scaled(100000, mean = t.fit$estimate[1], sd = t.fit$estimate[2], df = t.fit$estimate[3])

# Calculate VaR and ES based on this distribution
VaR.t <- quantile(sample.t, alpha)
ES.t <- round(mean(sample.t[sample.t < VaR.t]), 6)

# Print results
cat("Value at Risk:", VaR.t, "Expected Shortfall:", ES.t, sep = "\n")

# Applying results
portfolio <- 1000

# Use VaR and ES from empirical distribution
VaR.portfolio <- portfolio * (exp(VaR.empirical) - 1)
ES.portfolio <- portfolio * (exp(ES.empirical) - 1)

# Print results
cat("Value at Risk:", 
    VaR.portfolio, "Expected Shortfall:",
    ES.portfolio, sep = "\n")