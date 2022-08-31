gcloud composer environments run composer-advanced-lab \
--location us-east1 variables -- \
set gcs_source_bucket My_Bucket-us


gcloud composer environments run composer-advanced-lab \
    --location us-east1 variables -- \
    get gcs_source_bucket