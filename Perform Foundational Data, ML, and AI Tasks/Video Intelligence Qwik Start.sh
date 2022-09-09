# Video Intelligence: Qwik Start
# GSP154

# For this lab, the Cloud Video Intelligence API is enabled for you

# create a new service account
gcloud iam service-accounts create quickstart

export GOOGLE_CLOUD_PROJECT=$(gcloud config get-value core/project)
echo $GOOGLE_CLOUD_PROJECT

SERVICE_ACCOUNT_FULL_NAME=quickstart@$GOOGLE_CLOUD_PROJECT.iam.gserviceaccount.com
echo $SERVICE_ACCOUNT_FULL_NAME

# Create a service account key file
gcloud iam service-accounts keys create key.json --iam-account $SERVICE_ACCOUNT_FULL_NAME

# authenticate your service account, passing the location of your service account key file:
gcloud auth activate-service-account --key-file key.json

# Obtain an authorization token using your service account:
gcloud auth print-access-token


# Make an annotate video request

URI=gs://spls/gsp154/video/train.mp4
REQUEST_FILE=request.json
RESULT_FILE=result.json

cat << EOF > $REQUEST_FILE
{
  "inputUri":"$URI",
  "features": [
    "LABEL_DETECTION"
   ]
}
EOF

# Use curl to make a videos:annotate request passing the filename of the entity request
curl -s -H 'Content-Type: application/json' \
    -H 'Authorization: Bearer '$(gcloud auth print-access-token)'' \
    'https://videointelligence.googleapis.com/v1/videos:annotate' \
    -d @$REQUEST_FILE


# The Video Intelligence API creates an operation to process your request.
# You should now see a response that includes your operation name,
# which should look similar to this one
# {
#  "name": "projects/973730912830/locations/europe-west1/operations/2545350447629986520"
# }

PROJECTS=973730912830
OPERATION_NO=2545350447629986520
LOCATIONS=europe-west1
OPERATION_URI="'https://videointelligence.googleapis.com/v1/projects/$PROJECTS/locations/$LOCATIONS/operations/$OPERATION_NO'"
echo $OPERATION_URI

# Use this script to request information on the operation by calling the v1.operations endpoint.
# Replace the PROJECTS, LOCATIONS and OPERATION_NAME
# with the value you just received in the previous command:
curl -s -H 'Content-Type: application/json' \
    -H 'Authorization: Bearer '$(gcloud auth print-access-token)'' \
    'https://videointelligence.googleapis.com/v1/projects/973730912830/locations/europe-west1/operations/2545350447629986520'
