# Use data compiled pre-1995

library(readxl)

ff = "../data/RES Variety Trail 1984-1994.xls"
n_sheets = length(excel_sheets("../data/RES Variety Trail 1984-1994.xls"))

pre95_head = lapply(1:n_sheets, read_excel, path = ff, n_max = 5, col_types = "text", col_names = FALSE)

lapply(pre95_head, function(x) grep(pattern = "Location", as.data.frame(x)[,1]))

pre95 = lapply(1:n_sheets, read_excel, path = ff, skip = 3)

pre95 = lapply(pre95, as.data.frame, stringsAsFactor = FALSE)

pre95 = do.call(rbind, pre95)


# fix colnames by hand
cc = c(
"site"       ,    "trial_type"     ,     "county"              ,
 "year"           ,    "planted"  ,     "Advanced/Prelminary" ,
 "#"              ,    "rep"           ,     "#__2"                ,
 "Experimental ID",    "id"           ,     "#__3"                ,
 "#__4"           ,    "Source"         ,     "grain_type"                ,
 "seedling_vigor"          ,    "Date"           ,     "dth"                ,
 "height"           ,    "lodging"         ,     "(sq ft)"             ,
 "(lbs)"          ,    "moisture"              ,     "yield_lb"       ,
 "Notes"          )   

colnames(pre95) = cc

tmp = lapply(seq_along(all_vt_result), function(i){
    idx = match(colnames(all_vt_result)[i], cc)
    # browser()
    if(is.na(idx)){
        c(all_vt_result[,i], rep(NA, nrow(pre95)))
    } else {
        c(all_vt_result[,i], pre95[,idx])
    }
    # print("hi")
})

all_data = as.data.frame(tmp, stringsAsFactors = FALSE)

colnames(all_data) = colnames(all_vt_result)
