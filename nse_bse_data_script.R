####################################################################################
#Dhruv Haldar
#haldar@kth.se
####################################################################################
# Package names
packages <- c("ggplot2", "readxl", "dplyr", "nser", "lattice", 
              "reshape2", "hablar", "dplyr", "tidyverse", "scales",
              "padr")

# Install packages not yet installed
installed_packages <- packages %in% rownames(installed.packages())
if (any(installed_packages == FALSE)) {
  install.packages(packages[!installed_packages])
}

# Packages loading
invisible(lapply(packages, library, character.only = TRUE))

# Clear Workspace 
rm(list=ls()) 
#####################################################################################

# Actual Code Starts here
options(stringsAsFactors = FALSE)

fdii = fdii()

date = fdii[3:20,1]
date <- gsub("-", "", date)                          # Applying gsub function
date = as.Date(date, "%d%b%y")
date=pad(date)


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


# plot the data using ggplot
ggplot(data = df,
       aes(x = date, y = net_FII)) +
       geom_bar(stat = "identity", fill = "purple") +
       scale_x_date(date_labels="%b %d",date_breaks  ="1 day") 
       labs(x = "Date",
            y = "Gross Purchase (Crores)",
            title = "Gross Purchase (Crores)",
            subtitle = "FII"
       )