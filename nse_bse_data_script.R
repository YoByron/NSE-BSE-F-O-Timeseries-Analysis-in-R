####################################################################################
#Dhruv Haldar
#haldar@kth.se
####################################################################################
# Package names
packages <- c("ggplot2", "readxl", "dplyr", "nser", "lattice", "reshape2")

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

fdii = fdii()

#df <- data.frame(
#  date = factor(date(fdii[3:20,1])),
#  gross_purchase_crores = factor(gross_purchase_crores(fdii[3:20,2]))
#)


date = fdii[3:20,1]
date=factor(date)
gross_purchase_crores = fdii[3:20,2]
gross_purchase_crores = factor(gross_purchase_crores)
gross_purchase_crores = as.numeric(gross_purchase_crores)

#Plot
hist(gross_purchase_crores)

#ggplot(aes(date, gross_purchase_crores)) +
#geom_histogram()

#plot.default(date,gross_purchase_crores,axes=TRUE, xlab = "Date", ylab= "Gross Purchase in Crores")
#geom_histogram()

### Select Rows 1 to 2
#df[1:2,]