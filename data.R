
# Initial formatting of the data

taf.library(icesFO)
library(dplyr)

mkdir("data")

# load species list
species_list <- read.taf("bootstrap/data/FAO_ASFIS_species/species_list.csv")
sid <- read.taf("bootstrap/data/ICES_StockInformation/sid.csv")

# 1: ICES official cath statistics

hist <- read.taf("bootstrap/data/ICES_nominal_catches/ICES_historical_catches.csv")
official <- read.taf("bootstrap/data/ICES_nominal_catches/ICES_2006_2017_catches.csv")
prelim <- read.taf("bootstrap/data/ICES_nominal_catches/ICES_preliminary_catches.csv")

catch_dat <- 
  format_catches(2019, "Barents Sea", 
    hist, official, prelim, species_list, sid)


out <-unique(grep("erring", catch_dat$COMMON_NAME, value = TRUE))
#[1] "Pacific herring"  "Atlantic herring"
out2<-unique(grep("ackerel", catch_dat$COMMON_NAME, value = TRUE))
out3<-unique(grep("lue whiting", catch_dat$COMMON_NAME, value = TRUE))
out <- append(out, out2)
out <- append(out, out3)

library(operators)
catch_dat <- dplyr::filter(catch_dat, COMMON_NAME %!in% out)
detach("package:operators", unload=TRUE)


write.taf(catch_dat, dir = "data", quote = TRUE)

# 2: SAG
sag_sum <- read.taf("bootstrap/data/SAG_data/SAG_summary.csv")
sag_refpts <- read.taf("bootstrap/data/SAG_data/SAG_refpts.csv")
sag_status <- read.taf("bootstrap/data/SAG_data/SAG_status.csv")

clean_sag <- format_sag(sag_sum, sag_refpts, 2019, "Barents")
clean_status <- format_sag_status(sag_status, 2019, "Barents Sea")

Barents_stockList <- c("aru.27.123a4",
                       "cap.27.1-2",
                       "cod.27.1-2",
                       "cod.27.1-2coast",
                       "gfb.27.nea",
                       "ghl.27.1-2",
                       "had.27.1-2",
                       "lin.27.1-2",
                       "pok.27.1-2",
                       "pra.27.1-2",
                       "reb.27.1-2",
                       "reg.27.1-2",
                       "rjr.27.23a4",
                       "rng.27.1245a8914ab",
                       "tsu.27.nea",
                       "usk.27.1-2")
clean_sag<-clean_sag%>%filter(StockKeyLabel %in% Barents_stockList)
clean_status<-clean_status%>%filter(StockKeyLabel %in% Barents_stockList)
                  
write.taf(clean_sag, dir = "data")
write.taf(clean_status, dir = "data", quote = TRUE)
