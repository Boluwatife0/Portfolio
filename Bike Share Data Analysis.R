# The Business Task: Convert casual riders into members.

# The goal of the marketing team is to design marketing strategies aimed at converting casual riders into annual members.
# My task is to answer one of three questions that will guide the future marketing program - How do annual members and casual riders use Cyclistic bikes differently?

# Company: Cyclistic, a bike-share company in Chicago (fictional). A bike-share program that features more than 5,800 bicycles and 600 docking stations. 
# Cyclistic sets itself apart by also offering reclining bikes, hand tricycles, and cargo bikes, making bike-share more inclusive to people with disabilities and riders who can’t use a standard two-wheeled bike.


#The other two questions are: 1) Why would casual riders buy Cyclistic annual memberships? 2) How can Cyclistic use digital media to influence casual riders to become members?
  
#Key Stakeholders

# Primary stakeholder - the director of marketing

# Secondary stakeholders - the marketing analytics team and the executive team




library(tidyverse) # wrangle data
library(lubridate) # wrangle date attributes
library(ggplot2) # visualize data

# Read the data
apr_2020 <- read.csv('/Users/boluogunle/Downloads/202004-divvy-tripdata.csv')
may_2020 <- read.csv('/Users/boluogunle/Downloads/202005-divvy-tripdata.csv')
jun_2020 <- read.csv('/Users/boluogunle/Downloads/202006-divvy-tripdata.csv')
jul_2020 <- read.csv('/Users/boluogunle/Downloads/202007-divvy-tripdata.csv')
aug_2020 <- read.csv('/Users/boluogunle/Downloads/202008-divvy-tripdata.csv')
sep_2020 <- read.csv('/Users/boluogunle/Downloads/202009-divvy-tripdata.csv')
oct_2020 <- read.csv('/Users/boluogunle/Downloads/202010-divvy-tripdata.csv')
nov_2020 <- read.csv('/Users/boluogunle/Downloads/202011-divvy-tripdata.csv')
dec_2020 <- read.csv('/Users/boluogunle/Downloads/202012-divvy-tripdata.csv')
jan_2021 <- read.csv('/Users/boluogunle/Downloads/202101-divvy-tripdata.csv')
feb_2021 <- read.csv('/Users/boluogunle/Downloads/202102-divvy-tripdata.csv')
mar_2021 <- read.csv('/Users/boluogunle/Downloads/202103-divvy-tripdata.csv')

# Compare column names of the files
colnames(apr_2020)
colnames(mar_2021)

# Inspect the data frames and look for inconsistencies
str(apr_2020)
str(may_2020)
str(jun_2020)
str(jul_2020)
str(aug_2020)
str(sep_2020)
str(oct_2020)
str(nov_2020)
str(dec_2020)
str(jan_2021)
str(feb_2021)
str(mar_2021)


# Convert start_station_id and end_station_id from April 2020 to November 2020 to character so that they can stack correctly
apr_2020 <- mutate(apr_2020, start_station_id = as.character(start_station_id), 
                   end_station_id = as.character(end_station_id))
may_2020 <- mutate(may_2020, start_station_id = as.character(start_station_id), 
                   end_station_id = as.character(end_station_id))
jun_2020 <- mutate(jun_2020, start_station_id = as.character(start_station_id), 
                   end_station_id = as.character(end_station_id))
jul_2020 <- mutate(jul_2020, start_station_id = as.character(start_station_id), 
                   end_station_id = as.character(end_station_id))
aug_2020 <- mutate(aug_2020, start_station_id = as.character(start_station_id), 
                   end_station_id = as.character(end_station_id))
sep_2020 <- mutate(sep_2020, start_station_id = as.character(start_station_id), 
                   end_station_id = as.character(end_station_id))
oct_2020 <- mutate(oct_2020, start_station_id = as.character(start_station_id), 
                   end_station_id = as.character(end_station_id))
nov_2020 <- mutate(nov_2020, start_station_id = as.character(start_station_id), 
                   end_station_id = as.character(end_station_id))

