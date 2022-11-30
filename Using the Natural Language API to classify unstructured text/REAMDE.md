# Task 1. Confirm that the Cloud Natural Language API is enabled


# Task 2. Create an API key

    Since you're using curl to send a request to the Natural Language API, you need to generate an API key to pass in the request URL.

    To create an API key, in your Console, click Navigation menu > APIs & services > Credentials.

    Then click + CREATE CREDENTIALS:

    In the drop down menu, select API key:

    Next, copy the key you just generated. Then click CLOSE.

    Now that you have an API key, save it to an environment variable to avoid having to insert the value of your API key in each request.

    In Cloud Shell run the following. Be sure to replace <your_api_key> with the key you just copied:
    ```
    export API_KEY=<YOUR_API_KEY>
    ```


# Extra PROJECT. GOOGLE_CLOUD_PROJECT

# Task 6. Classifying news data and storing the result in BigQuery

    ```
    gcloud iam service-accounts create my-account --display-name my-account
    gcloud projects add-iam-policy-binding $PROJECT --member=serviceAccount:my-account@$PROJECT.iam.gserviceaccount.com --role=roles/bigquery.admin
    gcloud projects add-iam-policy-binding $PROJECT --member=serviceAccount:my-account@$PROJECT.iam.gserviceaccount.com --role=roles/serviceusage.serviceUsageConsumer
    gcloud iam service-accounts keys create key.json --iam-account=my-account@$PROJECT.iam.gserviceaccount.com
    export GOOGLE_APPLICATION_CREDENTIALS=key.json
    ```