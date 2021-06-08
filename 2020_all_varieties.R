library(ggplot2)
library(viridis)

data <- read.csv("./2020_complete_data.csv", header=TRUE)

names(data)
summary(data$type)


data <- droplevels(data[!data$cultivar=="TOTAL RED WINE",])
data <- droplevels(data[!data$cultivar=="TOTAL WHITE WINE",])
data <- droplevels(data[!data$cultivar=="TOTAL RAISIN",])
data <- droplevels(data[!data$cultivar=="TOTAL TABLE",])
data <- droplevels(data[!data$cultivar=="OTHER RED WINE",])
data <- droplevels(data[!data$cultivar=="OTHER WHITE WINE",])
data <- droplevels(data[!data$cultivar=="OTHER RAISIN",])
data <- droplevels(data[!data$cultivar=="OTHER TABLE",])

data <- data[data$bearing!=0,]

p <- ggplot(data, aes(x=reorder(cultivar, -bearing), y=reorder(county, bearing), fill=bearing))
p + geom_tile() + 
scale_fill_viridis(trans="log10") +

theme(axis.text.x = element_text(angle = 90, vjust =-0.5, hjust=0), axis.title.x=element_blank(), 
axis.title.y=element_blank(),
plot.title=element_text(size = 25, face = "bold")) +

coord_fixed() + 
scale_x_discrete(position="top") +
ggtitle("Top grape producing California counties and \n varieties by bearing acres in 2020") +
labs(fill = "Bearing Acres") 

ggsave("2020_wine_acres.jpg")

