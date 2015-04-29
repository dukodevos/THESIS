library(McSpatial)

#create example data.frame
id = c(1,2,3,4,5,6,7,8,9,1,2,3,4,5)
p = c(100,110,120,130,140,150,160,170,180,190,200,210,220,230)
treatment = c(0,0,0,0,0,0,0,0,0,0,0,0,1,1)
year = c(2000,2000,2000,2001,2001,2001,2002,2002,2002,2003,2003,2003,2004,2004)
df = data.frame(id, p, treatment, year)

#create dataframe of repeat sales including treatment indicator
dfrs <- repsaledatatreatm(df$p, df$year, df$id, df$treatment)

#merge repeat sales data frame and original dataframe
dftr <- merge(dfrs, df, by ="id")

#add proper treatment variable
dftr$treated <- factor(dftr$treat0==0 & dftr$treat1==1)

#subset to only include 1 observation of each repeat sales pair
dftr1 <- subset(dftr, price1 == p)