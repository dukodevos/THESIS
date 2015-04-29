#Load libraries
library(plyr)
library(lubridate)

#Import NVM table and convert into data.table (NVM) for better handling
NVM <- read.table(file = "C:\\Users\\Pieter\\Documents\\StreemMaster\\THESIS\\Data\\OriginalData\\Geodata\\nvm_2000_201306_DucodeVos.csv", quote = "", header=TRUE, sep=",", fill=TRUE, stringsAsFactors = FALSE)

#Delete irrelevant colums in NVM
exclude <- c("nvmreg_id", "afd_id", "permanent", "woonopp", "oorsprppr", "laatstpr", "datum_aanm", "categorie",
             "soorthuis" ,"type" ,"kenmerkwon" ,"soortapp" ,"soortwon" ,"verkpcond" ,"nvmcijfers" ,"isnieuwbw",
             "isbelegging" ,"status" ,"openportk" ,"lift" ,"kwaliteit" ,"vtrap" ,"zolder" ,"vlier" ,"praktijkr",
             "woonka" ,"parkeer" ,"inpandig" ,"tuinlig" ,"isol" ,"kelder")
NVM[,-exclude]


#Get rid of outliers
NVM <- subset(NVM, m2 <= 250 & m2 >= 50 
                & inhoud <= 1000 & inhoud >= 100 
                & transaprijs >= 80000 & transaprijs <= 700000 
                & loopt >= 0 
                & erfpacht != 1 & erfpacht != -1 
                & nkamers <= 10
                & huisklasse > 0 & huisklasse <= 7)

#Create variable price per square meter and get rid of outliers
NVM$prijsm2 <- NVM$transaprijs/NVM$m2
NVM <- subset(NVM, prijsm2 >= 1000 & prijsm2 <= 4000)

#Turn perceel into numeric variable, and get rid of outliers
NVM$perceel <- as.numeric(NVM$perceel)
NVM <- subset(NVM, perceel >= 10 & perceel <= 4000)

#Dummy variables
NVM$huisklasse <- as.factor(NVM$huisklasse)
levels(NVM$huisklasse)[levels(NVM$huisklasse)=="-1"] <- "appartement"
levels(NVM$huisklasse)[levels(NVM$huisklasse)=="1"] <- "appartement"
levels(NVM$huisklasse)[levels(NVM$huisklasse)=="2"] <- "eenvoudige_woning"
levels(NVM$huisklasse)[levels(NVM$huisklasse)=="3"] <- "eengezinswoning"
levels(NVM$huisklasse)[levels(NVM$huisklasse)=="4"] <- "herenhuis.grachtenpand"
levels(NVM$huisklasse)[levels(NVM$huisklasse)=="5"] <- "woonboerderij.bungalow"
levels(NVM$huisklasse)[levels(NVM$huisklasse)=="6"] <- "villa"
levels(NVM$huisklasse)[levels(NVM$huisklasse)=="7"] <- "landhuis.landgoed"

NVM$ligcentr <- as.factor(NVM$ligcentr)
NVM$ligmooi <- as.factor(NVM$ligmooi)
NVM$ligdrukw <- as.factor(NVM$ligdrukw)

#Log of transaction price (transaprijs), square meters (m2), plot (perceel) and number of rooms (nkamers)
NVM$logprijs <- log(NVM$transaprijs)
NVM$logm2 <- log(NVM$m2)
NVM$logperceel <- log(NVM$perceel)
NVM$lognkamers <- log(NVM$nkamers)

#Dates
NVM$datum <- as.Date(NVM$datum_afm)
NVM$jaar <- year(NVM$datum)

#Summary stats
summary(NVM)
head(NVM)

#Year subset & Export NVM as .csv file for construction of vars in ArcGIS
for(year in 2000:2013){
  NVMsub <- subset(NVM, jaar == year)
  filename <- paste("C:\\Users\\Pieter\\Documents\\StreemMaster\\THESIS\\Data\\ConstructedData\\NVM", year, ".csv", sep = "")
  write.csv(NVMsub, file = filename, quote = TRUE)
}

