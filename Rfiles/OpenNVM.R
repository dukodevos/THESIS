# Author: Duco de Vos
# Description: Script to clean up NVM dataset, based on Stata do-file by Hans Koster

#Load libraries
library(plyr)
library(lubridate)
library(foreign)


#Import NVM table
NVM <- read.table(file = "C:\\Users\\Pieter\\Documents\\StreemMaster\\THESIS\\Data\\OriginalData\\Geodata\\nvm_2000_201306_DucodeVos.csv", quote = "", header=TRUE, sep=",", fill=TRUE, stringsAsFactors = FALSE)

#Get rid of outliers
NVM <- subset(NVM, m2 <= 250 & m2 >= 25 
                & inhoud <= 1000 & inhoud >= 100 
                & transaprijs >= 25000 & transaprijs <= 1000000 
                & loopt >= 0 
                & nkamers <= 25
                & x > 0 & y > 0)

#Create variable price per square meter and get rid of outliers
NVM$prijsm2 <- NVM$transaprijs/NVM$m2
NVM <- subset(NVM, prijsm2 >= 500 & prijsm2 <= 5000)

#Turn perceel into numeric variable, and get rid of outliers
NVM$perceel <- as.numeric(NVM$perceel)
NVM <- subset(NVM, perceel >= 10 & perceel <= 5000)

#Create houseid
idvars <- c("pc6code", "huisnummer", "huisnrtoev", "type", "bwper")
NVM$houseid1 <- id(NVM[,idvars], drop = TRUE)
NVM$corr_m2 <- ave(NVM$m2, NVM$houseid1)
NVM$corr_nkamers <- ave(NVM$nkamers, NVM$houseid1)
NVM$corr_m2 <- as.integer((NVM$m2 - NVM$corr_m2 - 0.0001)/10)    #0 = no more than 5 m2 difference from mean
NVM$corr_nkamers <- as.integer((NVM$nkamers - NVM$corr_m2 - 0.0001)/5)    #0 = no more than 2.5 rooms difference from mean
idvars <- c("pc6code", "huisnummer", "huisnrtoev", "type", "corr_m2", "corr_nkamers", "bwper")
NVM$houseid2 <- id(NVM[,idvars], drop = TRUE)

#Translate to english
colnames(NVM)[colnames(NVM)=="transaprijs"] <- "price"
colnames(NVM)[colnames(NVM)=="prijsm2"] <- "pricesqm"
colnames(NVM)[colnames(NVM)=="m2"] <- "size"
colnames(NVM)[colnames(NVM)=="nkamers"] <- "rooms"
colnames(NVM)[colnames(NVM)=="bwper"] <- "constrperiod"
colnames(NVM)[colnames(NVM)=="parkeer"] <- "garage"
colnames(NVM)[colnames(NVM)=="tuinlig"] <- "garden"
colnames(NVM)[colnames(NVM)=="verw"] <- "centralheating"
colnames(NVM)[colnames(NVM)=="monument"] <- "listed"
colnames(NVM)[colnames(NVM)=="datum"] <- "date"
colnames(NVM)[colnames(NVM)=="gem_id"] <- "mun"
colnames(NVM)[colnames(NVM)=="pc6code"] <- "pc6"

