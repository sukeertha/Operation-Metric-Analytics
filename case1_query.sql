# database creation
create database operation_analytics
use operation_analytics

# create table for case study 1
create table job_data
(ds date ,
 job_id int  ,
 actor_id int ,
 event varchar(30) ,
 language varchar(30) ,
 time_spent int,
 org char(1))
 
insert into job_data(ds,job_id,actor_id,event,language,time_spent,org)
values('2020-11-30',21,1001,'skip','English',15,'A'),('2020-11-30',22,1006,'transfer','Arabic',25,'B'),
('2020-11-29',23,1003,'decision','Persian',20,'C'),
('2020-11-28',23,1005,'transfer','Persian',22,'D'),
('2020-11-28',25,1002,'decision','Hindi',11,'B'),
('2020-11-27',11,1007,'decision','French',104,'D'),
('2020-11-26',23,1004,'skip','Persian',56,'A'),
('2020-11-25',20,1003,'transfer','Italian',45,'C')

# Write an SQL query to calculate the number of jobs reviewed per hour for each day in November 2020.

select ds ,
round((count(job_id) / (sum(time_spent) /3600)),2) as "job viewed per hour for each day"
from job_data
group by ds


# calculate the 7-day rolling average of throughput
 
select * from job_data
with daily_throughput as 
(
 select ds,
 count(job_id) / sum(time_spent) as daily_throughput
 from job_data
 group by ds
)
select ds, daily_throughput,
round(avg(daily_throughput)
over(order by ds rows between 6 preceding and current row ),4) as rolling_7_day_throughput
from daily_throughput
order by ds

 # the percentage share of each language 
 
select language,
count(language) as language_count,
round((count(language) * 100) / (select count(*) from job_data),2) as percentage
from job_data 
group by language
order by percentage desc

# display duplicate rows

select * from job_data where job_id in
(select job_id from job_data 
group by job_id 
having count(*) > 1)



 

