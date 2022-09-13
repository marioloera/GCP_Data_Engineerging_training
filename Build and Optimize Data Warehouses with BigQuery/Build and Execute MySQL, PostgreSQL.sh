# Build and Execute MySQL, PostgreSQL, and SQLServer to Data Catalog Connectors
# GSP814

# Task 1. Enable the Data Catalog API

# Task 2. SQLServer to Data Catalog




export PROJECT_ID=$(gcloud config get-value project)

gcloud config set project $PROJECT_ID


# Create the SQLServer database

    # In your Cloud Shell session, run the following command to download the scripts
    # to create and populate your SQLServer instance:
    gsutil cp gs://spls/gsp814/cloudsql-sqlserver-tooling.zip .
    unzip cloudsql-sqlserver-tooling.zip

    cd cloudsql-sqlserver-tooling

    bash init-db.sh
    # This will take around 5 to 10 minutes to complete.

    # Set up the Service Account
    gcloud iam service-accounts create sqlserver2dc-credentials \
        --display-name  "Service Account for SQLServer to Data Catalog connector" \
        --project $PROJECT_ID

    # Now create and download the Service Account Key.
    gcloud iam service-accounts keys create "sqlserver2dc-credentials.json" \
        --iam-account "sqlserver2dc-credentials@$PROJECT_ID.iam.gserviceaccount.com"

    # Add the Data Catalog admin role to the Service Account:
    gcloud projects add-iam-policy-binding $PROJECT_ID \
        --member "serviceAccount:sqlserver2dc-credentials@$PROJECT_ID.iam.gserviceaccount.com" \
        --quiet \
        --project $PROJECT_ID \
        --role "roles/datacatalog.admin"


    # Execute SQLServer to Data Catalog connector
    :`
    You can build the SQLServer connector yourself by going to this GitHub repository.
    To facilitate its usage, we are going to use a docker image.
    The variables needed were output by the Terraform config.
    Change directories into the location of the Terraform scripts:
    `
    cd infrastructure/terraform/

    public_ip_address=$(terraform output -raw public_ip_address)
    username=$(terraform output -raw username)
    password=$(terraform output -raw password)
    database=$(terraform output -raw db_name)

    cd ~/cloudsql-sqlserver-tooling

    docker run --rm --tty -v \
        "$PWD":/data mesmacosta/sqlserver2datacatalog:stable \
        --datacatalog-project-id=$PROJECT_ID \
        --datacatalog-location-id=us-central1 \
        --sqlserver-host=$public_ip_address \
        --sqlserver-user=$username \
        --sqlserver-pass=$password \
        --sqlserver-database=$database
    