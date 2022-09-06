MACHINE_NAME=nucleus-jumphost-722
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

# long command
gcloud compute instances create gcelab4 \
 --zone=us-west1-a \
 --machine-type=e2-medium \
 --network-interface=network-tier=PREMIUM,subnet=default \
 --metadata=enable-oslogin=true \
 --maintenance-policy=MIGRATE \
 --provisioning-model=STANDARD \
 --scopes=https://www.googleapis.com/auth/devstorage.read_only,https://www.googleapis.com/auth/logging.write,https://www.googleapis.com/auth/monitoring.write,https://www.googleapis.com/auth/servicecontrol,https://www.googleapis.com/auth/service.management.readonly,https://www.googleapis.com/auth/trace.append \
 --tags=http-server \
 --create-disk=auto-delete=yes,boot=yes,device-name=gcelab3,image=projects/debian-cloud/global/images/debian-11-bullseye-v20220822,mode=rw,size=10,type=projects/qwiklabs-gcp-03-9a6b14c36b68/zones/us-west1-a/diskTypes/pd-balanced \
 --no-shielded-secure-boot \
 --shielded-vtpm \
 --shielded-integrity-monitoring \
 --reservation-affinity=any
