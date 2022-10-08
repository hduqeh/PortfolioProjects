-- We want to create one unified dataset
-- Is our hotel revenue growing by year? We will use exploratory data analysis


WITH hotels as (
SELECT * 
FROM HotelProject.dbo.[2018]
union
SELECT * 
FROM HotelProject.dbo.[2019]
union
SELECT * 
FROM HotelProject.dbo.[2020]
)

SELECT *
FROM hotels


-- we need to create a new column by adding stays_in_weekendnights and stays_in_week_nights

WITH hotels as (
SELECT * 
FROM HotelProject.dbo.[2018]
union
SELECT * 
FROM HotelProject.dbo.[2019]
union
SELECT * 
FROM HotelProject.dbo.[2020]
)

SELECT (stays_in_week_nights+stays_in_week_nights)*adr AS revenue
FROM hotels



-- Now we want to see this increase by year so we will add another column 'adr' - arrival_date_year

WITH hotels as (
SELECT * 
FROM HotelProject.dbo.[2018]
union
SELECT * 
FROM HotelProject.dbo.[2019]
union
SELECT * 
FROM HotelProject.dbo.[2020]
)

SELECT 
arrival_date_year,
(stays_in_week_nights+stays_in_week_nights)*adr AS revenue
FROM hotels




-- We want to group by and sum up years

WITH hotels as (
SELECT * 
FROM HotelProject.dbo.[2018]
union
SELECT * 
FROM HotelProject.dbo.[2019]
union
SELECT * 
FROM HotelProject.dbo.[2020]
)


SELECT 
arrival_date_year,
sum((stays_in_week_nights+stays_in_week_nights)*adr) AS revenue
FROM hotels
GROUP BY arrival_date_year

-- Based on the results of our last query we can say our revenue is growing year over year


-- Now let's break down our query by hotel type, we will need to add the 'hotel' column

WITH hotels as (
SELECT * 
FROM HotelProject.dbo.[2018]
union
SELECT *
FROM HotelProject.dbo.[2019]
union
SELECT * 
FROM HotelProject.dbo.[2020]
)

SELECT 
arrival_date_year,
hotel,
round(sum((stays_in_week_nights+stays_in_week_nights)*adr), 2) AS revenue
FROM hotels
GROUP BY arrival_date_year, hotel




-- Now looking at market segment which is paired with a discount, applied depending on the booking type

WITH hotels as (
SELECT * 
FROM HotelProject.dbo.[2018]
union
SELECT * 
FROM HotelProject.dbo.[2019]
union
SELECT * 
FROM HotelProject.dbo.[2020]
)

SELECT 
arrival_date_year,
hotel,
round(sum((stays_in_week_nights+stays_in_week_nights)*adr), 2) AS revenue
FROM hotels
GROUP BY arrival_date_year, hotel

SELECT * 
FROM HotelProject.dbo.market_segment  -- We can see that market segment is also in our other tables '2018', '2019', '2020' so we can JOIN



-- Using a left join to combine market segment with tables 2018, 2019, and 2020

WITH hotels as (
SELECT * 
FROM HotelProject.dbo.[2018]
union
SELECT * 
FROM HotelProject.dbo.[2019]
union
SELECT * 
FROM HotelProject.dbo.[2020]
)

SELECT *
FROM hotels 
LEFT JOIN HotelProject.dbo.market_segment
ON hotels.market_segment = market_segment.market_segment
LEFT JOIN dbo.meal_cost
ON meal_cost.meal = hotels.meal

-- We will use this last query to create a dashboard in Power BI
