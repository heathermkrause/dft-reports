library(nlme)
library(lattice)
library(car)
library(spida)
library(magrittr)

#Merge Eeach new month

dataM$datetxt <- as.Date(dataM$Date,,format="%d/%m/%Y")
dataM$year = as.numeric(format(dataM$datetxt, format = "%Y"))
dataM$month = as.numeric(format(dataM$datetxt, format = "%m"))
dataM$monthyear <- paste(dataM$month,dataM$year,sep="-")
dataM$SDVC <- with(dataM,ifelse(is.na(dataM$LG.Code),0,1))

dataM$monthF[dataM$month==11] <- "November"
dataM$monthF[dataM$month==12] <- "December"

dataM$month <- dataM$monthF

dataM$AveLitre <- capply(dataM$Qty.Ltr.,dataM$DFT.codeCP,mean,na.rm=T)
dataM$AveFatPerc <- capply(dataM$FatPercent,dataM$DFT.codeCP,mean,na.rm=T)
dataM$AveSNFPercent <- capply(dataM$SNFPercent,dataM$DFT.codeCP,mean,na.rm=T)
dataM$AveLitreMonth <- capply(dataM$Qty.Ltr.,paste(dataM$DFT.codeCP,dataM$month),mean,na.rm=T)
dataM$AveFatPercMonth <- capply(dataM$FatPercent,paste(dataM$DFT.codeCP,dataM$month),mean,na.rm=T)
dataM$AveSNFPercentMonth <- capply(dataM$SNFPercent,paste(dataM$DFT.codeCP,dataM$month),mean,na.rm=T)
dataM$AveLitreMonthCP <- capply(dataM$Qty.Ltr.,paste(dataM$Collection.Point.Name,dataM$month),mean,na.rm=T)
dataM$AveFatPercMonthCP <- capply(dataM$FatPercent,paste(dataM$Collection.Point.Name,dataM$month),mean,na.rm=T)
dataM$AveSNFPercentMonthCP <- capply(dataM$SNFPercent,paste(dataM$Collection.Point.Name,dataM$month),mean,na.rm=T)


#merging all months
data1 <- read.csv("/Users/heatherkrause/Documents/R/dft-reports/Final DFT Data Uploaded to Marjan Dashboard/DFTDataFMergeJuly2014.csv")
data2 <- read.csv("/Users/heatherkrause/Documents/R/dft-reports/Final DFT Data Uploaded to Marjan Dashboard/DFTAugust2014_Correct.csv")
data3 <- read.csv("/Users/heatherkrause/Documents/R/dft-reports/Final DFT Data Uploaded to Marjan Dashboard/DFTSeptOct2014_Correct.csv")
myvars <- c("DFT.Code", "To", "Shift.", "Qty.Ltr.", "FatPercent", "SNFPercent", "Rate.Rs", "AmountRS", "Site",
            "Date", "Collection.Point.Name", "LG.Code", "Sex..W.1..M.2.", "Upazila", "District", "Village","Para", "DFT.codeCP","Producer.Name",
            "Under.Chilling.Plant" )
data1M <- data1[myvars]
data2M <- data2[myvars]
data3M <- data3[myvars]
data4M <- dataM[myvars]

data12M <- rbind(data1M,data2M)
data123M <- rbind(data12M,data3M)
data1234M <- rbind(data123M,data4M)
data1234M$DateF <- as.Date(data1234M$Date,format="%d/%m/%Y")
data1234M$month <- months(data1234M$DateF)
floor(as.numeric(data123M$DateF))
data1234M$year <- as.numeric(format(data1234M$DateF, "%Y"))
data1234M$monthF <- as.numeric(format(data1234M$DateF, "%m"))
data1234M$monthyear <- paste(data1234M$monthF,data1234M$year,sep="")
data1234M$SDVC <- with(data1234M,ifelse(is.na(data1234M$LG.Code),0,1))
data1234MF <- data1234M[which(data1234M$year < 2015),]

                     
write.csv(data1234MF,"/Users/heatherkrause/Documents/R/dft-reports/DFTJulyThruNovember2104_Analysis.csv")

dataM <- data1234MF

dataM$AveLitre <- capply(dataM$Qty.Ltr.,dataM$DFT.codeCP,mean,na.rm=T)
dataM$AveFatPerc <- capply(dataM$FatPercent,dataM$DFT.codeCP,mean,na.rm=T)
dataM$AveSNFPercent <- capply(dataM$SNFPercent,dataM$DFT.codeCP,mean,na.rm=T)
dataM$AveLitreMonth <- capply(dataM$Qty.Ltr.,paste(dataM$DFT.codeCP,dataM$month),mean,na.rm=T)
dataM$AveFatPercMonth <- capply(dataM$FatPercent,paste(dataM$DFT.codeCP,dataM$month),mean,na.rm=T)
dataM$AveSNFPercentMonth <- capply(dataM$SNFPercent,paste(dataM$DFT.codeCP,dataM$month),mean,na.rm=T)
dataM$AveLitreMonthCP <- capply(dataM$Qty.Ltr.,paste(dataM$Collection.Point.Name,dataM$month),mean,na.rm=T)
dataM$AveFatPercMonthCP <- capply(dataM$FatPercent,paste(dataM$Collection.Point.Name,dataM$month),mean,na.rm=T)
dataM$AveSNFPercentMonthCP <- capply(dataM$SNFPercent,paste(dataM$Collection.Point.Name,dataM$month),mean,na.rm=T)

