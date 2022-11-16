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

## get project id and make bucket
 ```
export PROJECT_ID=$(gcloud info --format='value(config.project)')
gsutil mb gs://$PROJECT_ID
 ```

 ## In the Cloud Shell copy the source data into the bucket:
```
wget https://archive.ics.uci.edu/ml/machine-learning-databases/kddcup99-mld/kddcup.data_10_percent.gz
gsutil cp kddcup.data_10_percent.gz gs://$PROJECT_ID/
```


## Make the script executable:

```
chmod +x submit_onejob.sh
```

## Launch the PySpark Analysis job:
```
./submit_onejob.sh $PROJECT_ID
```
