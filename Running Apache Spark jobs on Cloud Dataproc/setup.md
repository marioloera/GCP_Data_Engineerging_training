## get project id and make bucket
 ```
export CLUSTER_NAME=sparktodp
export PROJECT_ID=$(gcloud info --format='value(config.project)')
echo PROJECT_ID $PROJECT_ID
export BUCKET_NAME="gs://${PROJECT_ID}_dataproc"
echo BUCKET_NAME $BUCKET_NAME
gsutil mb $BUCKET_NAME
 ```



# Configure and start a Cloud Dataproc cluster
In the GCP Console, on the Navigation menu, in the Analytics section, click Dataproc.

Click Create Cluster.

Click Create for the item Cluster on Compute Engine.

Enter sparktodp for Cluster Name.

In the Versioning section, click Change and select 2.0 (Debian 10, Hadoop 3.2, Spark 3.1).

This version includes Python3, which is required for the sample code used in this lab.

Click Select.

In the Components > Component gateway section, select Enable component gateway.

Under Optional components, Select Jupyter Notebook.

Click Create.

The cluster should start in a few minutes. You can proceed to the next step without waiting for the Cloud Dataproc Cluster to fully deploy.

```
gcloud dataproc clusters create $CLUSTER_NAME \
    --enable-component-gateway \
    --image-version 2.0-debian10 \
    --region us-central1 \
    # --zone us-central1-a \
    # --master-machine-type n1-standard-4 \
    # --master-boot-disk-size 500 \
    # --num-workers 2 \
    # --worker-machine-type n1-standard-4 \
    # --worker-boot-disk-size 500 \
    # --project qwiklabs-gcp-02-7f34de96ecf4 \

```

 ## In the Cloud Shell copy the source data into the bucket:
```
wget https://archive.ics.uci.edu/ml/machine-learning-databases/kddcup99-mld/kddcup.data_10_percent.gz
gsutil cp kddcup.data_10_percent.gz $BUCKET_NAME
gsutil ls $BUCKET_NAME
```


## Make the script executable:

```
chmod +x submit_onejob.sh
```

## Launch the PySpark Analysis job:
```
./submit_onejob.sh $CLUSTER_NAME $BUCKET_NAME $PROJECT_ID
```


## delete dataproc cluster
```
gcloud dataproc clusters delete $CLUSTER_NAME --region=us-central1
```