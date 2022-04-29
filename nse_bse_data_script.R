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