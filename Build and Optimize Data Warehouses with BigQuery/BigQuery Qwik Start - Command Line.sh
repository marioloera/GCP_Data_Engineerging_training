# BigQuery: Qwik Start - Command Line
# GSP071

# Task 1. Examine a table
# To examine the schema of the Shakespeare table in the samples dataset, run:
# NOTE: for bq commands, the format is project:dataset.table
BQ_TABLE_CMD=bigquery-public-data:samples.shakespeare
echo $BQ_TABLE_CMD
bq show $BQ_TABLE_CMD

# Task 2. Run the help command
bq help query

# Task 3. Run a query
# NOTE: for queries, the format is `project.dataset.table`

BQ_TABLE_SQL=\`bigquery-public-data.samples.shakespeare\`
echo $BQ_TABLE_SQL

SQL_QUERY="
    SELECT
        word,
        SUM(word_count) AS count
    FROM ${BQ_TABLE_SQL}
    WHERE word LIKE '"%raisin%"'
    GROUP BY word
"
echo $SQL_QUERY


bq query --use_legacy_sql=false $SQL_QUERY

SQL_QUERY="
    SELECT word
    FROM ${BQ_TABLE_SQL}
    WHERE word = 'huzzah'
 "
bq query --use_legacy_sql=false $SQL_QUERY


# Task 4. Create a new table
# Use the bq ls command to list any existing datasets in your projec
bq ls
bq ls bigquery-public-data:

# Use the bq mk command to create a new dataset named babynames in your Qwiklabs project
datasetID=babynames
bq mk $datasetID


# Run this command to add the baby names zip file to your project, using the URL for the data file:
curl -LO http://www.ssa.gov/OACT/babynames/names.zip
unzip names.zip


# The bq load command creates or updates a table and loads data in a single step
:`
    datasetID: babynames
    tableID: names2010
    source: yob2010.txt
    schema: name:string,gender:string,count:integer
`

# Create your table:
datasetID=babynames
tableID=names2010
source=yob2010.txt
schema=name:string,gender:string,count:integer
bq load $datasetID.$tableID $source $schema


bq show $datasetID.$tableID


# Task 5. Run queries
# NOTE: BE CAREFUL WITH COMMENTS, CHECK THE OUTPUT
# top 5 most popular girls names
SQL_QUERY="
    SELECT name,count 
    FROM $datasetID.$tableID
    WHERE gender = 'F' 
    ORDER BY count DESC 
    LIMIT 5
 "
bq query $SQL_QUERY

# top 5 most unusual boys names
SQL_QUERY="
    SELECT name,count 
    FROM $datasetID.$tableID
    WHERE gender = 'M' 
    ORDER BY count ASC 
    LIMIT 5
"
echo $SQL_QUERY
bq query $SQL_QUERY


# Task 7. Clean up, Confirm the delete command by typing Y.
bq rm -r $datasetID
