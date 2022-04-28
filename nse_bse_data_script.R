####################################################################################
#Dhruv Haldar
#haldar@kth.se
####################################################################################
# Package names
packages <- c("ggplot2", "readxl", "dplyr", "nser", "lattice", "reshape2", "hablar", "dplyr")

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

date = fdii[3:20,1]
date=factor(date)

gross_purchase_crores = fdii[3:20,2]
gross_purchase_crores = factor(gross_purchase_crores)

df <- data.frame(
  date,
  gross_purchase_crores
)

#sapply(df, class)

#df[] <- lapply(df, function(x) as.numeric(as.character(x)))
#df
#sapply(df, class)

df %>% 
  convert(num(date, gross_purchase_crores))


#gross_purchase_crores = fdii[3:20,2]
#gross_purchase_crores = factor(gross_purchase_crores)


#plot(date,gross_purchase_crores)

#Plot
#hist(gross_purchase_crores,
#     main="Gross Purchase (In Crores)",
#     xlab="Gross Purchase (In Crores)"
#    )

#ggplot(aes(date, gross_purchase_crores)) +
#geom_histogram()
#plot.default(date,gross_purchase_crores,axes=TRUE, xlab = "Date", ylab= "Gross Purchase in Crores")
#geom_histogram()

### Select Rows 1 to 2
#df[1:2,]