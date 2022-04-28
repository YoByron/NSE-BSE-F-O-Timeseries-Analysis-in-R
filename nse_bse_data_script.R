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

# Actual Code Starts here

fdii = fdii()
date = fdii[1]
gross_purchase_crores = fdii[2]

