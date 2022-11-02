
# Set up gcloud 

 1. Install gcloud
 
    [more info here](https://cloud.google.com/sdk/docs/install)
 
    ```
    ./google-cloud-sdk/install.sh
    ./google-cloud-sdk/bin/gcloud init
    ```
    
 1. Add it to your path or run:

 ```
 source ~/google-cloud-sdk/path.zsh.inc
 ```

 1. Add Application Default Credentials:
 
 [more info here](https://cloud.google.com/sdk/gcloud/reference/auth/application-default)

 ```
 gcloud auth application-default login
 ```

# GCP Autentificate in Github Actions

 1. Create a service account in GCP

 1. Generate a service account key in JSON (GCP console / iam / Service Accounts / USER / Keys

 1. Add the json to a secret in Github organization or repo, with the same name as used in the Github acctions:
   | Github Action     | Secret name|
   | ------------------ |:-------------:|
   | secrets.GCP_TOKEN  | GCP_TOKEN     |
