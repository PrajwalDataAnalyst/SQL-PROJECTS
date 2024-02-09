use prajwal;
show tables;
select * from bookings;
select * from bookinginfo;
select * from dim_date;
select * from dim_hotels;
select * from dim_rooms;

select count(distinct property_name) from dim_hotels;

-- 1 total property_name,city,category,room_class 
select  count(distinct property_name) Hotel ,count(distinct city) city,count(distinct category) category from dim_hotels; 
-- 2 top 
SELECT DISTINCT property_name AS Hotel, city, category
FROM dim_hotels;



-- 3 total revenu 
select FORMAT(sum(revenue_realized),0) as Total_revenue from bookinginfo;

-- 4 total revenue by each hotel and day type (weekday/weekend)
select h.property_name as Hotel ,d.day_type, h.category,format(sum(b.revenue_realized),0) as revenue 
 from dim_hotels as h inner join bookinginfo as b on b.property_id=h.property_id 
 inner join dim_date as d on b.check_in_date=d.date 
 group by property_name,category,day_type
 order by property_name;

-- 5  number of booking_platform 
SELECT
    ROW_NUMBER() OVER (ORDER BY booking_platform) AS SI_NO,
    booking_platform
FROM
    (SELECT DISTINCT booking_platform FROM bookinginfo) AS distinct_booking_platforms;

UPDATE dim_hotels SET property_name = 'Atliq city' WHERE property_name = 'Hotel Naveen';

select * from dim_hotels;


-- 6 how much genetreating by city by hotels
SELECT
    dh.property_name,
    dh.city,
    FORMAT(SUM(bi.revenue_realized), 0) AS total_revenue_realized
FROM
    dim_hotels dh
INNER JOIN
    bookinginfo bi ON dh.property_id = bi.property_id
GROUP BY
    dh.property_name,
    dh.city
ORDER BY
    dh.city;
    
-----  7 how much genetreating by booking_platform by hotels

SELECT
    distinct booking_platform,
    ratings_given,h.city,
    FORMAT(SUM(revenue_realized), 0) AS Revenue
FROM
    bookinginfo inner join dim_hotels as h on bookinginfo.property_id = h.property_id
GROUP BY
    booking_platform, ratings_given,city;


-- 8  profit by date

SELECT 
    booking_date,
    FORMAT(SUM(revenue_realized), 0) AS total_realized_revenue
FROM 
    bookinginfo
WHERE 
    revenue_generated <> revenue_realized
GROUP BY 
    booking_date;
-- 9 no_guests
select  count(distinct check_in_date) as Days,format(count(no_guests),0) as Guests from bookinginfo;
select count(distinct check_in_date) from bookinginfo;

-- 9 
create view Bangalore as
SELECT *
FROM bookinginfo
WHERE property_id = ANY (SELECT property_id FROM dim_hotels WHERE city = 'Bangalore');
select * from Bangalore;

select * from Bangalore ;

create view Delhi as
SELECT *
FROM bookinginfo
WHERE property_id = ANY (SELECT property_id FROM dim_hotels WHERE city = 'Delhi');
select * from Delhi;

create view Hyderabad as
SELECT *
FROM bookinginfo
WHERE property_id = ANY (SELECT property_id FROM dim_hotels WHERE city = 'Hyderabad');
select * from Hyderabad;

create view Mumbai as
SELECT *
FROM bookinginfo
WHERE property_id = ANY (SELECT property_id FROM dim_hotels WHERE city = 'Mumbai');
select * from Mumbai;

-- 10 others,tripster,makeyourtrip
delimiter //
create procedure details_on_Booking_Platform( in BP varchar(30))
begin
select h.property_name,h.category,h.city,b.check_in_date,
b.room_category,b.successful_bookings,b.capacity ,
bb.booking_date,bb.check_in_date,bb.checkout_date,bb.no_guests,bb.room_category,bb.booking_platform,bb.ratings_given,
bb.booking_status,bb.revenue_generated,bb.revenue_realized
from dim_hotels as h inner join bookings as b on h.property_id=b.property_id
 inner join bookinginfo as bb on h.property_id=bb.property_id where bb.booking_platform = BP;
 end; //
 
 call details_on_Booking_Platform('tripster'); # Bookmyroom.com,makeyourtrip,

/* 11 updateing date */ 
delimiter //  
create procedure updatedate(in newname varchar(30),in oldname varchar(30))
begin
update dim_hotels set property_name =newname where property_name =oldname;
end;//

call update_hotels("red lion","Atliq Grands");

/* 12 */
delimiter //
create trigger cheakcapacity
before insert on  bookings
for each row
begin
if new.capacity <=0 and new.capacity >30 then set new.capacity=30;
end if;
end//


select * from bookings where property_id=101 ;
INSERT INTO bookings (property_id, check_in_date, room_category, successful_bookings, capacity)
VALUES (101, '2022-01-05', 'RT1', 25, -30);

/* 13 */
delimiter // 
create procedure find_my_loc(in find varchar(50))
begin
select property_name,category,city from dim_hotels where 
property_id=(select property_id from bookinginfo where booking_id = find);
end; //

call find_my_loc("May012216558RT21");

/* finding hotels by rating and city */
delimiter //
create procedure find_hotel(in rating int,in city1 varchar(20))
begin
select h.property_name,h.city,b.ratings_given,b.room_category,b.revenue_generated
from dim_hotels as h inner join bookinginfo as b on h.property_id =b.property_id
 where ratings_given= rating and city =city1;
end; //


call find_hotel(0,"Bangalore");
UPDATE bookinginfo
SET ratings_given = 0
WHERE ratings_given IS NULL OR ratings_given = '';

select * from bookinginfo;

select count(booking_id) from bookinginfo where booking_platform ="Bookmyroom.com" and booking_date between "01-05-2022" and "31-12-2022";
desc bookinginfo;

select c.city ,sum(r.revenue_realized) as total_revenu from dim_hotels as c inner join bookinginfo as r on r.property_id=c.property_id group by city;
select count(property_id) from bookings;