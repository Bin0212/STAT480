---
  title: "STAT480_Homework_1"
author: "Bin Feng"
output: pdf_document
---
  ```{r setup}
#include library
library(RSQLite)
library(biganalytics)
library(foreach)
require("knitr")
#set working directory
opts_knit$set(root.dir = "~/Stat480/RDataScience/AirlineDelays")
```
#Question 1
This exercise is for aggregate departure delay information for flights from 1987 to 1989 in the data.  

(a) Using SQL, obtain the total number of flights in the data in the 1980s.
```{r}
#build connection to the database
delay.con <- dbConnect(RSQLite::SQLite(), dbname = "AirlineDelay1980s.sqlite3")
#calculate the total rows in 1980s, which is the total number of flights in 1980s plus 1
total_80s <- dbGetQuery(delay.con, 
                        "SELECT COUNT(*) FROM AirlineDelay1980s") - 1
total_80s
```
Based on th output, the total number of flights in the data in the 1980s is 11555122. "-1" in the code is to subtract the additional header line included in the database. 

(b) Using SQL, obtain the number of flights with departure delayed by more than 15 minutes in the 1980s in the data.
```{r}
#query the daparture delay data through the SQL connection 
delay_gr15_80s <- dbGetQuery(delay.con, 
                             "SELECT COUNT(*) FROM AirlineDelay1980s WHERE DepDelay > 15")
delay_gr15_80s
```
Based on th output, the number of flights with departure delayed by more than 15 minutes in the 1980s is 1701204. Departure delays with "NA" are not included.

(c) Comment on the percentage of flights with departure delayed by more than 15 minutes during that time period.
```{r}
#Calculate the percentage of depature delayed by more than 15 min
delay_per_80s <- delay_gr15_80s/total_80s * 100
delay_per_80s
```
Based on the output, the percentage of flights with departure delayed by more than 15 minutes during that time period is 14.72251%. I think such percentage is in a moderate delay level. Most of passengers can take their flights and depart on time. Such modereate delay rate may because there aren't too many flights schedule per day during 1980s. Therefore, small delays are less likely to accumulate into a large delay that is greater than 15 minutes.

#Question 2
Now we look at the similar delay information by month during that period. (Note: This is just by month, not by month and year. For instance, flights for January 1987, January 1988, and January 1989 will be aggregated together.)  

(a) Obtain a table for the total number of flights in our data by month in the 1980s from the data.
```{r}
#using SQL language FROM and GROUP BY
total_month_80s <- dbGetQuery(delay.con, 
"SELECT COUNT(*), Month FROM AirlineDelay1980s GROUP BY Month")
total_month_80s
```
The table for total number of flights by month is shown above. Note that the additional last line in the table is because of the header line in the database. 

(b) In a separate table, obtain the number of flights by month with departure delayed by more than 15 minutes in the 1980s in the data.
```{r}
delay_month_gr15_80s <- dbGetQuery(delay.con, 
"SELECT COUNT(*), Month FROM AirlineDelay1980s WHERE DepDelay > 15 GROUP BY Month")
delay_month_gr15_80s
```
The table for total number of flights by month with departure delayed by more than 15 minutes is shown above. Note that the additional last line in the table is because of the header line in the database. 

(c) From the results in parts a and b, programmatically calculate the percentage of flights delayed by more than 15 minutes by month of year during that time period, and comment on how the monthly rates compare to the overall rate found in exercise 1.
```{r}
#calculate the percentage by matrix division
deley_per_month_80s <- integer(12)
deley_per_month_80s <- delay_month_gr15_80s[1:12,1] / total_month_80s[1:12,1] * 100
#construct the table with monthes included
deley_per_month_80s <- cbind(deley_per_month_80s, delay_month_gr15_80s[1:12,2])
colnames(deley_per_month_80s) <- c("delay_percentage", "month")
deley_per_month_80s
#close connection
dbDisconnect(delay.con)
```
The delay percentage by month is shown above. Comparing with the overall rate (14.72251%), note that monthes (1, 2, 3, 12) have higher delay rate while monthes (4, 5, 6, 7, 8, 9, 10, 11) have lower delay rate. Generally, the delay rates by month form a U-shape, indicating that both at the beginning and towards the end of a year show higher percentage of delay rate by more than 15 minutes. During the middle of a year, delay rates are usually lower. The reason behind this may because: 1. people travel more during holiday seasons; 2. airplain workers need some time to catch up the efficiency after the holiday season; 3. winter usually brings worse weather conditions like heavy snow or extremely low temperature that can cause flight delays.  

