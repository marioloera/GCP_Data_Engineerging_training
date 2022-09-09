# Dataflow: Qwik Start - Python
# GSP207
GCSBucketSuffix=some_bucket
REGION=us-west1

export PROJECT_ID=$(gcloud config get-value core/project)
echo $PROJECT_ID

export GCSBucket="gs://${PROJECT_ID}_${GCSBucketSuffix}"
echo $GCSBucket

# Task 1. Create a Cloud Storage bucket, Multi-region in US location
gsutil mb -l US $GCSBucket

# Task 2. Install pip and the Cloud Dataflow SDK
# docker run -it -e DEVSHELL_PROJECT_ID=$DEVSHELL_PROJECT_ID python:3.7 /bin/bash


# try
docker run -it \
    --env PROJECT_ID=$PROJECT_ID \
    --env GCSBucket=$GCSBucket \
    python:3.7 /bin/bash


# , install the latest version of the Apache Beam 
pip install 'apache-beam[gcp]'


# Run the wordcount.py example locally by running the following command
python -m apache_beam.examples.wordcount --output OUTPUT_FILE


# Task 3. Run an example pipeline remotely
python -m apache_beam.examples.wordcount \
  --project $PROJECT_ID \
  --runner DataflowRunner \
  --staging_location $GCSBucket/staging \
  --temp_location $GCSBucket/temp \
  --output $GCSBucket/results/output \
  --region $REGION
