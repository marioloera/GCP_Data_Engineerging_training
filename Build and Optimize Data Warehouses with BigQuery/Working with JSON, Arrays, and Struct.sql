-- Working with JSON, Arrays, and Structs in BigQuery
-- GSP416

SELECT ['raspberry', 'blackberry', 'strawberry', 'cherry'] AS fruit_array

-- error
SELECT ['raspberry', 'blackberry', 'strawberry', 'cherry', 1234567] AS fruit_array


SELECT person, fruit_array, total_cost 
FROM `data-to-insights.advanced.fruit_store`;

-- json results
[
    {
        "person": ["sally"],
        "fruit_array": ["raspberry", "blackberry", "strawberry", "cherry"],
        "total_cost": ["10.99"]
    }, 
    {
        "person": ["frederick"],
        "fruit_array": ["orange", "apple"],
        "total_cost": ["5.55"]
    }
]


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
ORDER BY date

-- deduplicate with distinct
SELECT
  fullVisitorId,
  date,
  ARRAY_AGG(DISTINCT v2ProductName) AS products_viewed,
  ARRAY_LENGTH(ARRAY_AGG(DISTINCT v2ProductName)) AS distinct_products_viewed,
  ARRAY_AGG(DISTINCT pageTitle) AS pages_viewed,
  ARRAY_LENGTH(ARRAY_AGG(DISTINCT pageTitle)) AS distinct_pages_viewed
  FROM `data-to-insights.ecommerce.all_sessions`
WHERE visitId = 1501570398
GROUP BY fullVisitorId, date
ORDER BY date

/* Recap :You can do some pretty useful things with arrays like:

    finding the number of elements with ARRAY_LENGTH(<array>)

    deduplicating elements with ARRAY_AGG(DISTINCT <field>)

    ordering elements with ARRAY_AGG(<field> ORDER BY <field>)

    limiting ARRAY_AGG(<field> LIMIT 5)
*/


/* Task 4. Querying datasets that already have arrays

    You need to UNNEST() arrays to bring the array elements back into rows
    UNNEST() always follows the table name in your FROM clause
    (think of it conceptually like a pre-joined table)
*/
SELECT DISTINCT
  visitId,
  h.page.pageTitle
FROM `bigquery-public-data.google_analytics_sample.ga_sessions_20170801`,
    UNNEST(hits) AS h
WHERE visitId = 1501570398
LIMIT 10


/* Task 5. Introduction to STRUCTs

    A STRUCT can have:
        - One or many fields in it
        - The same or different data types for each field
        - It's own alias

    The .* syntax tells BigQuery to return all fields for that STRUCT 
    (much like it would if totals.* was a separate table we joined against).

    Storing your large reporting tables as STRUCTs (pre-joined "tables")
        and ARRAYs (deep granularity) allows you to:

        - Gain significant performance advantages by avoiding 32 table JOINs
        - Get granular data from ARRAYs when you need it but not be punished if you don't 
            (BigQuery stores each column individually on disk)
        - Have all the business context in one table as opposed to worrying about JOIN keys 
            and which tables have the data you need
*/

SELECT
  visitId,
  totals.*,
  device.*
FROM `bigquery-public-data.google_analytics_sample.ga_sessions_20170801`
WHERE visitId = 1501570398
LIMIT 10


/* Task 6. Practice with STRUCTs and arrays

    Structs are containers that can have multiple field names and data types nested inside.
    Arrays can be one of the field types inside of a Struct (as shown above with the splits field).

*/

SELECT STRUCT("Rudisha" as name, 23.4 as split) as runner

SELECT STRUCT("Rudisha" as name, [23.4, 26.3, 26.4, 26.1] as splits) AS runner


/* Practice ingesting JSON data

    Create a new dataset titled racing.


    Select file from Cloud Storage bucket:
        data-insights-course/labs/optimizing-for-performance/race_results.json

    File format: JSONL (Newline delimited JSON)

    TableId: race_results

    In Schema, click on Edit as text slider and add the following:


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


*/

SELECT race, participants.name
FROM racing.race_results
CROSS JOIN  race_results.participants # full STRUCT name
/*
This is a correlated cross join which only unpacks the elements associated with a single row. 
*/


-- Replacing the words "CROSS JOIN" with a comma (a comma implicitly cross joins)
SELECT race, participants.name
FROM racing.race_results AS r, r.participants

SELECT COUNT(p.name) AS racer_count
FROM racing.race_results AS r, UNNEST(r.participants) AS p

/* Recap of STRUCTs:

    A SQL STRUCT is simply a container of other data fields which can be of different data types.
    The word struct means data structure. 
    Recall the example from earlier: STRUCT(``"Rudisha" as name, [23.4, 26.3, 26.4, 26.1] as splits``)`` AS runner

    STRUCTs are given an alias (like runner above)
    and can conceptually be thought of as a table inside of your main table.

    STRUCTs (and ARRAYs) must be unpacked before you can operate over their elements.
    Wrap an UNNEST() around the name of the struct itself
    or the struct field that is an array in order to unpack and flatten it.

*/

/* Task 8. Lab question: Unpacking arrays with UNNEST( )
    - List the total race time for racers whose names begin with R
*/

SELECT
  p.name,
  SUM(split_times) as total_race_time
FROM racing.race_results AS r,
  UNNEST(r.participants) AS p,
  UNNEST(p.splits) AS split_times
WHERE p.name LIKE 'R%'
GROUP BY p.name
ORDER BY total_race_time ASC;

/* Task 9. Filtering within array values
    - the fastest lap time recorded for the 800 M race was 23.2 seconds,
        which runner ran that particular lap?
*/
SELECT
  p.name,
  min(split_times) as fastest_lap,
FROM racing.race_results AS r,
  UNNEST(r.participants) AS p,
  UNNEST(p.splits) AS split_times
GROUP BY p.name
ORDER BY 2 ASC
LIMIT 1;


SELECT
  p.name,
  split_time
FROM racing.race_results AS r,
  UNNEST(r.participants) AS p,
  UNNEST(p.splits) AS split_time
WHERE split_time = 23.2;
