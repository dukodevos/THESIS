#Load libraries
library(lmtest)
library(McSpatial)

#load custom functions
source("C:\\Users\\Pieter\\Documents\\StreemMaster\\THESIS\\Data\\Rfiles\\repsaledatatreatm.r")

#Load data
NVM <- read.table("C:\\Users\\Pieter\\Documents\\StreemMaster\\THESIS\\Data\\ConstructedData\\NVM20062013.csv", header=TRUE, sep=",", fill=TRUE)
#colnames(NVM) <- gsub(pattern = "X.", replacement = "", x = colnames(NVM), fixed = TRUE)
#colnames(NVM) <- gsub(pattern = ".", replacement = "", x = colnames(NVM), fixed = TRUE)

NVM$ramp <- factor(NVM$rampDist < 1000)
NVM$soundb <- factor(NVM$SoundbDist < 500 & NVM$SoundbDist <= NVM$HwDist)

#Model 1
lm1 <- lm(logprijs ~ logRampDist + ramp + soundb + logm2 + logperceel + lognkamers + onbi + onbu + tuinafw + factor(huisklasse) + factor(bwper) + factor(jaar) + factor(ligcentr) + factor(ligmooi) + factor(ligdrukw), data=NVM)
summary(lm1)
summaryw(lm1)

#create dataframe of repeat sales including soundb, adjust id var, and merge with NVMRS
NVMRS1 <- repsaledatatreatm(NVM$transaprijs, NVM$jaar, NVM$pc6code, NVM$soundb)
NVMRS1$pc6code <- NVMRS1$id
NVMRS1$id <- NULL
NVMRS <- merge(NVMRS1, NVM, by="pc6code")

#add proper treatment variable
NVMRS$treated <- factor(NVMRS$treat0==FALSE & NVMRS$treat1==TRUE)

#subset NVMRS to only include 1 observation of each repeat sales pair
NVMRS <- subset(NVMRS, price1 == transaprijs)

#NVMRS$logdeltap <- log(NVMRS$price1) - log(NVMRS$price0)
#lm2 <- lm(logdeltap ~ treated + logRampDist + ramp + soundb + logm2 + logperceel + lognkamers + onbi + onbu + tuinafw + factor(huisklasse) + factor(bwper) + factor(jaar) + factor(ligcentr) + factor(ligmooi) + factor(ligdrukw), data=NVMRS)
#summary(lm1)

summary(NVMRS)

head(NVMRS)
