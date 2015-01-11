rm(list = ls())
library(nlme)
library(lattice)
library(car)
library(spida)
library(magrittr)

#names needed for final data ingest to Marjan Dashboard DFT.Code, To, Shift., Qty.Ltr., FatPercent, SNFPercent, Rate.Rs, AmountRS, Site,
#  Date, Collection.Point.Name, LG.Code, Sex..W.1..M.2., Upazila, District, Village, Time, DFT.codeCP, Producer.Name, Under.Chilling.Plant (check this)

#names needed for final data ingest to Tableau Dashboard DFT.Code, To, Shift., Qty.Ltr., FatPercent, SNFPercent, Rate.Rs, AmountRS, Site,
#  Date, Collection.Point.Name (In sentence case), LG.Code, Sex..W.1..M.2., Upazila, District, Village, Time, DFT.codeCP, Producer.Name, Under.Chilling.Plant, plus all the calculation variables (ie AveLitreMont)

data1 <- read.csv("/Users/heatherkrause/Dropbox/Projects/SDVC II/DFT Data/Formatted DFT Data from Elance/DFT November14 formatted.csv", comment.char = "", colClasses = "character")

data4 <- read.csv("/Users/heatherkrause/Dropbox/Projects/SDVC II/DFT Data/Mapping Documents/Final DFT Map Fall 2014.csv", comment.char = "", colClasses = "character")

## diagnose number problems:
diagnum <- function(x) {
  # x is character
  nas <- is.na(x)   # don't want to worry about xs that are already NA
  x <- x[!nas]
  xn <- as.numeric(x)
  good <- !is.na(xn)
  list(n.NAs = sum(nas), n.bad = sum(!good),
       bad = x[!good], good = xn[good])
}

# Function to fix punctuation in numbers:

fixnum <- function(x) {
  # Turn the last punctuation into a ':':
  x <- sub("([,\\.])([0-9]*)$",":\\2",x)
  # Remove all ,s and .s:
  x <- gsub("[,\\.]","",x)
  # Turn the colon into a period:
  x <- gsub(":",".",x)
  x
}

# remove trailing periods from variable names:
fs2 <- fs %>% lapply(function(d) {
  names(d) <- sub("\\.*$","",names(d))
  d
})

#fix Qty.Ltr
diagnum(fixnum(data1$Qty.Ltr))[-4]
data1$Qty.Ltr. <- as.numeric(fixnum(data1$Qty.Ltr.))

#fix Fat
diagnum(fixnum(data1$Qty.Ltr))[-4]
data1$FatPercent <- as.numeric(fixnum(data1$Fat.))

#fix SNF
diagnum(fixnum(data1$SNF.))[-4]
data1$SNFPercent <- as.numeric(fixnum(data1$SNF.)) 

## fix Rate.Rs
diagnum(fixnum(data1$Rate.Rs))[-4] 
data1$Rate.Rs <- as.numeric(fixnum(data1$Rate.Rs)) 

## fix Amount.Rs
diagnum(fixnum(data1$Amount.Rs))[-4] 
data1$AmountRS <- as.numeric(fixnum(data1$Amount.Rs)) 

#fix dates
data1$DateF <- as.Date(data1$Date,format="%d/%m/%Y")


data1$DFT.Code <- data1$X01.08.2014


#Add collection point names
data1$Split <- strsplit(as.character(data1$DFT.Code), "000", fixed = TRUE, perl = FALSE, useBytes = FALSE)
data1$Split1 <- sapply(data1$Split, "[[", 1) 


