# better to create manually because default zone
MACHINE_NAME=nucleus-jumphost-722
MACHINE_TYPE=f1-micro

gcloud compute instances create $MACHINE_NAME --machine-type $MACHINE_TYPE
