# Package names
packages <- c("ggplot2", "rvest",
              "nse2r"
)

# Install packages not yet installed
installed_packages <- packages %in% rownames(installed.packages())
if (any(installed_packages == FALSE)) {
  install.packages(packages[!installed_packages])
}

# Packages loading
invisible(lapply(packages, library, character.only = TRUE))

library(rvest)

link <- read_html("https://www.moneycontrol.com/stocks/marketstats/indexcomp.php?optex=NSE&opttopic=indexcomp&index=9")
link %>%
  html_node("title") %>%
  html_text()
urls <-  link %>%
  html_node(xpath = '//*[@id="mc_mainWrapper"]/div[3]/div[1]/div[6]/div[2]/div/table') %>%
  html_table()

urls

dim(urls)

# Init an empty stock list
stock_list = {}

for (items in c(1:nrow(urls))) {
  # Extract name of scrip
  stock_name <- as.character(urls[items,1])
  
  stock_name <- gsub(pattern = "list|Add to Watch|Add to Portfolio|\n|\t|\r", replacement = "", x = stock_name)
  print(paste0("stock names : ", stock_name))  
  stock_list[items] <- stock_name
}

length(stock_list)
stock_list[50]

# Create dataframe of stock list
df_nifty50 <- data.frame(stock_names=stock_list,urls[2:6])
dim(df_nifty50)

names(df_nifty50)

head(df_nifty50)

df_nifty50