# Stack 12 individual data frames into one big data frame
all_trips <- bind_rows( apr_2020, may_2020, jun_2020, jul_2020, aug_2020, sep_2020, 
                       oct_2020, nov_2020, dec_2020, jan_2021, feb_2021,
                       mar_2021)

# Clean up and Add Date to Prepare for Analysis on Rides and Riders
# Remove all latitude and longitude
all_trips <- all_trips %>% 
  select(-c(start_lat, start_lng, end_lat, end_lng))

all_trips <- all_trips %>% 
  select(-c(time_obj, time_obj2, startedtime))



# Inspect the new table created
colnames(all_trips) # list of column names
nrow(all_trips) # how many roaws are in the data frame
dim(all_trips) # dimensions of the data frame
head(all_trips) # see the first 6 rows
str(all_trips) # see list of columns and data types
summary(all_trips) # statistical summary of the data (mainly for numeric data)

# How many observations fall under each rider type?
table(all_trips$member_casual)


# Add columns that list the date, month, day, and year of each ride
all_trips$date <- as.Date(all_trips$started_at)
all_trips$month <- format(as.Date(all_trips$date), "%B")
all_trips$day <- format(as.Date(all_trips$date), "%d")
all_trips$year <- format(as.Date(all_trips$date), "%Y")
all_trips$day_of_week <- format(as.Date(all_trips$date), "%a")

all_trips$time_obj <- strptime(all_trips$started_at, format = "%Y-%m-%d %H:%M:%OS", tz = "EST")

all_trips$time_obj2 <- strptime(all_trips$ended_at, format = "%Y-%m-%d %H:%M:%OS", tz = "EST")

?difftime
# Calculate the "ride_length" and add a new column
all_trips$ride_length <- difftime(all_trips$time_obj2, all_trips$time_obj, units = "mins")

# Inspect the structure of the columns again
str(all_trips)

all_trips <- all_trips %>% 
  select(-c(time_obj, time_obj2))

# Convert "ride_length" from 'difftime' to numeric for further calculations
is.factor(all_trips$ride_length)
all_trips$ride_length <- as.numeric(as.character(all_trips$ride_length))
is.numeric(all_trips$ride_length)

# Remove trips that the ride length is <= 0 or more than one day (24 * 60 = 1440 minutes)
all_trips_v2 <- all_trips[!(all_trips$ride_length > 1440 | all_trips$ride_length <= 0),]
str(all_trips_v2)


# Combine start and end stations)
# Removing entries with no station name
# Separate the data frame by rider type
all_stations <- bind_rows(data.frame("stations" = all_trips_v2$start_station_name, 
                                     "member_casual" = all_trips_v2$member_casual),
                          data.frame("stations" = all_trips_v2$end_station_name,
                                     "member_casual" = all_trips_v2$member_casual))

# Remove stations that are empty / contains NA values
# new data frame for analysing station usage
all_stations_v2 <- all_stations[!(all_stations$stations == "" | is.na(all_stations$stations)),]
all_stations_member <- all_stations_v2[all_stations_v2$member_casual == 'member',]
all_stations_casual <- all_stations_v2[all_stations_v2$member_casual == 'casual',]

is.na(all_trips_v2)

# Get the top 10 popular stations all, members, and casual riders
top_10_station <- all_stations_v2 %>% 
  group_by(stations) %>% 
  summarise(station_count = n()) %>% 
  arrange(desc(station_count)) %>% 
  slice(1:10)

?summarise

# Get the top 10 popular stations all, members, and casual riders
top_10_station <- all_stations_v2 %>% 
  group_by(stations) %>% 
  summarise(station_count = n()) %>% 
  arrange(desc(station_count)) %>% 
  slice(1:10)

top_10_station_member <- all_stations_member %>% 
  group_by(stations) %>% 
  summarise(station_count = n()) %>% 
  arrange(desc(station_count)) %>% 
  head(n=10)

top_10_station_casual <- all_stations_casual %>% 
  group_by(stations) %>% 
  summarise(station_count = n()) %>% 
  arrange(desc(station_count)) %>% 
  head(n=10)

