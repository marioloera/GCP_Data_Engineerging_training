# Google Cloud Speech API: Qwik Start
# GSP119


# Task 1. Create an API key
    # To create an API key, click Navigation menu > APIs & services > Credentials.
    # Then click Create credentials.
    # In the drop down menu, select API key.
    # Copy the key you just generated and click Close.


# In the Navigation menu, select Compute Engine. You should see a linux-instance

# will save it as an environment variable
export API_KEY=AIzaSyBFwbEXtMQj7OClhz2rYMMZbS6aAJnNYUE


# Task 2. Create your Speech API request

URI=gs://cloud-samples-tests/speech/brooklyn.flac
REQUEST_FILE=request.json
RESULT_FILE=result.json

cat << EOF > $REQUEST_FILE
{
  "config": {
      "encoding":"FLAC",
      "languageCode": "en-US"
  },
  "audio": {
      "uri":"$URI"
  }
}
EOF


# Task 3. Call the Speech API
#curl -s -X POST -H "Content-Type: application/json" --data-binary @request.json \
#"https://speech.googleapis.com/v1/speech:recognize?key=${API_KEY}"


curl -s -X POST -H "Content-Type: application/json" --data-binary @$REQUEST_FILE \
    "https://speech.googleapis.com/v1/speech:recognize?key=${API_KEY}" \
    > $RESULT_FILE
