rm(list = ls())
library(nlme)
library(lattice)
library(car)
library(spida)
library(magrittr)

#names needed for final data ingest DFT.Code, To, Shift., Qty.Ltr., FatPercent, SNFPercent, Rate.Rs, AmountRS, Site,
#  Date, Collection.Point.Name, LG.Code, Sex..W.1..M.2., Upazila, District, Village, Time

data1 <- read.csv("/Users/heatherkrause/Dropbox/Projects/SDVC II/DFT Data/Formatted DFT Data from Elance/DFT November14 formatted.csv", comment.char = "", colClasses = "character")

data4 <- read.csv("/Users/heatherkrause/Dropbox/Projects/SDVC II/DFT Data/Mapping Documents/Final DFT Map Fall 2014.csv", comment.char = "", colClasses = "character")