data1$CollectionPoint[data1$Site=="BHANGURA" & data1$Split1== "88008801"] <- "Bhangura"
data1$CollectionPoint[data1$Site=="BHANGURA" & data1$Split1== "88008801"] <- "Parbhangura"
data1$CollectionPoint[data1$Site=="BHANGURA" & data1$Split1== "88008803"] <- "Kashipur"
data1$CollectionPoint[data1$Site=="BHANGURA" & data1$Split1== "88008804"] <- "Parbhangura West"
data1$CollectionPoint[data1$Site=="BHANGURA" & data1$Split1== "88008805"] <- "Parbhangura East"
data1$CollectionPoint[data1$Site=="CHATMOHOR" & data1$Split1== "88008801"] <- "Chatmohor"
data1$CollectionPoint[data1$Site=="CHATMOHOR" & data1$Split1== "88008802"] <- "Bothor"
data1$CollectionPoint[data1$Site=="CHATMOHOR" & data1$Split1== "88008803"] <- "Briguakhara"
data1$CollectionPoint[data1$Site=="CHATMOHOR" & data1$Split1== "88008804"] <- "Choto Guakahara"
data1$CollectionPoint[data1$Site=="FARIDPUR" & data1$Split1== "88008801"] <- "Faridpur"
data1$CollectionPoint[data1$Site=="FARIDPUR" & data1$Split1== "88008802"] <- "Char Para"
data1$CollectionPoint[data1$Site=="FARIDPUR" & data1$Split1== "88008803"] <- "Sonahara"
data1$CollectionPoint[data1$Site=="GABTOLI" & data1$Split1== "88008801"] <- "Gabtoli"
data1$CollectionPoint[data1$Site=="GABTOLI" & data1$Split1== "88008802"] <- "Buruz"
data1$CollectionPoint[data1$Site=="GABTOLI" & data1$Split1== "88008803"] <- "Boithavanga"
data1$CollectionPoint[data1$Site=="GABTOLI" & data1$Split1== "88008804"] <- "Durgahata"
data1$CollectionPoint[data1$Site=="GABTOLI" & data1$Split1== "88008805"] <- "Ramesharpur Paskatoli"
data1$CollectionPoint[data1$Site=="GUNAIGASA" & data1$Split1== "88008801"] <- "Gunaigasa"
data1$CollectionPoint[data1$Site=="GUNAIGASA" & data1$Split1== "88008802"] <- "Arangail"
data1$CollectionPoint[data1$Site=="GUNAIGASA" & data1$Split1== "88008803"] <- "Khota Bari"
data1$CollectionPoint[data1$Site=="GURUDASPUR" & data1$Split1== "88008801"] <- "Gurudaspur"
data1$CollectionPoint[data1$Site=="GURUDASPUR" & data1$Split1== "88008802"] <- "Barda Nagor"
data1$CollectionPoint[data1$Site=="GURUDASPUR" & data1$Split1== "88008803"] <- "Ranigram"
data1$CollectionPoint[data1$Site=="KALAI" & data1$Split1== "88008801"] <- "Kalai"
data1$CollectionPoint[data1$Site=="KALAI" & data1$Split1== "88008802"] <- "Begungram"
data1$CollectionPoint[data1$Site=="KALAI" & data1$Split1== "88008803"] <- "Dhurojo"
data1$CollectionPoint[data1$Site=="MAHIGONJ" & data1$Split1== "88008801"] <- "Mahigon"
data1$CollectionPoint[data1$Site=="MAHIGONJ" & data1$Split1== "88008802"] <- "Haragach"
data1$CollectionPoint[data1$Site=="MOHONPUR" & data1$Split1== "88008801"] <- "Mohonpur"
data1$CollectionPoint[data1$Site=="MOHONPUR" & data1$Split1== "88008802"] <- "Char Bordhangacha"
data1$CollectionPoint[data1$Site=="MOHONPUR" & data1$Split1== "88008803"] <- "Bonkirhat"
data1$CollectionPoint[data1$Site=="SANTHIA" & data1$Split1== "88008801"] <- "Santhia"
data1$CollectionPoint[data1$Site=="SANTHIA" & data1$Split1== "88008802"] <- "Amosh"
data1$CollectionPoint[data1$Site=="SANTHIA" & data1$Split1== "88008803"] <- "Gagra Khali"
data1$CollectionPoint[data1$Site=="SHAHJADPUR" & data1$Split1== "88008801"] <- "Shahjadpur"
data1$CollectionPoint[data1$Site=="SHAHJADPUR" & data1$Split1== "88008802"] <- "Batia"
data1$CollectionPoint[data1$Site=="SHAHJADPUR" & data1$Split1== "88008803"] <- "Char Narua"
data1$CollectionPoint[data1$Site=="SHAHJADPUR" & data1$Split1== "88008804"] <- "Purbo Batia"
data1$CollectionPoint[data1$Site=="SHALONGA" & data1$Split1== "88008801"] <- "Shalonga"
data1$CollectionPoint[data1$Site=="SHALONGA" & data1$Split1== "88008802"] <- "Dharoil"
data1$CollectionPoint[data1$Site=="SHALONGA" & data1$Split1== "88008803"] <- "Mohonpur"
data1$CollectionPoint[data1$Site=="SHALONGA" & data1$Split1== "88008804"] <- "Banani Bazar"
data1$CollectionPoint[data1$Site=="SHALONGA" & data1$Split1== "88008805"] <- "Khalkola"
data1$CollectionPoint[data1$Site=="SHIBGONJ" & data1$Split1== "88008801"] <- "Shibgonj"
data1$CollectionPoint[data1$Site=="SHIBGONJ" & data1$Split1== "88008802"] <- "Narayonpur"
data1$CollectionPoint[data1$Site=="SHIBGONJ" & data1$Split1== "88008803"] <- "Bogulagari"
data1$CollectionPoint[data1$Site=="SHIBGONJ" & data1$Split1== "88008804"] <- "Valukkhali"
data1$CollectionPoint[data1$Site=="SONATOLA" & data1$Split1== "88008801"] <- "Sonatola"
data1$CollectionPoint[data1$Site=="SONATOLA" & data1$Split1== "88008802"] <- "Namaz Khali"



