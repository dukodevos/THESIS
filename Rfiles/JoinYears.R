# Author: Duco de Vos
# Description: Script to concatenate NVM year subsets, including sound barrier, highway and ramp distance (added in ArcGIS) 

#Load libraries
library(foreign)

#Import data
NVM2005 <- read.dbf(file = "C:\\Users\\Pieter\\Documents\\StreemMaster\\THESIS\\Data\\ArcGisProjects\\CalculateDistances\\data\\NVM_2005.dbf")
NVM2006 <- read.dbf(file = "C:\\Users\\Pieter\\Documents\\StreemMaster\\THESIS\\Data\\ArcGisProjects\\CalculateDistances\\data\\NVM_2006.dbf")
NVM2007 <- read.dbf(file = "C:\\Users\\Pieter\\Documents\\StreemMaster\\THESIS\\Data\\ArcGisProjects\\CalculateDistances\\data\\NVM_2007.dbf")
NVM2008 <- read.dbf(file = "C:\\Users\\Pieter\\Documents\\StreemMaster\\THESIS\\Data\\ArcGisProjects\\CalculateDistances\\data\\NVM_2008.dbf")
NVM2009 <- read.dbf(file = "C:\\Users\\Pieter\\Documents\\StreemMaster\\THESIS\\Data\\ArcGisProjects\\CalculateDistances\\data\\NVM_2009.dbf")
NVM2010 <- read.dbf(file = "C:\\Users\\Pieter\\Documents\\StreemMaster\\THESIS\\Data\\ArcGisProjects\\CalculateDistances\\data\\NVM_2010.dbf")
NVM2011 <- read.dbf(file = "C:\\Users\\Pieter\\Documents\\StreemMaster\\THESIS\\Data\\ArcGisProjects\\CalculateDistances\\data\\NVM_2011.dbf")
NVM2012 <- read.dbf(file = "C:\\Users\\Pieter\\Documents\\StreemMaster\\THESIS\\Data\\ArcGisProjects\\CalculateDistances\\data\\NVM_2012.dbf")
NVM2013 <- read.dbf(file = "C:\\Users\\Pieter\\Documents\\StreemMaster\\THESIS\\Data\\ArcGisProjects\\CalculateDistances\\data\\NVM_2013.dbf")

#Merge
NVM <- rbind(NVM2005, NVM2006, NVM2007, NVM2008, NVM2009, NVM2010, NVM2011, NVM2012, NVM2013)

#Transform some vars
NVM$logrampDist <- log(NVM$rampDist)
NVM$logrampDist1 <- log(NVM$rampDist1)
NVM$logrampDist2 <- log(NVM$rampDist2)
NVM$loghwDist <- log(NVM$hwDist)
NVM$loghwDist1 <- log(NVM$hwDist1)
NVM$loghwDist2 <- log(NVM$hwDist2)
names(NVM)[names(NVM) == "soundDist1"] <- "soundbDist1"
names(NVM)[names(NVM) == "soundDist2"] <- "soundbDist2"
NVM$logsoundbDist <- log(NVM$soundbDist)
NVM$logsoundbDist1 <- log(NVM$soundbDist1)
NVM$logsoundbDist2 <- log(NVM$soundbDist2)
NVM$ramp <- factor(NVM$rampDist < 1000)
NVM$pc5 <- substr(NVM$pc6, 1, 5)
NVM$soundbDif1 <-  
NVM$soundbDif2 <- 
  
#nearsound.cat <- function(x, lower = 0, upper, by = 100,  
#  labs <- c(paste(seq(lower, upper - by, by = by),
#                  seq(lower + by - 1, upper - 1, by = by),
#                  sep = sep),
#            paste(upper, above.char, sep = ""))
#  
#  cut(floor(x), breaks = c(seq(lower, upper, by = by), Inf),
#      right = FALSE, labels = labs)
#}

#To do fix nice var
#NVM$rightside <- NVM$soundbDist <= NVM$hwDist
#NVM$rightside1 <- NVM$soundDist1 <= NVM$hwDist1
#NVM$rightside2 <- NVM$soundDist2 <= NVM$hwDist2
#NVM$nearsound <- factor(as.numeric(nearsound.cat(NVM$soundbDist, upper = 600))*as.numeric(NVM$rightside))

#Export to .csv file
write.dta(NVM, file = "C:\\Users\\Pieter\\Documents\\StreemMaster\\THESIS\\Data\\ConstructedData\\NVM20052013.dta")
write.csv(NVM, file = "C:\\Users\\Pieter\\Documents\\StreemMaster\\THESIS\\Data\\ConstructedData\\NVM20052013.csv", quote = TRUE)