dataM$FatPercJuly <- with(dataM,ifelse(dataM$month=="July",dataM$AveFatPercMonth,0))
dataM$FatPercAug <- with(dataM,ifelse(dataM$month=="August",dataM$AveFatPercMonth,0))
dataM$FatPercSept <- with(dataM,ifelse(dataM$month=="September",dataM$AveFatPercMonth,0))
dataM$FatPercOct <- with(dataM,ifelse(dataM$month=="October",dataM$AveFatPercMonth,0))
dataM$FatPercNov <- with(dataM,ifelse(dataM$month=="November",dataM$AveFatPercMonth,0))
dataM$FatPercDec <- with(dataM,ifelse(dataM$month=="December",dataM$AveFatPercMonth,0))

dataM$AveLitJuly <- with(dataM,ifelse(dataM$month=="July",dataM$AveLitreMonth,0))
dataM$AveLitAug <- with(dataM,ifelse(dataM$month=="August",dataM$AveLitreMonth,0))
dataM$AveLitSept <- with(dataM,ifelse(dataM$month=="September",dataM$AveLitreMonth,0))
dataM$AveLitOct <- with(dataM,ifelse(dataM$month=="October",dataM$AveLitreMonth,0))
dataM$AveLitNov <- with(dataM,ifelse(dataM$month=="November",dataM$AveLitreMonth,0))
dataM$AveLitDec <- with(dataM,ifelse(dataM$month=="December",dataM$AveLitreMonth,0))

dataM$FatPercJulyCP <- with(dataM,ifelse(dataM$month=="July",dataM$AveFatPercMonthCP,0))
dataM$FatPercAugCP<- with(dataM,ifelse(dataM$month=="August",dataM$AveFatPercMonthCP,0))
dataM$FatPercSeptCP <- with(dataM,ifelse(dataM$month=="September",dataM$AveFatPercMonthCP,0))
dataM$FatPercOctCP <- with(dataM,ifelse(dataM$month=="October",dataM$AveFatPercMonthCP,0))
dataM$FatPercNovCP <- with(dataM,ifelse(dataM$month=="November",dataM$AveFatPercMonthCP,0))
dataM$FatPercDecCP <- with(dataM,ifelse(dataM$month=="December",dataM$AveFatPercMonthCP,0))

dataM$AveLitJulyCP <- with(dataM,ifelse(dataM$month=="July",dataM$AveLitreMonthCP,0))
dataM$AveLitAugCP <- with(dataM,ifelse(dataM$month=="August",dataM$AveLitreMonthCP,0))
dataM$AveLitSeptCP <- with(dataM,ifelse(dataM$month=="September",dataM$AveLitreMonthCP,0))
dataM$AveLitOctCP <- with(dataM,ifelse(dataM$month=="October",dataM$AveLitreMonthCP,0))
dataM$AveLitNovCP <- with(dataM,ifelse(dataM$month=="November",dataM$AveLitreMonthCP,0))
dataM$AveLitDecCP <- with(dataM,ifelse(dataM$month=="December",dataM$AveLitreMonthCP,0))

dataM$FatDiffJulyAug <- dataM$FatPercAug - dataM$FatPercJuly #large numbers is big increase
dataM$FatDiffAugSept <- dataM$FatPercSept - dataM$FatPercAug #large numbers is big increase
dataM$FatDiffSeptOct <- dataM$FatPercOct - dataM$FatPercSept #large numbers is big increase
dataM$FatDiffOctNov <- dataM$FatPercNov - dataM$FatPercOct #large numbers is big increase

dataM$LitreDiffJulyAug <- dataM$AveLitAug - dataM$AveLitJuly  #large numbers is big increase
dataM$LitreDiffAugSept <- dataM$AveLitSept - dataM$AveLitAug #large numbers is big increase
dataM$LitreDiffSeptOct <- dataM$AveLitOct - dataM$AveLitSept #large numbers is big increase
dataM$LitreDiffOctNov <- dataM$AveLitNov - dataM$AveLitOct #large numbers is big increase

dataM$FatDiffJulyAugCP <- dataM$FatPercAugCP - dataM$FatPercJulyCP #large numbers is big increase
dataM$FatDiffAugSeptCP <- dataM$FatPercSeptCP - dataM$FatPercAugCP #large numbers is big increase
dataM$FatDiffSeptOctCP <- dataM$FatPercOctCP - dataM$FatPercSeptCP #large numbers is big increase
dataM$FatDiffOctNovCP <- dataM$FatPercNovCP - dataM$FatPercOctCP #large numbers is big increase

dataM$LitreDiffJulyAugCP <- dataM$AveLitAugCP - dataM$AveLitJulyCP  #large numbers is big increase
dataM$LitreDiffAugSeptCP <- dataM$AveLitSeptCP - dataM$AveLitAugCP #large numbers is big increase
dataM$LitreDiffSeptOctCP <- dataM$AveLitOctCP - dataM$AveLitSeptCP #large numbers is big increase
dataM$LitreDiffOctNovCP <- dataM$AveLitNovCP - dataM$AveLitOctCP #large numbers is big increase

write.csv(dataM,"/Users/heatherkrause/Documents/R/dft-reports/DFTJulyThruNov2104_Analysis.csv")
write.csv(dataM,"/Users/heatherkrause/Documents/R/dft-reports/DFTJulyThruNov2104_Tableau.csv")

dataUp <- up(dataM, ~DFT.codeCP)
write.csv(dataUp,"/Users/heatherkrause/Documents/R/dft-reports/DFT_ThruDec2014_Up.csv")