data4$Collection.Point.NameF[data4$Collection.Point.Name=="Aringail"] <- "Arangail"
data4$Collection.Point.NameF[data4$Collection.Point.Name=="Bogilagari"] <- "Bogulagari"
data4$Collection.Point.NameF[data4$Collection.Point.Name=="Bordanagar"] <- "Barda Nagor"
data4$Collection.Point.NameF[data4$Collection.Point.Name=="Bothore"] <- "Bothor"
data4$Collection.Point.NameF[data4$Collection.Point.Name=="Boro Narayanpur"] <- "Narayonpur"
data4$Collection.Point.NameF[data4$Collection.Point.Name=="Char Bordongasa"] <- "Char Bordhangacha"
data4$Collection.Point.NameF[data4$Collection.Point.Name=="Doroil"] <- "Dharoil"
data4$Collection.Point.NameF[data4$Collection.Point.Name=="Durunjoy"] <- "Dhurojo"
data4$Collection.Point.NameF[data4$Collection.Point.Name=="Gagrakhali"] <- "Gagra Khali"
data4$Collection.Point.NameF[data4$Collection.Point.Name=="Haragas"] <- "Haragach"
data4$Collection.Point.NameF[data4$Collection.Point.Name=="Khalkhola"] <- "Khalkola"
data4$Collection.Point.NameF[data4$Collection.Point.Name=="Koibortogati (Bonkirat)"] <- "Bonkirhat"
data4$Collection.Point.NameF[data4$Collection.Point.Name=="Namajkhali"] <- "Namaz Khali"
data4$Collection.Point.NameF[data4$Collection.Point.Name=="Par Bhangura"] <- "Parbhangura"
data4$Collection.Point.NameF[data4$Collection.Point.Name=="Paskatoli(Ramesharpur)"] <- "Ramesharpur Paskatoli"
data4$Collection.Point.NameF[data4$Collection.Point.Name=="Amosh"] <- "Amosh"
data4$Collection.Point.NameF[data4$Collection.Point.Name=="Taxerhut"] <- "Texerhut"
data4$Collection.Point.NameF[data4$Collection.Point.Name=="Annadanogor"] <- "Annadanogor"
data4$Collection.Point.NameF[data4$Collection.Point.Name=="Banani Bazar"] <- "Banani Bazar"
data4$Collection.Point.NameF[data4$Collection.Point.Name=="Batia"] <- "Batia"
data4$Collection.Point.NameF[data4$Collection.Point.Name=="Begungram"] <- "Begungram"
data4$Collection.Point.NameF[data4$Collection.Point.Name=="Boithavanga"] <- "Boithavanga"
data4$Collection.Point.NameF[data4$Collection.Point.Name=="Briguakhara"] <- "Briguakhara"
data4$Collection.Point.NameF[data4$Collection.Point.Name=="Buruz"] <- "Buruz"
data4$Collection.Point.NameF[data4$Collection.Point.Name=="Char Narua"] <- "Char Narua"
data4$Collection.Point.NameF[data4$Collection.Point.Name=="Durgahata"] <- "Durgahata"
data4$Collection.Point.NameF[data4$Collection.Point.Name=="Kashipur"] <- "Kashipur"
data4$Collection.Point.NameF[data4$Collection.Point.Name=="Mohonpur"] <- "Mohonpur"
data4$Collection.Point.NameF[data4$Collection.Point.Name=="Osmanpur"] <- "Osmanpur"
data4$Collection.Point.NameF[data4$Collection.Point.Name=="Parbhangura East"] <- "Parbhangura East"
data4$Collection.Point.NameF[data4$Collection.Point.Name=="Parbhangura West"] <- "Parbhangura West"
data4$Collection.Point.NameF[data4$Collection.Point.Name=="Purbo Batia"] <- "Purbo Batia"
data4$Collection.Point.NameF[data4$Collection.Point.Name=="Sonahara"] <- "Sonahara"

data4$Collection.Point.Name <- data4$Collection.Point.NameF

data1$DFT.codeCP <- paste(data1$DFT.Code,data1$CollectionPoint, sep = "")
data4$DFT.codeCP <- paste(data4$DFT.Code,data4$Collection.Point.NameF, sep = "")
dataM <- merge(data1,data4,by=c("DFT.codeCP"),all=T)
dataM$DFT.Code <- dataM$DFT.Code.y
dataM$Shift. <- dataM$Shift
dataM$Collection.Point.Name <- dataM$CollectionPoint
myvars <- c("DFT.Code", "To", "Shift.", "Qty.Ltr.", "FatPercent", "SNFPercent", "Rate.Rs", "AmountRS", "Site",
            "Date", "Collection.Point.Name", "LG.Code", "Sex..W.1..M.2.", "Upazila", "District", "Village","Para", "DFT.codeCP","Producer.Name",
            "Under.Chilling.Plant","Time","Union","Husbandand..Father.s.name","Relation.With.HH.Head" )

dataM <- dataM[myvars]

###dataM <- dataM[which(dataM$Qty.Ltr.   < 50),]

#Separate Dates into parts #DOESN"T WORK
dataM$DateString <- as.character(dataM$DateF)
dataM$Split <- strsplit(as.character(dataM$DateString, as.charactor("-"), fixed = TRUE, perl = FALSE, useBytes = FALSE))
data1$Split1 <- sapply(data1$Split, "[[", 1) 

dataM$DateF <- as.Date(dataM$Date,format="%d/%m/%Y")

write.csv(dataM,"/Users/heatherkrause/Dropbox/Projects/SDVC II/DFT Data/Final DFT Data Uploaded to Marjan Dashboard/DFTNov2014_Correct.csv")