# Top 20 start stations for casual riders
all_trips_v2 %>% 
  group_by(start_station_name, member_casual) %>% 
  summarize(number_of_rides = n(), .groups = 'drop') %>% 
  filter(start_station_name != "", member_casual != "member") %>% 
  arrange(-number_of_rides) %>% 
  head(n=20)


# Analysis on Ride Length
summary(all_trips_v2$ride_length)


all_trips_v2 %>% 
  summarise(min_ride_length = min(ride_length), 
            max_ride_length = max(ride_length),
            median_ride_length = median(ride_length),
            mean_ride_length = mean(ride_length))

# Compare ride length between members and casual riders
aggregate(all_trips_v2$ride_length ~ all_trips_v2$member_casual, FUN = mean)
aggregate(all_trips_v2$ride_length ~ all_trips_v2$member_casual, FUN = median)
aggregate(all_trips_v2$ride_length ~ all_trips_v2$member_casual, FUN = max)
aggregate(all_trips_v2$ride_length ~ all_trips_v2$member_casual, FUN = min)


# See the average ride length by each day of week for members vs. casual riders
aggregate(all_trips_v2$ride_length ~ all_trips_v2$member_casual + all_trips_v2$day_of_week, FUN = mean)

# Put days of the week in order
all_trips_v2$day_of_week <- ordered(all_trips_v2$day_of_week, 
                                    levels = c("Mon", 
                                               "Tue", "Wed",
                                               "Thu", "Fri", "Sat", "Sun"))


# See the average ride length by each day of week for members vs. casual riders
aggregate(all_trips_v2$ride_length ~ all_trips_v2$member_casual + all_trips_v2$day_of_week, FUN = mean)


# Median ride length between members and casual riders for each day of week
aggregate(all_trips_v2$ride_length ~ all_trips_v2$member_casual + all_trips_v2$day_of_week, FUN = median)


# Number of rides between members and casual riders for each day of week
all_trips_v2 %>% 
  group_by(member_casual, day_of_week) %>% 
  summarise(number_of_rides = n()) %>% 
  arrange(day_of_week)

# Put months in order
all_trips_v2$month <- ordered(all_trips_v2$month, 
                              levels = c("January", "February", "March",
                                         "April", "May", "June",
                                         "July", "August", "September",
                                         "Octobor", "November", "December"))

# See the average ride length by month for members vs. casual riders
aggregate(all_trips_v2$ride_length ~ all_trips_v2$member_casual + all_trips_v2$month, FUN = mean)


# Comparing general bike type preference between members and casual riders
all_trips_v2 %>% 
  group_by(rideable_type, member_casual) %>% 
  summarize(number_of_rides = n())


# Comparing number of docked_bike rides between members and casual riders for each day of week
all_trips_v2 %>% 
  filter(rideable_type == 'docked_bike') %>% 
  group_by(member_casual, day_of_week) %>% 
  summarise(number_of_rides = n()) %>% 
  arrange(day_of_week)

all_trips_v2 %>% 
  filter(rideable_type == 'docked_bike', member_casual == 'casual') %>% 
  group_by(day_of_week) %>% 
  summarise(number_of_rides = n(), .groups = 'drop')


my_theme = theme(plot.title=element_text(size=20),
                 axis.text.x=element_text(size=16), 
                 axis.text.y=element_text(size=16),
                 axis.title.x=element_text(size=18), 
                 axis.title.y=element_text(size=18),
                 strip.text.x=element_text(size=16), 
                 strip.text.y=element_text(size=16),
                 legend.title=element_text(size=18), 
                 legend.text=element_text(size=16))


options(repr.plot.width = 6, repr.plot.height = 8)


all_trips_v2 %>% 
  group_by(member_casual) %>% 
  summarize(average_duration = mean(ride_length)) %>% 
  ggplot(aes(x = member_casual, y = average_duration)) +
  geom_col(position = "dodge") +
  labs(x = "Rider Type", y = "Average Duration (min)", 
       title = "Average Riding Duration by Rider Type") + my_theme


