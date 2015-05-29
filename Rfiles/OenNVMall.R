library(foreign)

nvm05 <- read.dbf("C:\\Users\\Pieter\\Documents\\StreemMaster\\THESIS\\Data\\ArcGisProjects\\CreateRoads\\NVMBIG\\NVM2005all1.dbf")
nvm06 <- read.dbf("C:\\Users\\Pieter\\Documents\\StreemMaster\\THESIS\\Data\\ArcGisProjects\\CreateRoads\\NVMBIG\\NVM2006all1.dbf")
nvm07 <- read.dbf("C:\\Users\\Pieter\\Documents\\StreemMaster\\THESIS\\Data\\ArcGisProjects\\CreateRoads\\NVMBIG\\NVM2007all1.dbf")
nvm08 <- read.dbf("C:\\Users\\Pieter\\Documents\\StreemMaster\\THESIS\\Data\\ArcGisProjects\\CreateRoads\\NVMBIG\\NVM2008all1.dbf")
nvm09 <- read.dbf("C:\\Users\\Pieter\\Documents\\StreemMaster\\THESIS\\Data\\ArcGisProjects\\CreateRoads\\NVMBIG\\NVM2009all1.dbf")
nvm10 <- read.dbf("C:\\Users\\Pieter\\Documents\\StreemMaster\\THESIS\\Data\\ArcGisProjects\\CreateRoads\\NVMBIG\\NVM2010all1.dbf")
nvm11 <- read.dbf("C:\\Users\\Pieter\\Documents\\StreemMaster\\THESIS\\Data\\ArcGisProjects\\CreateRoads\\NVMBIG\\NVM2011all1.dbf")
nvm12 <- read.dbf("C:\\Users\\Pieter\\Documents\\StreemMaster\\THESIS\\Data\\ArcGisProjects\\CreateRoads\\NVMBIG\\NVM2012all1.dbf")
nvm13 <- read.dbf("C:\\Users\\Pieter\\Documents\\StreemMaster\\THESIS\\Data\\ArcGisProjects\\CreateRoads\\NVMBIG\\NVM2013all1.dbf")

NVM <- rbind(nvm05,nvm06,nvm07,nvm08,nvm09,nvm10,nvm11,nvm12,nvm13)
summary(NVM0)

#Delete irrelevant colums in NVM
exclude <- c("KANTCODE","WVK_BEGDAT","BEGAFSTAND","ENDAFSTAND","FK_VELD1","FK_VELD4","IZI_SIDE","KANTCODE_1",
             "WVK_BEGD_1","BEGAFSTA_1","ENDAFSTA_1","FK_VELD1_1","FK_VELD4_1","IZI_SIDE_1")
NVM <- NVM[,!(names(NVM) %in% exclude)]

exclude <- c("pc6","mun","prov_id","constrperi","perceel","size","type","price",
             "rooms","garage","centralhea","listed","x","y",
             "pricesqm","apartment","terraced","semidetach","detach","constrlt45","constr1945","constr1960",
             "constr1971","constr1981","constr1991","constrlt00","maintgood","pc5","pc4","logprice","logsize",
             "logrooms","date","startdate","year","month","daysonmark","houseid","xyid","detached","hwDist",
             "hwFID","barDist","barFID","rampDist")
NVM <- NVM[,!(names(NVM) %in% exclude)]

#RENAME
colnames(NVM)[colnames(NVM)=="OMSCHR"] <- "roadtype1"
colnames(NVM)[colnames(NVM)=="OMSCHR_1"] <- "surfacetype1"
colnames(NVM)[colnames(NVM)=="OMSCHR_12"] <- "maxspeed1"
colnames(NVM0)[colnames(NVM)=="OMSCHR__13"] <- "barriertype1"
colnames(NVM)[colnames(NVM0)=="FID_1"] <- "FIDroad1"
colnames(NVM0)[colnames(NVM0)=="FID_12"] <- "FIDbarrier1"
colnames(NVM)[colnames(NVM)=="WVK_ID"] <- "roadID1"
colnames(NVM)[colnames(NVM)=="WVK_ID_1"] <- "barrierID1"
colnames(NVM)[colnames(NVM)=="AFST_GLG"] <- "barrierroaddist1"
colnames(NVM)[colnames(NVM)=="HGTE_GLG"] <- "barrierheight1"

NVM0 <- read.csv("C:\\Users\\Pieter\\Documents\\StreemMaster\\THESIS\\Data\\ConstructedData\\NVM20052013all.csv", header=TRUE)

NVM1 <- merge(NVM0,NVM,by="id")
summary(NVM1)

colnames(NVM1)[colnames(NVM1)=="FIDbarrier1.x"] <- "FIDbarrier"
colnames(NVM1)[colnames(NVM1)=="FIDbarrier1.y"] <- "FIDbarrier1"
colnames(NVM1)[colnames(NVM1)=="barriertype1.x"] <- "barriertype"
colnames(NVM1)[colnames(NVM1)=="barriertype1.y"] <- "barriertype1"
NVM1$garden <- NULL
write.csv(NVM1, file = "C:\\Users\\Pieter\\Documents\\StreemMaster\\THESIS\\Data\\ConstructedData\\NVM20052013all01.csv", quote = FALSE)
