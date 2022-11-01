
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
