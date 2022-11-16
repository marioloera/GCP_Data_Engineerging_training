#!/bin/bash
echo CLUSTER_NAME $1 
echo BUCKET_NAME $2
gcloud dataproc jobs submit pyspark \
       --cluster $1 \
       --region us-central1 \
       spark_analysis.py \
       -- --bucket=$2
