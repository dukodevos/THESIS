#Load libraries
library(foreign)
library(lmtest)
library(plm)
library(McSpatial)

df <- read.dta("C:\\Users\\Pieter\\Documents\\StreemMaster\\THESIS\\Stata\\NVM0513_complete.dta")

dfrs <- repsaledatatreatm(df$price,df$year,df$houseid,df$barrier,df$ZOAB)
dfrs$houseid <- dfrs$id
dfrs$id <- NULL
dfrs <- merge(dfrs, df, by="houseid")
summary(dfrs)
dfrs$treatedbar <- as.numeric(dfrs$treat0 == FALSE & dfrs$treat1 == TRUE)
dfrs$treatedtarmac <- as.numeric(dfrs$treat00 == FALSE & dfrs$treat01 == TRUE)
dfrs <- subset(dfrs, price1 == price & time1 == year)
dfrs$logpricechange <- log(dfrs$price1/dfrs$price0)
dfrs$screen <- dfrs$treatedbar*(as.numeric(dfrs$barriertype == "Doorzichtig geluidsscherm" | dfrs$barriertype == "Niet doorzichtig geluidsscherm"))
dfrs$wall <- dfrs$treatedbar*(as.numeric(dfrs$barriertype == "Geluidswand" | dfrs$barriertype == "Geluidswand met luifelconstructie"))
dfrs$earthwall <- dfrs$treatedbar*(as.numeric(dfrs$barriertype == "Geluidswal" | dfrs$barriertype == "Geluidswal met daarop of -in een scherm"))

lmdf <- lm(logpricechange ~ screen + earthwall + wall + treatedtarmac, data=dfrs1)
summary(lmdf)
