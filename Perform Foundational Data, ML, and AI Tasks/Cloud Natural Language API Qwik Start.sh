# Cloud Natural Language API: Qwik Start
# GSP097

CloudNaturalLanguageLocation=result.json

# set an environment variable with your PROJECT_ID which you will use throughout this codelab:
export GOOGLE_CLOUD_PROJECT=$(gcloud config get-value core/project)

# create a new service account 
gcloud iam service-accounts create my-natlang-sa \
  --display-name "my natural language service account"

# create credentials to log in as your new service account.
# Create these credentials and save it as a JSON file "~/key.json"
gcloud iam service-accounts keys create ~/key.json \
  --iam-account my-natlang-sa@${GOOGLE_CLOUD_PROJECT}.iam.gserviceaccount.com

# set the GOOGLE_APPLICATION_CREDENTIALS environment variable.
# The environment variable should be set to the full path of the credentials JSON file you created
#  which you can see in the output from the previous command:
export GOOGLE_APPLICATION_CREDENTIALS="/home/USER/key.json"

# In order to perform next steps please connect to the instance provisioned for you via ssh.
# Open the navigation menu and select Compute Engine.
# You should see the following provisioned linux instance


gcloud ml language analyze-entities --content="Michelangelo Caravaggio, Italian painter, is known for 'The Calling of Saint Matthew'." > result.json

gcloud ml language analyze-entities \
    --content="Michelangelo Caravaggio, Italian painter, is known for 'The Calling of Saint Matthew'." \
    > $CloudNaturalLanguageLocation
