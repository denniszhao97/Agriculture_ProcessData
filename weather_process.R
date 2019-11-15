# find county name by lontitude and latitude
find_county <- function(Lon, Lat){
  temp = revgeocode(c(Lon, Lat), output = "all")
  county = ""
  for (i in 1:length(temp$results)){
    temp_2 = temp$results[[i]]$formatted_address
    if (str_detect(temp_2,"County") == TRUE){
      result = str_locate(temp_2,"County")
      county = substr(temp_2, 1,result[1]-2)
      county = toupper(county)
    }
  }
  return(county)
}

#load data
lowa_weather <- read_csv("Desktop/Agri_raw_data/Iowa_weather_raw/Iowa_weather_2002_raw.csv",col_types = cols(TMAX = col_number(),TMIN = col_number()))

#add county coloumn
trail = vector(mode = "character", length = 0)
for (i in 1:length(lowa_weather$LONGITUDE)){
  result = find_county(lowa_weather$LONGITUDE[i],lowa_weather$LATITUDE[i])
  trail = c(trail,result)
}

lowa_weather$County = trail

# aggregate at Date and County level
final = sqldf("select DATE, County, Avg(PRCP) as PRCP, AVG(TMAX) as TMAX, AVG(TMIN) as TMIN from lowa_weather group by DATE, County")
# disparse the date into year, month, day
final$Year = format(as.Date(final$DATE), "%Y")
final$Month = format(as.Date(final$DATE), "%m")
final$Day = format(as.Date(final$DATE), "%d")
real_final = sqldf("select Year, Month, Day, County, PRCP, TMAX, TMIN from final order by County")
#write out processed data
write_csv(real_final, "Iowa_weather_2001_Processed.csv")
