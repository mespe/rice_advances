library(raster)
library(RColorBrewer)
library(rgdal)
library(maps)
map_data_loc = "../data/map_data.rda"

if(!file.exists(map_data_loc)){
    usda_rice <- raster("~/Dropbox/D--CDL-NASS_DATA_CACHE-extract_3_CDL_2015_stat_clip_20161101201010_1475574269.tif")
    usda_rice <- aggregate(usda_rice, fact = 100)
    usda_rice <- projectRaster(usda_rice, crs = CRS("+init=epsg:4326"))

    usda_rice <- crop(usda_rice, extent(-125, -120, 36, 41))
    usda_rice[usda_rice < 0.01] <- NA
    usda_rice <- trim(usda_rice)
    save(usda_rice, file = map_data_loc)
}else{
    load(map_data_loc)
} 
cols = brewer.pal(9, "YlGn")

pdf(file = "../output/map.pdf")
map("state", "California", xlim = c(-123.5,-120.5), ylim = c(37,40),
    fill = TRUE, col = "grey80")
map.axes()
map.scale(x = -123.4, y = 37.3, ratio = FALSE, relwidth = 0.15,
          cex = 0.8)

plot(usda_rice, add = TRUE,
     col = cols[6],
     # col = "chartreuse3",     
     # col = colorRampPalette(cols)(255),
     legend = FALSE, interpolate = FALSE)
points(y = 39.4648, x = -121.7342, pch = 21, col = "black", bg = "white", cex = 2)
legend("bottomright", legend = c("Rice Experiment Station",
                              "Rice harvested area"),
       pch = c(21, NA),
       bg = "white",
       fill = c(NA,cols[6]),
       border = "white",
       cex = 1.1,
       bty = "o")
text(-123, 37.7, "San Francisco\n Bay", cex = 0.8, font = 3)                           
dev.off()