#Dummy and factor variables
NVM$type <- as.factor(NVM$type)
levels(NVM$type)[levels(NVM$type)=="-1"|levels(NVM$type)=="0"] <- "apartement"
levels(NVM$type)[levels(NVM$type)=="1"|levels(NVM$type)=="2"] <- "terraced"
levels(NVM$type)[levels(NVM$type)=="3"|levels(NVM$type)=="4"] <- "semidetached"
levels(NVM$type)[levels(NVM$type)=="5"] <- "detached"
NVM$constrperiod <- as.factor(NVM$constrperiod)
levels(NVM$constrperiod)[levels(NVM$constrperiod)>="0" & levels(NVM$constrperiod)<="3"] <- "constrlt1945"
levels(NVM$constrperiod)[levels(NVM$constrperiod)=="4"] <- "constr19451959"
levels(NVM$constrperiod)[levels(NVM$constrperiod)=="5"] <- "constr19601970"
levels(NVM$constrperiod)[levels(NVM$constrperiod)=="6"] <- "constr19711980"
levels(NVM$constrperiod)[levels(NVM$constrperiod)=="7"] <- "constr19811990"
levels(NVM$constrperiod)[levels(NVM$constrperiod)=="8"] <- "constr19912000"
levels(NVM$constrperiod)[levels(NVM$constrperiod)=="9"] <- "constrgt2000"
NVM$garage <- factor(NVM$garage >= 3)
NVM$garden <- factor(NVM$garden > 0)
NVM$maintgood <- factor((NVM$onbi + NVM$onbu) > 13)
NVM$centralheating <- factor(NVM$centralheating > 0)
NVM$listed <- factor(NVM$listed == 1)
NVM$pc4 <- substring(NVM$pc6, 1, 4)

#Log of transaction price (transaprijs), square meters (m2), plot (perceel) and number of rooms (nkamers)
NVM$logprice <- log(NVM$price)
NVM$logsize <- log(NVM$size)
NVM$logrooms <- log(NVM$rooms)

#Dates
NVM$date <- as.Date(NVM$datum_afm)
NVM$startdate <- as.Date(NVM$datum_aanm)
NVM$year <- year(NVM$date)
NVM$daysonmarket <- NVM$date - NVM$startdate

#Create unique housing id
NVM$times <- table(NVM$houseid2)[NVM$houseid2]
NVM$yeartimes <- table(NVM$houseid2, by = NVM$year)[NVM$houseid2]
NVM$random <- ifelse(NVM$times > 5, runif(10)|NVM$yeartimes > 1, 0)    # change houseid if more than 5 times transacted in 13 years, or more than once in a given year
idvars <- c("houseid2", "random")
NVM$houseid <- id(NVM[,idvars], drop = TRUE)
idvars <- c("x", "y")
NVM$xyid <- id(NVM[,idvars], drop = TRUE)

#Delete irrelevant colums in NVM
exclude <- c("nvmreg_id", "afd_id", "permanent", "woonopp", "perceel", "oorsprppr", "laatstpr", "categorie",
             "soorthuis" ,"kenmerkwon" ,"soortapp" ,"soortwon" ,"verkpcond" ,"nvmcijfers" ,"isnieuwbw",
             "isbelegging" ,"status" ,"openportk" ,"lift" ,"kwaliteit" ,"vtrap" ,"zolder" ,"vlier", "praktijkr",
             "woonka" ,"inpandig","isol" ,"kelder", "onbi", "onbu", "corr_m2", "corr_nkamers", "houseid1",
             "loc_status", "bag_identificatie", "ged_verhrd", "erfpacht", "tuinafw", "nbadk", "nwc", "nbijkeuk", 
             "nkeuken", "ndakterras", "ndakkap", "nbalkon", "nverdiep", "datum_aanm", "datum_afm", "loopt", "procverschil",
             "huisklasse", "inhoud", "woonplaats", "postcode", "huisnrtoev", "huisnummer", "straatnaam", "prov_id",
             "houseid2", "times", "yeartimes", "random", "ligcentr", "ligmooi", "ligdrukw")
NVM <- NVM[,!(names(NVM) %in% exclude)]

#Year subset & Export NVM as .csv file for construction of vars in ArcGIS
write.csv(NVM, "C:\\Users\\Pieter\\Documents\\StreemMaster\\THESIS\\Data\\ConstructedData\\NVM_cleaned.csv" )
write.dta(NVM, "C:\\Users\\Pieter\\Documents\\StreemMaster\\THESIS\\Data\\ConstructedData\\NVM_cleaned.dta" )
for(i in 2000:2013){
  NVMsub <- subset(NVM, year == i)
  filename <- paste("C:\\Users\\Pieter\\Documents\\StreemMaster\\THESIS\\Data\\ConstructedData\\NVM",i,".csv")
  write.csv(NVMsub, file = filename, quote = TRUE)
}

