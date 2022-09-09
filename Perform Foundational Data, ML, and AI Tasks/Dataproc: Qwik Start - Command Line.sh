# Dataproc: Qwik Start - Command Line
# GSP104

REGION=us-east1
CLUSTER_NAME=example-cluster
JOP_TYPE=spark
CLASS=org.apache.spark.examples.SparkPi
JARS=file:///usr/lib/spark/examples/jars/spark-examples.jar
JOB_ARGS=1000

# Task 1. Create a cluster
# set the Region
gcloud config set dataproc/region $REGION

# to create a cluster with default Cloud Dataproc settings
gcloud dataproc clusters create $CLUSTER_NAME --worker-boot-disk-size 500


# Task 2. Submit a job
:`
https://cloud.google.com/sdk/gcloud/reference/dataproc/jobs/submit/spark

gcloud dataproc jobs submit spark \
    --cluster example-cluster \
    --class org.apache.spark.examples.SparkPi \
    --jars file:///usr/lib/spark/examples/jars/spark-examples.jar 
    -- 1000
`
gcloud dataproc jobs submit $JOP_TYPE \
    --cluster $CLUSTER_NAME \
    --class $CLASS \
    --jars $JARS
    -- $JOB_ARGS


# Task 3. Update a cluster
gcloud dataproc clusters update $CLUSTER_NAME --num-workers 4
