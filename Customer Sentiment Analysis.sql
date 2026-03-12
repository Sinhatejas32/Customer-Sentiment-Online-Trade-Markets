## Are certain product categories predominantly purchased by a specific gender? ##
select gender, product_category, count(*) as no_of_purchasers
from customer_sentiment
group by product_category, gender
order by product_category, no_of_purchasers desc;

##  Which age group contributes the highest share of online purchases?  ##
Select age_group, count(*) as No_of_pur
from customer_sentiment
group by age_group
order by age_group, No_of_pur desc
Limit 2;


## Which platform receives the highest proportion of positive reviews and ratings? ##
SELECT platform, Count(*) as No_of_ratings
FROM customer_sentiment
where customer_rating = 5 and sentiment = "positive"
group by platform
order by platform , No_of_ratings desc
limit 10;


## What is the ratio of negative to positive sentiments across online shopping platforms? ##
WITH sentiment_count AS (
    SELECT
        SUM(CASE WHEN sentiment = 'negative' THEN 1 ELSE 0 END) AS negative_cnt,
        SUM(CASE WHEN sentiment = 'positive' THEN 1 ELSE 0 END) AS positive_cnt
    FROM customer_sentiment
)
SELECT 
    negative_cnt,
    positive_cnt,
    (negative_cnt * 100.0 / NULLIF(positive_cnt, 0)) AS ratio_percentage
FROM sentiment_count;


##Top 10 platform which records the highest number of customer orders?##
SELECT platform, count(*) as Orders
From customer_sentiment
group by platform
order by platform, Orders desc
Limit 10;


## Which platforms have active complaints? ##
Select platform, Count(*) as No_of_issues
From customer_sentiment
where issue_resolved = 'no'
group by platform
order by No_of_issues desc;


## Which platform has the longest average complaint resolution time?##
SELECT platform, avg_time
FROM (
    SELECT 
        platform,
        AVG(response_time_hours) AS avg_time,
        RANK() OVER (ORDER BY AVG(response_time_hours) DESC) AS rnk
    FROM customer_sentiment
    GROUP BY platform
) AS A
WHERE rnk = 1;



## Which product category shows the highest recent growth or customer interest?##
Select product_category, count(*) as Trending_cat
From customer_sentiment
Group By product_category
Order By product_category, Trending_cat desc;


## Which platform has the highest average customer rating? ##
select platform , avg(customer_rating) as highest_avg 
from customer_sentiment
group by platform
order by highest_avg desc,platform
limit 1;


## What is the ratio of resolved complaints to total complaints registered? ## 
With CTE as 
(SELECT sentiment,
	Sum( Case When issue_resolved = 'yes'
		 Then 1 Else 0 End ) as resolved_com,
	Sum( Case when complaint_registered = 'yes'
          Then 1 Else 0 end) as com_register
          From customer_sentiment
          Group by sentiment)
Select  resolved_com, com_register,
resolved_com * 100.0 / nullif(com_register,0) as ratio
From CTE
where sentiment = 'negative';