# Average riding duration of each day of week between members and casual riders
options(repr.plot.width = 10, repr.plot.height = 8)


all_trips_v2 %>% 
  group_by(member_casual, day_of_week) %>% 
  summarise(average_duration = mean(ride_length), .groups = 'drop') %>% 
  #arrange(member_casual, day_of_week) %>% 
  ggplot(aes(x = day_of_week, y = average_duration, fill = member_casual)) +
  geom_col(position = "dodge") +
  labs(x = "Day of Week", y = "Average Duration (min)", 
       fill = "Member/Casual",
       title = "Average Riding Duration by Day: Members vs. Casual Riders") + my_theme

# average number of rides of each day of week between members and casual riders
all_trips_v2 %>% 
  group_by(member_casual, day_of_week) %>% 
  summarise(number_of_rides = n(), .groups = 'drop') %>% 
  #arrange(member_casual, day_of_week) %>% 
  ggplot(aes(x = day_of_week, y = number_of_rides, fill = member_casual)) +
  geom_col(position = "dodge") + scale_y_continuous(labels = scales::comma) +
  labs(x = "Day of Week", y = "Number of Rides", 
       fill = "Member/Casual",
       title = "Average Number of Rides by Day: Members vs. Casual Riders") + my_theme

# average number of rides by month (casual riders)
options(repr.plot.width = 10, repr.plot.height = 8)
all_trips_v2 %>% 
  group_by(month, member_casual) %>% 
  summarize(number_of_rides = n(), .groups = 'drop') %>% 
  filter(member_casual == 'casual') %>%
  drop_na() %>%
  ggplot(aes(x = month, y = number_of_rides, fill = member_casual)) + 
  geom_bar(position = 'dodge', stat = 'identity') + scale_y_continuous(labels = scales::comma) + #If you want the heights of the bars to represent values in the data, use stat="identity"
  theme(axis.text.x = element_text(angle = 45)) + 
  labs(x = "Month", y = "Number of Rides", 
       fill = "Member/Casual",
       title = "Average Number of Rides by Month: Casual Riders") + my_theme

# average number of rides per hour(casual riders)
str(all_trips_v2)
all_trips_v2$started_at_hour <- as.POSIXct(all_trips_v2$started_at, "%Y-%m-%d %H:%M:%S")      
str(all_trips_v2)

options(repr.plot.width = 12, repr.plot.height = 8)

?round.Date

all_trips_v2 %>%
  filter(member_casual == 'casual') %>%
  group_by(hour_of_day = hour(round_date(started_at_hour, 'hour'))) %>% 
  group_by(hour_of_day, member_casual) %>% 
  summarize(number_of_rides = n(), .groups = 'drop') %>% 
  arrange(-number_of_rides) %>% 
  ggplot(aes(x = hour_of_day, y = number_of_rides, fill = member_casual)) +
  geom_bar(position = 'dodge', stat = 'identity') + scale_y_continuous(labels = scales::comma) +
  scale_x_continuous(breaks = c(0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23)) +
  labs(x = "Time of the Day (h)", y = "Number of Rides", 
       fill = "Member/Casual",
       title = "Average Number of Rides by Hour: Casual Riders") + my_theme

# Top 10 stations (members)
options(repr.plot.width = 10, repr.plot.height = 6)

ggplot(data = top_10_station_member) +
  geom_col(aes(x = reorder(stations, station_count), y = station_count), fill = "thistle") +
  labs(title = "Top 10 Used Stations by Members", y = "Number of Rides", x = "") +
  scale_y_continuous(labels = scales::comma) +
  coord_flip() +
  theme_minimal() + my_theme

# top 10 station (casual riders)
ggplot(data = top_10_station_casual) +
  geom_col(aes(x = reorder(stations, station_count), y = station_count), fill = "lightsalmon") +
  labs(title = "Top 10 Used Stations by Casual Riders", x = "", y = "Number of Rides") + 
  scale_y_continuous(labels = scales::comma) +
  coord_flip() +
  theme_minimal() + my_theme



