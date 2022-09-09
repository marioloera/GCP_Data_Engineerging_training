# Task 1: Run a simple Dataflow job
# GSP323

BigQueryDataset=lab_594
GCSBucket=f5105072-627b-41ae-bc0e-e09ab6d39043
LOCATION=US

# Create a BigQuery dataset
bq mk  $BigQueryDataset

# Create a storage bucket
gsutil mb -l $LOCATION gs://$GCSBucket
