# create table users
create table users
(
user_id int,                                    
created_at	varchar(50),
company_id	int,
language varchar(30),
activated_at varchar(50),
state varchar(30)

)

# importing datsets into the table. the same method is used in other 2 tables for importing dataset.

show variables like 'secure_file_priv'
load data infile "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/email_events.csv"
into table email_events
fields terminated by ','
enclosed by '"'
lines terminated by '\n'
ignore 1 rows

# adding new column called  temp_created_at 
alter table users add column temp_created_at datetime

# query to set values of  temp_created_at  as  created_at column
update users set temp_created_at = str_to_date(created_at, "%d-%m-%Y %H:%i")

# delete  the column created_at
alter table users
drop column created_at

# change name of temp_created_at as  created_at
alter table users
change temp_created_at created_at datetime

# add new column called temp_activated_at
alter table users add temp_activated_at datetime

# query to set values of  temp_activated_at  as  activated_at column
update users set temp_activated_at = str_to_date(activated_at,"%d-%m-%Y %H:%i")

# delete  the column activated_at
alter table users 
drop column activated_at

# change name of emp_activated_at as  activated_at
alter table users change temp_activated_at activated_at datetime

# create table events

create table events
(
user_id	int,
occurred_at varchar(100),
event_type varchar(50),
event_name varchar(50),
location varchar(50),
device varchar(50),
user_type int

)

# create table email_events

create table email_events
(
user_id int,	
occurred_at varchar(100),
action varchar(50),
user_type int

)

# adding new column called  temp_occured_at
alter table email_events add column temp_occured_at datetime

# query to set values of  temp_occured_at as  created_at column
update email_events  set temp_occured_at  = str_to_date(occurred_at, "%d-%m-%Y %H:%i")

# delete  the column occured_at
alter table email_events
drop column occured_at

# change name of temp_occured_at as  occured_at
alter table email_events
change temp_occured_at occured_at datetime

# PROJECT INSIGHTS

# weekly user engagement.

select extract(week from occured_at) as "weeks",
count(DISTINCT user_id) as "number of users"
 from events 
 where  event_type='engagement'
 group by weeks
 select * from events
 
 # User Growth Analysis: Analyse the growth of users over time for a product

select date_format(created_at,"%Y - %M") as "year and month",
count(user_id) as "total number of users"
from users
group by date_format(created_at,"%Y - %M")
order by "year and month"
 
 # weekly retention analysis :calculate the weekly retention of users based on their sign-up cohort
 
 select extract(week from occured_at) as weeks,
 count(distinct user_id) as "number of users"
 from events
 where event_type='signup_flow' and event_name='complete_signup'
 group by weeks
 
 
 # Weekly Engagement Per Device : Measure the activeness of users on a weekly basis per device
 
 select extract(week from occured_at) as weeks,     # 491 rows
 count(distinct user_id) as "number of users",
 device from events
 where event_type='engagement'
 group by device,weeks
 order by weeks
 
 # Email Engagement Analysis  : Calculate the email engagement metrics
 
 select distinct action from email_events
 select
 (sum(case when action='email_open' then 1 else 0 end) / 
 sum(case when action='sent_weekly_digest' or action='sent_reengagement_email' then 1 else 0 end)) * 100 as "open rate",
 (sum(case when action='email_clickthrough' then 1 else 0 end) /
 sum(case when action='sent_weekly_digest' or action = 'sent_reengagement_email' then 1 else 0 end)) * 100 as "click through rate"
 from email_events


