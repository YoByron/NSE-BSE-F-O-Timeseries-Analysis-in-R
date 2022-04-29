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

cat("\014") #Clear Workspace

#Option Strategy Builder
# R program to illustrate
# taking Option input from the user
# using braces
{
  cebuyprice = scan("Enter Buy Price : ")
  #var2 = readline("Enter 2nd number : ");
  #var3 = readline("Enter 3rd number : ");
  #var4 = readline("Enter 4th number : ");
}

#cebuyprice=34.33

# converting each value
cebuyprice = as.numeric(cebuyprice)

# print the sum of the 4 number
print("D",cebuyprice)
