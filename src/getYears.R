
doc <- readLines("../data/var_list.txt")
first <- grep("^Cultivar", doc)
last <- grep("^$", doc)
last <- last[last > first][1]

txt <- strsplit(doc[first:(last-1)], " {2,}")
txt <- do.call(rbind, txt)

yrTbl <- as.data.frame(txt[-1,], stringsAsFactors = FALSE)
colnames(yrTbl) <- txt[1,]

yrTbl$Year <- as.numeric(yrTbl$Year)
yrTbl$Cultivar <- gsub("M-", "M", yrTbl$Cultivar)

## Add M105, M207, and M209 by hand

yrTbl <- rbind(yrTbl, data.frame(Cultivar = c("M105","M207","M209"),
                                 Grain = c("M","M","M"),
                                 Year = c(2012, 2005, 2015),
                                 Maturity = c("E","E","E"),
                                 Parents = ""))

save(yrTbl, file = "../data/yrTbl.Rda")
