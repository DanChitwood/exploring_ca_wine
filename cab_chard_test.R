library(ggplot2) # read in libraries
library(ggmap)
library(maps)
library(mapdata)
library(viridis)
library(tidyverse)

states <- map_data("state") # read in state data
ca_df <- subset(states, region == "california") # subset state data to just CA

counties <- map_data("county") # read in county data
ca_county <- subset(counties, region == "california") # subset for CA counties


ca_base <- ggplot(data = ca_df, mapping = aes(x = long, y = lat, group = group)) + # create the base viz for CA state
  coord_fixed(1.3) + 
  geom_polygon(color = "gray90", fill = "white") # set the state fill color here


data <- read.csv("./cab_chard_1971_2020.csv", header=TRUE) # read in data
data$year <- as.factor(data$year) # make sure year is a factor
summary(data) # check everything is OK

cab <- subset(data, variety=="cabernet_sauvignon") # subset for cab, chard, 1971, and 2020
chard <- subset(data, variety=="chardonnay")

cab_1971 <- subset(cab, year=="1971")
cab_1971 <- droplevels(cab_1971)

cab_2020 <- subset(cab, year=="2020")
cab_2020 <- droplevels(cab_2020)

chard_1971 <- subset(chard, year=="1971")
chard_1971 <- droplevels(chard_1971)

chard_2020 <- subset(chard, year=="2020")
chard_2020 <- droplevels(chard_2020)

cab_1971_county <- inner_join(ca_county, cab_1971, by = "subregion") # merge data with county info
cab_2020_county <- inner_join(ca_county, cab_2020, by = "subregion")
chard_1971_county <- inner_join(ca_county, chard_1971, by = "subregion")
chard_2020_county <- inner_join(ca_county, chard_2020, by = "subregion")

data_to_map <- chard_2020_county # SELECT HERE WHICH DATA TO MAP

ditch_the_axes <- theme(
  axis.text = element_blank(),
  axis.line = element_blank(),
  axis.ticks = element_blank(),
  panel.border = element_blank(),
  panel.grid = element_blank(),
  axis.title = element_blank()
  )

final_map <- ca_base + 
      geom_polygon(data = data_to_map, aes(fill = bearing), color = "gray90") + # county fill and county line color
      geom_polygon(color = "black", fill = "NA") + # state line color
      theme_bw() +
      ditch_the_axes

final_map + scale_fill_gradient(low="white", high="black", trans="log10", breaks=c(10,100,1000,10000), limits=c(1,21207))

# final_map + scale_fill_viridis(option="viridis", trans="log10", breaks=c(10,100,1000,10000), limits=c(1,21207)) # if you want color

ggsave("chard_2020.jpg")