#Question 3
Now we look at aggregate flight data for 2007 and 2008  

(a) Obtain the total number of flights in 2007 and 2008, the number of flights delayed by more than 15 minutes during that time period, and the percentage of flights delayed by more than 15 minutes during that time period.
```{r}
#Attach the same big matrix to flight0708 using the descriptor file without creating any new large matrix
flight0708 <- attach.big.matrix("air0708.desc")
#count the total number of flight using dim(), -1 to exclude the header count
total_0708 <- dim(flight0708)[1] - 1
total_0708
#count the number of delays that are more than 15min
#using na.rm to remove lines with data "Not Available"
delay_gr15_0708 <- sum(flight0708[,"DepDelay"] > 15, na.rm=TRUE)
delay_gr15_0708
#calculate the percentage
deley_per_0708 <- delay_gr15_0708 / total_0708 * 100
deley_per_0708
```
Based on the output, the total number of flights in 0708 is 14462942. The number of flights delayed by more than 15 minutes is 2784966. Note that delay time with "NA"s are excluded when counting delay flight number. The percentage is 19.25587%. 

(b) Comment on how this delay rate compares with the rate found for the 1987-1989 flights.  
The delay rate for 1987-1989 is 14.72251%. The dalay rate for 2007 and 2008 is 19.25587%. Comparing these two rate, note that the delay rate has increased significantly by the time reaching 2007 and 2008. This may because the number of flights scheduled per day has increased dramatically. Therefore, a few minor delays are more likely to results in larger delays in 2007 and 2008 than 1980s.

#Question 4
Now we look at the delay rate per year for 2007 and 2008.  

(a) For each year from 2007 to 2008, calculate the number of flights and the number of flights delayed by more than 15 minutes. (You should have counts for 2007 and counts for 2008.) Be sure to use efficient programming techniques.
```{r}
#calculate by each year, use split-apply-combine method here. Since there are only two years to split, efficiency improve won't be significant. But it is still a good practise. 
flight_by_year <- split(1:nrow(flight0708), flight0708[,"Year"])
names(flight_by_year) <- c("2007", "2008")

#Substract 1 in flight count for 2007 to remove the additional header line.
total_year_0708 <- foreach(yrInds = flight_by_year, .combine = c) %do% {
  length(yrInds)
}
total_year_0708[1] <- total_year_0708[1] - 1
total_year_0708

#calculate the delay flight by each year based on split-apply-combine method.
delay_gr15_year_0708 <- foreach(yrInds = flight_by_year, .combine=c) %do% {
  sum(flight0708[yrInds,"DepDelay"] > 15, na.rm=TRUE)
}
delay_gr15_year_0708
```
Based on the output, total number of flights are 7453214 (2007) and 7009728 (2008). Total number of flights delayed by more than 15 minutes are 1508570 (2007) and 1276396 (2008). Note when counting total number of flights in 2007, 1 is substracted to exclued the header line. Also note that flights with delay information "NA" are not included in the delay flights counting. 

