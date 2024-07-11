#Installing packages and libraries
install.packages("tidyverse")
library(tidyverse)
library(lubridate)


#Upload datasets
trip_06_2023 <-read_csv("202306-divvy-tripdata.csv")
trip_07_2023 <-read_csv("202307-divvy-tripdata.csv")
trip_08_2023 <-read_csv("202308-divvy-tripdata.csv")
trip_09_2023 <-read_csv("202309-divvy-tripdata.csv")
trip_10_2023 <-read_csv("202310-divvy-tripdata.csv")
trip_11_2023 <-read_csv("202311-divvy-tripdata.csv")
trip_12_2023 <-read_csv("202312-divvy-tripdata.csv")
trip_01_2024 <-read_csv("202401-divvy-tripdata.csv")
trip_02_2024 <-read_csv("202402-divvy-tripdata.csv")
trip_03_2024 <-read_csv("202403-divvy-tripdata.csv")
trip_04_2024 <-read_csv("202404-divvy-tripdata.csv")
trip_05_2024 <-read_csv("202405-divvy-tripdata.csv")

#Joining datasets into a single file
all_trips <- bind_rows(trip_06_2023, trip_07_2023, trip_08_2023, trip_09_2023, trip_10_2023, trip_11_2023, trip_12_2023, trip_01_2024, trip_02_2024, trip_03_2024, trip_04_2024, trip_05_2024)

#Excluir arquivos individuais
rm(trip_06_2023, trip_07_2023, trip_08_2023, trip_09_2023, trip_10_2023, trip_11_2023, trip_12_2023, trip_01_2024, trip_02_2024, trip_03_2024, trip_04_2024, trip_05_2024)

#Inspecting the new table
colnames(all_trips)
nrow(all_trips)
dim(all_trips)
head(all_trips)
str(all_trips)

#Excluding values of less than 1 minute
all_trips <- all_trips[!(all_trips$travel_time<60),]

#Changing weekday format from number to text
all_trips <- all_trips %>% 
  mutate(weekday = recode(weekday,"1" = "Sunday", "2" = "Monday", "3" = "Tuesday", "4" = "Wednesday", "5" = "Thursday", "6" = "Friday", "7" = "Saturday"))


#Checking the number of users between members and casual users
table(all_trips$user_type)

#Creating new columns separating date, time and month
all_trips$started_trip <- as.Date(all_trips$started_at)
all_trips$travel_month <- format(as.Date(all_trips$started_trip), "%m")
all_trips$year <- format(as.Date(all_trips$started_trip), "%Y")


#Compare travel times between members and casual users by month
aggregate(all_trips$travel_time ~ all_trips$user_type + all_trips$travel_month + all_trips$year, FUN = mean)
aggregate(all_trips$travel_time ~ all_trips$user_type + all_trips$travel_month + all_trips$year, FUN = median)
aggregate(all_trips$travel_time ~ all_trips$user_type, FUN = max)
aggregate(all_trips$travel_time ~ all_trips$user_type, FUN = min)

#Compare weekday usage
aggregate(all_trips$travel_time ~ all_trips$user_type + all_trips$weekday, FUN = mean)
aggregate(all_trips$travel_time ~ all_trips$user_type + all_trips$weekday, FUN = median)

#Generate CSV with annual and weekly averages for the entire period
avg_anual_trips <- aggregate(all_trips$travel_time ~ all_trips$user_type + all_trips$travel_month + all_trips$year, FUN = mean)
avg_weekly_trips<- aggregate(all_trips$travel_time ~ all_trips$user_type + all_trips$weekday, FUN = mean)

#Create an archive of annual and weekly averages
write.csv(avg_anual_trips, file = "C:\\Users\\rubat\\Documents\\Proj2024\\Data Analyst\\Projetos\\Estudo de caso 1\\R_project\\avg_anual_trips.csv", row.names = FALSE)
write.csv(avg_weekly_trips, file = "C:\\Users\\rubat\\Documents\\Proj2024\\Data Analyst\\Projetos\\Estudo de caso 1\\R_project\\avg_weekly_trips.csv", row.names = FALSE)

#Count of bike models used by type of user
bike_model <- all_trips %>%
  group_by(all_trips$weekday, all_trips$bike_type, all_trips$user_type) %>%
  summarise(daily_count = n(), .groups = 'drop')

#Rename the columns in the bike_model dataframe
bike_model<- rename(bike_model, weekday = "all_trips$weekday",  bike_type = "all_trips$bike_type", user_type = "all_trips$user_type")

#Create a file to record usage by bike model
write.csv(bike_model, file = "C:\\Users\\rubat\\Documents\\Proj2024\\Data Analyst\\Projetos\\Estudo de caso 1\\R_project\\bike_model.csv", row.names = FALSE)
