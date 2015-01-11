library(nlme)
library(lattice)
library(car)
library(spida)
library(magrittr)


#Merge BRAC DFT data with checkin survey data

data <- read.csv("/Users/heatherkrause/Documents/R/dft-reports/DFTJulyThruNovember2104_Analysis.csv")
dataO <- data[which(data$DateF=="2014-10-27"),]
dataN <- data[which(data$DateF=="2014-11-24"),]

dataO1 <- read.csv("/Users/heatherkrause/Documents/R/dft-reports/Survey_Data_27Oct2014_revised.csv")
dataN1 <- read.csv("/Users/heatherkrause/Documents/R/dft-reports/Nov242014_CheckInData.csv",colClasses = "character")
dataD1 <- read.csv("/Users/heatherkrause/Documents/R/dft-reports/CheckIn Survey December.csv",colClasses = "character")
dataONa <- rbind(dataO1,dataN1)
dataON <- rbind(dataONa,dataD1)

dataON$Collection.Point[dataON$Collection_Point=="Amosh"] <- "Amosh"
  dataON$Collection.Point[dataON$Collection_Point=="Annadanagar"] <- "Annadanogor"
  dataON$Collection.Point[dataON$Collection_Point=="Aringail"] <- "Arangail"
  dataON$Collection.Point[dataON$Collection_Point=="Baithavanga"] <- "Boithavanga"
  dataON$Collection.Point[dataON$Collection_Point=="Bogilagari"] <- "Bogulagari"
  dataON$Collection.Point[dataON$Collection_Point=="Bordanagar"] <- "Barda Nagor"
  dataON$Collection.Point[dataON$Collection_Point=="Boro Narayanpur"] <- "Narayonpur"
  dataON$Collection.Point[dataON$Collection_Point=="Bothor"] <- "Bothor"
  dataON$Collection.Point[dataON$Collection_Point=="Briguakhara"] <- "Briguakhara"
  dataON$Collection.Point[dataON$Collection_Point=="Buruz"] <- "Buruz"
  dataON$Collection.Point[dataON$Collection_Point=="Char Bordhongacha"] <- "Char Bordhangacha"
  dataON$Collection.Point[dataON$Collection_Point=="Char Narua"] <- "Char Narua"
  dataON$Collection.Point[dataON$Collection_Point=="Dhoroil "] <- "Dharoi"
  dataON$Collection.Point[dataON$Collection_Point=="Durgahata"] <- "Durgahata"
  dataON$Collection.Point[dataON$Collection_Point=="Durunjoy"] <- "Dhurojo"
  dataON$Collection.Point[dataON$Collection_Point=="Gagrakhali"] <- "Gagra Khali"
  dataON$Collection.Point[dataON$Collection_Point=="Haragace"] <- "Haragach"
  dataON$Collection.Point[dataON$Collection_Point=="Kaibortogatee (Bonkirat)"] <- "Bonkirhat"
  dataON$Collection.Point[dataON$Collection_Point=="Kashipur"] <- "Kashipur"
  dataON$Collection.Point[dataON$Collection_Point=="Osmanpur"] <-"Osmanpur"
  dataON$Collection.Point[dataON$Collection_Point=="Parvangura"] <-"Parbhangura"
  dataON$Collection.Point[dataON$Collection_Point=="Parvangura (East)"] <- "Parbhangura East"
  dataON$Collection.Point[dataON$Collection_Point=="Parvangura (West)"] <- "Parbhangura West"
  dataON$Collection.Point[dataON$Collection_Point=="Purbo Batiya"] <- "Purbo Batia"
  dataON$Collection.Point[dataON$Collection_Point=="Ramesharpur Paskatoli"] <- "Ramesharpur Paskatoli"
  dataON$Collection.Point[dataON$Collection_Point=="Sonahara"] <- "Sonahara"
  dataON$Collection.Point[dataON$Collection_Point=="Taxerhut"] <- "Texerhut"
  dataON$Collection.Point[dataON$Collection_Point=="Uttar Mohonpur"] <- "Mohonpur"
  dataON$Collection.Point[dataON$Collection_Point=="Kalirhat"] <- "Kalirhat"
  dataON$Collection.Point[dataON$Collection_Point=="Namajkhali"] <- "Namaz Khali"
  dataON$Collection.Point[dataON$Collection_Point=="Banani Bazar"] <- "Banani Bazar"
  dataON$Collection.Point[dataON$Collection_Point=="Khalkhola"] <- "Khalkola"
  dataON$Collection.Point[dataON$Collection_Point=="Batiya"] <- "Batia"

dataON$DFT.codeCP <- paste(dataON$DFTID,dataON$Collection.Point, sep = "")
dataON$LitresPerCow <- as.numeric(dataON$Quantity)/as.numeric(dataON$Cow_Qty)

write.csv(dataON,"/Users/heatherkrause/Desktop/CheckinInData_OctNovDec2014.csv")

dataA <- read.csv("/Users/heatherkrause/Documents/R/dft-reports/DFTJulyThruNovember2104_Analysis.csv")
dataB <- read.csv("/Users/heatherkrause/Documents/R/dft-reports/CheckinInData_OctNovDec2014.csv")


dataA$DateF1 <- as.Date(dataA$Date,format="%d/%m/%Y")
dataA$day <- as.numeric(format(dataA$DateF1, "%d"))
dataA$months <- as.numeric(format(dataA$DateF1, "%m"))
dataA$DMY <- paste(dataA$day,dataA$months,dataA$year,sep="")

dataB$Shift. <- dataB$Shift

dataB$DMY <- paste(dataB$Day,dataB$Month,dataB$Year,sep="")

dataAB <- merge(dataA,dataB, by=c("DFT.codeCP","DMY","Shift."),all=T)

write.csv(dataAB,"/Users/heatherkrause/Desktop/Checkin+BRAC OctNov 2014.csv")