(b) Compute the percentage of flights with departure delayed by more than 15 in each of those two years and compare the annual rates with the aggregate rate found in exercise 3.
```{r}
#compute the percentage as follow for 2007 and 2008
delay_per_year_07 <- delay_gr15_year_0708[1] / total_year_0708[1] * 100
delay_per_year_08 <- delay_gr15_year_0708[2] / total_year_0708[2] * 100
delay_per_year_07
delay_per_year_08
```
Comparing the annual rate of 2007(20.24053%) and 2008(18.20892%) with the aggregate rate (19.25587%), note that the annual rate for 2007 is higher than the aggregate and the annual rate for 2008 is lower than the aggregate. Such observation indicates that the severity of flight delay may has been moderated from 2007 to 2008. 

#Question 5
This exercise is to compare delay rates by day of week from 1987 to 1989 with delay rates by day of week from 2007 to 2008 within the data provided.  

a) Calculate the percentage of flights delayed by more than 15 minutes for each day of the week for the period from 1987 to 1989 in the data provided.
```{r}
#build connection to the database
delay.con <- dbConnect(RSQLite::SQLite(), dbname = "AirlineDelay1980s.sqlite3")
#calcute the total flight by week 
total_week_80s <- dbGetQuery(delay.con, 
                             "SELECT COUNT(*), DayOfWeek FROM AirlineDelay1980s GROUP BY DayOfWeek")
#calculate the delay rate by week, the last addition line is due to the header line
delay_week_gr15_80s <- dbGetQuery(delay.con, 
                                  "SELECT COUNT(*), DayOfWeek FROM AirlineDelay1980s WHERE DepDelay > 15 GROUP BY DayOfWeek")
#Calculate the percentage
delay_per_week_80s <- delay_week_gr15_80s[1:7,1] / total_week_80s[1:7,1] * 100
delay_per_week_80s <- cbind(delay_per_week_80s, delay_week_gr15_80s[1:7,2])
colnames(delay_per_week_80s) <- c("delay_percentage", "DayOfWeek")
delay_per_week_80s
#close connection
dbDisconnect(delay.con)
```
The percentages of flights delayed by more than 15 minutes for each day of the week are shown above. Thursday and Friday have the two largest delay rate. Flights with delay information "NA" are not included in the delay flights counting. 

b) Repeat part a for 2007 and 2008 data.
```{r}
#Calculate the total flight by week
flight_by_week <- split(1:nrow(flight0708), flight0708[,"DayOfWeek"])
names(flight_by_week) <- c("1", "2", "3", "4", "5", "6", "7")

#Substract 1 in flight counting for 2007 to remove the additional number for the header line. 
total_week_0708 <- foreach(wkInds = flight_by_week, .combine = c) %do% {
  length(wkInds)
}
total_week_0708[1] <- total_week_0708[1] - 1

#Calculate delay flight by week based on split-combine-apply method
delay_gr15_week_0708 <- foreach(wkInds = flight_by_week, .combine=c) %do% {
  sum(flight0708[wkInds,"DepDelay"] > 15, na.rm=TRUE)
}

#Calculate the percentage
delay_per_week_0708 <- delay_gr15_week_0708 / total_week_0708 * 100
delay_per_week_0708 <- cbind(delay_per_week_0708, c(1,2,3,4,5,6,7))
colnames(delay_per_week_0708) <- c("delay_percentage", "DayOfWeek")
delay_per_week_0708
```
The percentages of flights delayed by more than 15 minutes for each day of the week are shown above. Friday and Sunday have the two largest delay rate. Note that when counting total number of flights in Monday, 1 is substracted to exclued the header line. Also note that flights with delay information "NA" are not included in the delay flights counting. 

c) Comment on similarities and differences in the delay rate on particular days of week between the two time periods.  
For similarity, note that both time periods have a higher delay rate on DayOfWeek (4-Thursday, 5-Friday) and a lower delay rate on DayOfWeek (6-Saturday). For differences, 0708 flight data shows a higher delay rate on DayOfWeek (1-Monday, 7-Sunday) and 80s flight data shows a lower delay rate. Also, 0708 flight data indicate a lower delay rate on DayOfWeek (2-Tuesday, 3-Wednesday) while 80s flight data shows a higher delay rate. Such similarities and difference may reflect how people's working and relaxation styles have changed over time. 

