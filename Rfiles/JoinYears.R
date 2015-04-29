
#Import data
NVM2006 <- read.table(file = "C:\\Users\\Pieter\\Documents\\StreemMaster\\THESIS\\Data\\ConstructedData\\NVM\\NVM2006.txt", quote = "", header=TRUE, sep=";", fill=TRUE)
NVM2007 <- read.table(file = "C:\\Users\\Pieter\\Documents\\StreemMaster\\THESIS\\Data\\ConstructedData\\NVM\\NVM2007.txt", quote = "", header=TRUE, sep=";", fill=TRUE)
NVM2008 <- read.table(file = "C:\\Users\\Pieter\\Documents\\StreemMaster\\THESIS\\Data\\ConstructedData\\NVM\\NVM2008.txt", quote = "", header=TRUE, sep=";", fill=TRUE)
NVM2009 <- read.table(file = "C:\\Users\\Pieter\\Documents\\StreemMaster\\THESIS\\Data\\ConstructedData\\NVM\\NVM2009.txt", quote = "", header=TRUE, sep=";", fill=TRUE)
NVM2010 <- read.table(file = "C:\\Users\\Pieter\\Documents\\StreemMaster\\THESIS\\Data\\ConstructedData\\NVM\\NVM2010.txt", quote = "", header=TRUE, sep=";", fill=TRUE)
NVM2011 <- read.table(file = "C:\\Users\\Pieter\\Documents\\StreemMaster\\THESIS\\Data\\ConstructedData\\NVM\\NVM2011.txt", quote = "", header=TRUE, sep=";", fill=TRUE)
NVM2012 <- read.table(file = "C:\\Users\\Pieter\\Documents\\StreemMaster\\THESIS\\Data\\ConstructedData\\NVM\\NVM2012.txt", quote = "", header=TRUE, sep=";", fill=TRUE)
NVM2013 <- read.table(file = "C:\\Users\\Pieter\\Documents\\StreemMaster\\THESIS\\Data\\ConstructedData\\NVM\\NVM2013.txt", quote = "", header=TRUE, sep=";", fill=TRUE)

#Merge
NVM2006$NEAR_FID <- NULL
NVM2006$NEAR_DIST <- NULL
NVM <- rbind(NVM2006, NVM2007, NVM2008, NVM2009, NVM2010, NVM2011, NVM2012, NVM2013)

#Remove duplicate columns
#NVM <- NVM[, -grep("1$", colnames(NVM))]

#Transform some vars
NVM$logRampDist <- log(NVM1$rampDist)
NVM$logHwDist <- log(NVM1$HwDist)
NVM$logSoundbDist <- log(NVM1$SoundbDist)
NVM$ramp <- factor(NVM1$rampDist < 1000)

#Export to .csv file
write.csv(NVM1, file = "C:\\Users\\Pieter\\Documents\\StreemMaster\\THESIS\\Data\\ConstructedData\\NVM20062013.csv", quote = TRUE)
