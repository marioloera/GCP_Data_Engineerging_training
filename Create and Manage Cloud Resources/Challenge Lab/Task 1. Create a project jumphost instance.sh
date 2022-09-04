MACHINE_NAME=www1
MACHINE_TYPE=n1-standard-1
ZONE=us-east1-b

gcloud compute instances create $MACHINE_NAME \
    --machine-type $MACHINE_TYPE \
    --zone $ZONE \
    --tags http-server \
    --network-interface=network-tier=PREMIUM,subnet=default

-- SSH connect
gcloud compute ssh $MACHINE_NAME --zone $ZONE

-- Install an NGINX web server
sudo apt-get update
sudo apt-get install -y nginx
ps auwx | grep nginx


-- To see the web page, return to the Cloud Console and click the External IP link in the row for your machine, 
-- or add the External IP value to http://EXTERNAL_IP/
