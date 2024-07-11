## How I used R in this project

### Preparation

In this case study I used the Tidyverse package with its libraries, including Lubridate for working with dates and times.

```{r}
install.packages("tidyverse")
library(tidyverse)
library(lubridate)
```

After that, I uploaded the database used, there were 12 files, relative to one year of data. The source of the files is here: <https://divvy-tripdata.s3.amazonaws.com/index.html>

```{r}
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
```

Right, there are a lot of files, so I made them into a single df:

```{r}
all_trips <- bind_rows(trip_06_2023, trip_07_2023, trip_08_2023, trip_09_2023, trip_10_2023, trip_11_2023, trip_12_2023, trip_01_2024, trip_02_2024, trip_03_2024, trip_04_2024, trip_05_2024)
```

As a next step, I had the df inspected:

```{r}
colnames(all_trips)
nrow(all_trips)
dim(all_trips)
head(all_trips)
str(all_trips)
```

### Processing

That's it! Here we begin the work of adjusting the data and analyzing it. At this point, I needed to exclude journeys of less than 1 minute, as instructed by the data provider, because this count is associated with improper time counting, when bikes are removed for moving or when the user wants to confirm that the bike has been docked correctly.

To do this, I used the command:

```{r}
all_trips <- all_trips[!(all_trips$travel_time<60),]
```

Perfect! Another point I had to adjust was changing the days of the week from numbers to full names.

```{r}
all_trips <- all_trips %>% 
  mutate(weekday = recode(weekday,"1" = "Sunday", "2" = "Monday", "3" = "Tuesday", "4" = "Wednesday", "5" = "Thursday", "6" = "Friday", "7" = "Saturday"))
```

All done! Then I started extracting the information for the analysis. First I checked the breakdown of the numbers of casual users and members:

```{r}
table(all_trips$user_type)
```

I wanted to check the monthly average number of journeys for the whole period, broken down by type of user.

```{r}
aggregate(all_trips$travel_time ~ all_trips$user_type + all_trips$travel_month + all_trips$year, FUN = mean)
```

I also found it interesting to check the median, minimum and maximum journey times.

```{r}
aggregate(all_trips$travel_time ~ all_trips$user_type + all_trips$travel_month + all_trips$year, FUN = median)
aggregate(all_trips$travel_time ~ all_trips$user_type, FUN = min)
aggregate(all_trips$travel_time ~ all_trips$user_type, FUN = max)
```

I also wanted to check this variation in weekly travel time.

```{r}
aggregate(all_trips$travel_time ~ all_trips$user_type + all_trips$weekday, FUN = mean)
aggregate(all_trips$travel_time ~ all_trips$user_type + all_trips$weekday, FUN = median)
```

Finally, I stored the data relating to the annual and monthly averages of times and journeys to generate CSV files.

```{r}
avg_anual_trips <- aggregate(all_trips$travel_time ~ all_trips$user_type + all_trips$travel_month + all_trips$year, FUN = mean)
avg_weekly_trips <- aggregate(all_trips$travel_time ~ all_trips$user_type + all_trips$weekday, FUN = mean)
```

Generating the analysis CSV files:

```{r}
write.csv(avg_anual_trips, file = "C:\\Users\\rubat\\Documents\\Proj2024\\Data Analyst\\Projetos\\Estudo de caso 1\\R_project\\avg_anual_trips.csv", row.names = FALSE)
write.csv(avg_weekly_trips, file = "C:\\Users\\rubat\\Documents\\Proj2024\\Data Analyst\\Projetos\\Estudo de caso 1\\R_project\\avg_weekly_trips.csv", row.names = FALSE)
```

I thought it was important to look at usage behavior in relation to bicycle models. To do this, I used the following command:

```{r}
bike_model <- all_trips %>%
  group_by(all_trips$weekday, all_trips$bike_type, all_trips$user_type) %>%
  summarise(daily_count = n(), .groups = 'drop')
```

With the new df bike_model generated, I renamed the columns:

```{r}
bike_model<- rename(bike_model, weekday = "all_trips$weekday",  bike_type = "all_trips$bike_type", user_type = "all_trips$user_type")
```

I've also saved the CSV file:

```{r}
write.csv(bike_model, file = "C:\\Users\\rubat\\Documents\\Proj2024\\Data Analyst\\Projetos\\Estudo de caso 1\\R_project\\bike_model.csv", row.names = FALSE)
```

### Conclusion

As this is a teaching project, I chose to create a dashboard with Tableau. [Check it out here.](https://public.tableau.com/views/Cyclistic_Data_Viz/Cyclistic_Analysis?:language=pt-BR&:sid=&:redirect=auth&:display_count=n&:origin=viz_share_link)