# top 10 start stations (casual riders)
options(repr.plot.width = 10, repr.plot.height = 6)

all_trips_v2 %>% 
  group_by(start_station_name, member_casual) %>% 
  summarize(number_of_rides = n(), .groups = 'drop') %>% 
  filter(start_station_name != "", member_casual != "member") %>% 
  arrange(-number_of_rides) %>% 
  head(n=10) %>%
  ggplot(aes(x = reorder(start_station_name, number_of_rides), y = number_of_rides)) +
  geom_col(position = 'dodge', fill = '#f8766d') +
  scale_y_continuous(labels = scales::comma) +
  labs(title = 'Top 10 Start Stations for Casual Riders', x = '', y = "Number of Rides") +
  coord_flip() +
  theme_minimal() +
  my_theme

# usage od different bikes by rider type
options(repr.plot.width = 12, repr.plot.height = 8)

all_trips_v2 %>% 
  group_by(rideable_type, member_casual) %>% 
  summarize(number_of_rides = n(), .groups = 'drop') %>% 
  drop_na() %>% 
  ggplot(aes(x = member_casual, y = number_of_rides, fill = member_casual)) +
  geom_col(position = "dodge") +
  scale_y_continuous(labels = scales::comma) +
  facet_wrap(~rideable_type) +
  labs(fill = "Member/Casual", x = "", y = "Number of Rides", 
       title = "Usage of Different Bikes: Members vs. Casual Riders") + my_theme

# usage of different bikes by rider type (separated)
options(repr.plot.width = 14, repr.plot.height = 10)

all_trips_v2 %>% 
  group_by(month, member_casual, rideable_type) %>% 
  summarize(number_of_rides = n(), .groups = 'drop') %>% 
  drop_na() %>% 
  ggplot(aes(x = month, y = number_of_rides, fill = member_casual)) +
  geom_col(position = "dodge") +
  scale_y_continuous(labels = scales::comma) +
  facet_grid(member_casual~rideable_type) +
  labs(x = "Month", y = "Number of Rides", fill = "Member/Casual",
       title = "Average Number of Rides by Month") +
  theme(axis.text.x = element_text(angle = 90)) + my_theme

# number of rides between members and casual riders by day of week across the year
options(repr.plot.width = 26, repr.plot.height = 10)

all_trips_v2 %>% 
  group_by(month, day_of_week, member_casual) %>% 
  summarize(number_of_rides = n(), .groups = 'drop') %>% 
  drop_na() %>% 
  ggplot(aes(x = day_of_week, y = number_of_rides, fill = member_casual)) +
  geom_col(position = "dodge") +
  scale_y_continuous(labels = scales::comma) +
  facet_grid(member_casual~month) +
  labs(x = "Day of Week", y = "Number of Rides", fill = "Member/Casual",
       title = "Bike Usage between Members and Casual Riders by Day of Week across the Year", fill = 'Member/Casual') +
  theme(axis.text.x = element_text(angle = 90)) +
  my_theme

# Key Findings

# On average, casual riders ride more than one time longer than members, and they ride oven longer on weekends.

# On summer weekends, casual riders' demand on bikes are larger than members.

# During the day, averagely, 3 PM to 7 PM is the peak time when number of rides of casual riders are greater than 125K.

# Similar to members, casual riders used docked bikes most frequently. The classic bike is the least popular bike type.

# Top three start stations for casual riders are 1) Streeter Dr & Grand Ave, 2) Lake Shore Dr & Monroe St, and 3) Millennium Park


# Act

# Three Recommendations

# Form partnerships with local businesses around (within 1km from) top 20 used stations for casual riders (especially top 10 used start stations) to carry out marketing campaigns on digital media, targeting 1) local casual riders, 2) frequent visitors (commuters) to the businesses and stores around, 3) and or those who have similar social persona to Cyclistic members.

# Offer occasional membership discount to new riders on summer and holiday weekends

# Develop longer term marketing campaigns and digital media marketing message that focuses on communicating the benefits (price, discount, convenience) of riding with Cyclistic on trips longer than 20 minutes.