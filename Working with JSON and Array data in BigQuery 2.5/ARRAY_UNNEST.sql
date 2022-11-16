#standardSQL
SELECT
['raspberry', 'blackberry', 'strawberry', 'cherry'] AS fruit_array

#standardSQL
SELECT person, fruit_array, total_cost
FROM `data-to-insights.advanced.fruit_store`;


-- create a dataset: fruit_store
-- create a tabel 'fruit_details' from GCS File: data-insights-course/labs/optimizing-for-performance/shopping_cart.json

SELECT
  fullVisitorId,
  date,
  v2ProductName,
  pageTitle
FROM `data-to-insights.ecommerce.all_sessions`
WHERE visitId = 1501570398
ORDER BY date;

-- ARRAY_AGG() function to aggregate our string values into an array. 
-- ARRAY_LENGTH() function to count the number of pages and products that were viewed:
-- Next, let's deduplicate the pages and products so we can see how many unique products were viewed. We'll simply add DISTINCT to our ARRAY_AGG():
SELECT
  fullVisitorId,
  date,
  ARRAY_AGG(v2ProductName) AS products_viewed,
  ARRAY_LENGTH(ARRAY_AGG(v2ProductName)) AS num_products_viewed,
  ARRAY_AGG(pageTitle) AS pages_viewed,
  ARRAY_LENGTH(ARRAY_AGG(pageTitle)) AS num_pages_viewed
  FROM `data-to-insights.ecommerce.all_sessions`
WHERE visitId = 1501570398
GROUP BY fullVisitorId, date
ORDER BY date;


-- Before we can query REPEATED fields (arrays) normally, you must first break the arrays back into rows.
-- For example, the array for hits.page.pageTitle is stored currently as a single row like:
-- Use the UNNEST() function on your array field:
For example, the array for hits.page.pageTitle is stored currently as a single row like:
SELECT DISTINCT
  visitId,
  h.page.pageTitle
FROM `bigquery-public-data.google_analytics_sample.ga_sessions_20170801`,
  UNNEST(hits) AS h
WHERE visitId = 1501570398
LIMIT 10


/* here is an incredible amount of website session data stored for a modern ecommerce website.
The main advantage of having 32 STRUCTs in a single table is it allows you to run queries 
like this one without having to do any JOINs:
*/
SELECT
  visitId,
  totals.*,
  device.*
FROM `bigquery-public-data.google_analytics_sample.ga_sessions_20170801`
WHERE visitId = 1501570398
LIMIT 10



#standardSQL
SELECT STRUCT("Rudisha" as name, 23.4 as split) as runner

#standardSQL
SELECT STRUCT("Rudisha" as name, [23.4, 26.3, 26.4, 26.1] as splits) AS runner


-- create a dataset: racing
-- create a tabel 'race_results' from GCS File: data-insights-course/labs/optimizing-for-performance/race_results.json
-- File format: JSONL (Newline delimited JSON)
-- In Schema, move the Edit as text slider and add the following:
[
    {
        "name": "race",
        "type": "STRING",
        "mode": "NULLABLE"
    },
    {
        "name": "participants",
        "type": "RECORD",
        "mode": "REPEATED",
        "fields": [
            {
                "name": "name",
                "type": "STRING",
                "mode": "NULLABLE"
            },
            {
                "name": "splits",
                "type": "FLOAT",
                "mode": "REPEATED"
            }
        ]
    }
]

#standardSQL
SELECT race, participants.name
FROM racing.race_results AS r
CROSS JOIN r.participants # full STRUCT name

-- Replacing the words "CROSS JOIN" with a comma (a comma implicitly cross joins)
#standardSQL
SELECT race, participants.name
FROM racing.race_results AS r, r.participants # full STRUCT name


-- Task: Write a query to COUNT how many racers were there in total.
SELECT COUNT(p.name) AS racer_count
FROM racing.race_results AS r,
  UNNEST(r.participants) AS p

/* Write a query that will list the total race time for racers whose names begin with R. 
Order the results with the fastest total time first. 
*/
SELECT p.name, SUM(split_times) AS TOTAL_TIME
FROM racing.race_results AS r
  , UNNEST(r.participants) AS p
  , UNNEST(p.splits) AS split_times
WHERE p.name like 'R%'
GROUP BY 1
ORDER BY 2

/*
  You happened to see that the fastest lap time recorded for the 800 M race was 23.2 seconds,
    but you did not see which runner ran that particular lap.
    Create a query that returns that result.
*/
SELECT p.name, split_time
FROM racing.race_results AS r
  , UNNEST(r.participants) AS p
  , UNNEST(p.splits) AS split_time
-- where split_time = 23.2
order by 2
limit 1
