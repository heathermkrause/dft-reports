#Merge BRAC DFT data with checkin survey data

data <- read.csv("/Users/heatherkrause/Documents/R/dft-reports/DFTJulyThruNov2104_Analysis.csv")
dataO <- dataM[which(dataM$DateF=="2014-10-27"),]
dataN <- dataM[which(dataM$DateF=="2014-11-24"),]

dataO1 <- read.csv("/Users/heatherkrause/Documents/R/dft-reports/Checkin_Data_10_27_2014.csv")
dataN1 <- read.csv("/Users/heatherkrause/Documents/R/dft-reports/Checkin_Data_11_24_2014.csv")
