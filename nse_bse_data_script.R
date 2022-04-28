####################################################################################
#Dhruv Haldar
#haldar@kth.se
####################################################################################
# Package names
packages <- c("ggplot2", "readxl", "dplyr", "nser", "lattice", "reshape2", "hablar", "dplyr", "tidyverse")

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

gross_purchase_crores = fdii[3:20,2]
gross_purchase_crores = factor(gross_purchase_crores)
gross_purchase_crores <- gsub(",","", gross_purchase_crores)                   # Applying gsub function
options(digits=7)
gross_purchase_crores=as.double(gross_purchase_crores)

h <- hist(gross_purchase_crores,
          main="Gross Purchase (In Crores)",
          xlab="Gross Purchase (In Crores)",
          col="darkmagenta"
)

text(h$mids,h$counts,labels=h$counts, adj=c(0.5, -0.5))

df <- data.frame(date, gross_purchase_crores)

# plot the data using ggplot
ggplot(data = df, aes(x = date, y = gross_purchase_crores)) +
  geom_bar(stat = "identity", fill = "purple") +
  scale_x_date(date_breaks  ="1 day") +
  labs(x = "Date",
       y = "Gross Purchase (Crores)",
       title = "Gross Purchase (Crores)",
       subtitle = "FII")

#Plot
#hist(dateP, gross_purchase_crores,
     

#ggplot(aes(date, gross_purchase_crores)) +
#geom_histogram()
#plot.default(date,gross_purchase_crores,axes=TRUE, xlab = "Date", ylab= "Gross Purchase in Crores")
#geom_histogram()

### Select Rows 1 to 2
#df[1:2,]