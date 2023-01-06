library(readr)
library(tidyverse)
library(ggplot2)
library(ggrepel)
library(ggthemes)

students <- read_csv('new_students.csv')

## Mean score grouped bar chart 

students %>% group_by(Division) %>% summarize(mean_score = mean(Score))
s_16 <- students %>% filter(Year=='2016') %>% group_by(Division) %>% 
  summarize(Year = Year, Mean_score = mean(Score)) %>%
  distinct()
s_18 <- students %>% filter(Year=='2018') %>% group_by(Division) %>% 
  summarize(Year = Year, Mean_score = mean(Score)) %>%
  distinct()
s_20 <- students %>% filter(Year=='2020') %>% group_by(Division) %>% 
  summarize(Year = Year, Mean_score = mean(Score)) %>%
  distinct()
s_22 <- students %>% filter(Year=='2022') %>% group_by(Division) %>% 
  summarize(Year = Year, Mean_score = mean(Score)) %>%
  distinct()
s_total1 <- rbind(s_16, s_18, s_20, s_22)
ggplot(s_total1, aes(fill=Division, y=Mean_score, x=as.factor(Year))) + 
  geom_bar(position='dodge', stat='identity') + 
  geom_line(y=s_total1$Mean_score, group=1)

## Looking at differences using example years 2018 (pre), 2022 (post)

## Separate Divisions 2022
honors_22 <- students %>% filter(Year=='2022') %>% filter(Division=='Honors')
scholastic_22 <- students %>% filter(Year=='2022') %>% filter(Division=='Scholastic')
varsity_22 <- students %>% filter(Year=='2022') %>% filter(Division=='Varsity')

## Creating table for high scoring students (scored above the mean each year)
## 22) H: 7960.7, S: 7300.5, V: 6932.3
h_upper_22 <- honors_22 %>% filter(Score > 7960.7)
s_upper_22 <- scholastic_22 %>% filter(Score > 7300.5)
v_upper_22 <- varsity_22 %>% filter(Score > 6932.3)

high_scorers_22 <- rbind(h_upper_22, s_upper_22, v_upper_22)

## Separate Divisions 2018
honors_18 <- students %>% filter(Year=='2018') %>% filter(Division=='Honors')
scholastic_18 <- students %>% filter(Year=='2018') %>% filter(Division=='Scholastic')
varsity_18 <- students %>% filter(Year=='2018') %>% filter(Division=='Varsity')

## High scorers 2018
## 18) H: 8073.9, S: 7541.1, V: 7255.235
h_upper_18 <- honors_18 %>% filter(Score > 8073.9)
s_upper_18 <- scholastic_18 %>% filter(Score > 7541.1)
v_upper_18 <- varsity_18 %>% filter(Score > 7255.235)

high_scorers_18 <- rbind(h_upper_18, s_upper_18, v_upper_18)

## Creating category variable for each
selected_states <- c('California','Texas','Arizona','Pennsylvania')
high_scorers_18 <- high_scorers_18 %>% mutate(Category = if_else(State %in% selected_states, State, 'Other'))
high_scorers_22 <- high_scorers_22 %>% mutate(Category = if_else(State %in% selected_states, State, 'Other'))

## 2018 pie chart
num_hs_18 <- high_scorers_18 %>% group_by(Category) %>% summarize(Count = n())
for_count_pie_18 <- num_hs_18 %>%  
  mutate(csum = rev(cumsum(rev(Count))), 
         pos = Count/2 + lead(csum, 1), 
         pos = if_else(is.na(pos), Count/2, pos))
ggplot(num_hs_18, aes(x="", y=Count, fill=Category)) + 
  geom_col(width = 1, color = 1) +  
  coord_polar(theta = "y", clip="on") +  
  scale_fill_brewer(palette = "Set1") +  
  labs(title="Users by frequency of use - Count (out of 24)") + 
  labs(x=" ") + 
  geom_label_repel(data=for_count_pie_18, aes(y=pos, label=paste0(Count)), 
                   size=4.5, nudge_x=1, show.legend=FALSE,alpha=0.85) +  
  guides(fill=guide_legend(title = "User Type")) +  
  theme_excel_new() ## generate chart


## 2022 pie chart
num_hs_22 <- high_scorers_22 %>% group_by(Category) %>% summarize(Count = n())
for_count_pie_22 <- num_hs_22 %>%  
  mutate(csum = rev(cumsum(rev(Count))), 
         pos = Count/2 + lead(csum, 1), 
         pos = if_else(is.na(pos), Count/2, pos))
ggplot(num_hs_22, aes(x="", y=Count, fill=Category)) + 
  geom_col(width = 1, color = 1) +  
  coord_polar(theta = "y", clip="on") +  
  scale_fill_brewer(palette = "Set1") +  
  labs(title="Users by frequency of use - Count (out of 24)") + 
  labs(x=" ") + 
  geom_label_repel(data=for_count_pie_22, aes(y=pos, label=paste0(Count)), 
                   size=4.5, nudge_x=1, show.legend=FALSE,alpha=0.85) +  
  guides(fill=guide_legend(title = "User Type")) +  
  theme_excel_new() ## generate chart