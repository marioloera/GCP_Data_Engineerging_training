# Dataflow: Qwik Start - Templates
# GSP192
BigQueryDataset=taxirides
BigQueryTable=realtime2

export PROJECT_ID=$(gcloud config get-value core/project)
echo $PROJECT_ID

export GCSBucket="${PROJECT_ID}_${BigQueryDataset}"
echo $GCSBucket

BigQueryTableLong=$BigQueryDataset.$BigQueryTable
# Ensure that the Dataflow API is successfully enabled


# Task 1. Create a Cloud BigQuery dataset 
bq mk $BigQueryDataset

# Create BigQuery Table
bq mk \
--time_partitioning_field timestamp \
--schema ride_id:string,point_idx:integer,latitude:float,longitude:float,\
timestamp:timestamp,meter_reading:float,meter_increment:float,ride_status:string,\
passenger_count:integer -t $BigQueryTableLong

# Create a storage bucket
gsutil mb gs://$GCSBucket/


# Task 3. Run the pipeline


: '



From the Navigation menu, find the Analytics section and click on Dataflow.

Click on + Create job from template at the top of the screen.

Enter <JOB_NAME> as the Job name for your Cloud Dataflow job

select <LOCATION> for Regional Endpoint.

Under Dataflow Template, select the 
    Pub/Sub Topic to BigQuery template.

Under Input Pub/Sub topic, click Enter Topic Manually and enter:
    projects/pubsub-public-data/topics/taxirides-realtime

Under BigQuery output table, enter the name of the table that was created:
    <myprojectid>:taxirides.realtime

Add your bucket as Temporary Location:
    gs://Your_Bucket_Name/temp
Copied!
Click the Run job button.
'   