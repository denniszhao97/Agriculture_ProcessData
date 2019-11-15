library(readr)
corn_lowa_raw <- read_csv("Desktop/corn_lowa_raw.csv", col_types = cols(Value = col_number()))

library(sqldf)
corn_lowa_raw = sqldf("select Year, County, Data_Item, Value from corn_lowa_raw order by Year, County")

yield_lowa_table = sqldf("select * from corn_lowa_raw where Data_Item = 'CORN, GRAIN - YIELD, MEASURED IN BU / ACRE'")

Irrigated_lowa_table = sqldf("select * from corn_lowa_raw where Data_Item = 'CORN, GRAIN, IRRIGATED - ACRES HARVESTED'")

Harvest_lowa_table = sqldf("select * from corn_lowa_raw where Data_Item = 'CORN, GRAIN - ACRES HARVESTED'")

temp = sqldf("select yield_lowa_table.Year, yield_lowa_table.County, yield_lowa_table.Value as Yield, Irrigated_lowa_table.Value as Area_Immigated from yield_lowa_table left join Irrigated_lowa_table on yield_lowa_table.County = Irrigated_lowa_table.County and yield_lowa_table.Year = Irrigated_lowa_table.Year")

final = sqldf("select temp.County, temp.Year, temp.Yield, temp.Area_Immigated, Harvest_lowa_table.value as Area, (Harvest_lowa_table.value - temp.Area_Immigated) as Area_Nonirrigated from temp left join Harvest_lowa_table where temp.Year = Harvest_lowa_table.Year and temp.County = Harvest_lowa_table.County")

result = sqldf("select Year, County, Yield, Area_Immigated as Area_irrigated, Area, Area_NONirrigated, (Area_Immigated / Area) as Irrigated_actualprop from final")

write.csv(MyData, file = "MyData.csv")




