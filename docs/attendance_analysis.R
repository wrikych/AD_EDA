library(readr)
library(tidyverse)
library(ggplot2)


## Attendance overall - mention that 2020 was online, and PA cancelled theirs altogether

schools <- read_csv('new_schools.csv')
students <- read_csv('new_students.csv')

selected_states <- c('California','Texas','Arizona','Pennsylvania')

schools <- schools %>% mutate(category = if_else(State %in% selected_states, State, 'Other'))
s_14 <- schools %>% filter(Year==2014) %>% group_by(category) %>% summarize(Year,attendance=n()) %>% distinct()
s_15 <- schools %>% filter(Year==2015) %>% group_by(category) %>% summarize(Year,attendance=n()) %>% distinct()
s_16 <- schools %>% filter(Year==2016) %>% group_by(category) %>% summarize(Year,attendance=n()) %>% distinct()
s_17 <- schools %>% filter(Year==2017) %>% group_by(category) %>% summarize(Year,attendance=n()) %>% distinct()
s_18 <- schools %>% filter(Year==2018) %>% group_by(category) %>% summarize(Year,attendance=n()) %>% distinct()
s_19 <- schools %>% filter(Year==2019) %>% group_by(category) %>% summarize(Year,attendance=n()) %>% distinct()
s_20 <- schools %>% filter(Year==2020) %>% group_by(category) %>% summarize(Year,attendance=n()) %>% distinct()
s_21 <- schools %>% filter(Year==2021) %>% group_by(category) %>% summarize(Year,attendance=n()) %>% distinct()
s_22 <- schools %>% filter(Year==2022) %>% group_by(category) %>% summarize(Year,attendance=n()) %>% distinct()

attendance_state_year <- rbind(s_15, s_17, s_19, s_20, s_22)

ggplot(attendance_state_year, aes(fill=category, y=attendance, x=as.factor(Year))) + 
  geom_bar(stat='identity')