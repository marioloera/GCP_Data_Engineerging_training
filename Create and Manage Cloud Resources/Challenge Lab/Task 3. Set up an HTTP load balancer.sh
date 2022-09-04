LAB:
gcloud compute firewall-rules create www-firewall-network-lb --target-tags network-lb-tag --allow tcp:80
gcloud compute addresses create network-lb-ip-1 --region
gcloud compute http-health-checks create basic-check
gcloud compute target-pools create www-pool --region  --http-health-check basic-check
gcloud compute target-pools add-instances www-pool --instances www1,www2,www3
______

CHALLENGE:

RULE_NAME=grant-tcp-rule-572
REGION=us-east1
ZONE=us-east1-b

#TODO CREATE THE INSTANCES WITH CODE

gcloud compute firewall-rules create $RULE_NAME --target-tags network-lb-tag --allow tcp:80
gcloud compute addresses create network-lb-ip-1 --region $REGION
gcloud compute http-health-checks create basic-check
gcloud compute target-pools create www-pool --region $REGION --http-health-check basic-check
gcloud compute target-pools add-instances www-pool --instances instance-1,instance-2  --zone $ZONE
gcloud compute forwarding-rules create www-rule --region $REGION --ports 80 --address network-lb-ip-1 --target-pool www-pool

gcloud compute forwarding-rules describe www-rule --region $REGION
IPADDRESS=$(gcloud compute forwarding-rules describe www-rule --region $REGION --format="json" | jq -r .IPAddress)
IPADDRESS=$(gcloud compute forwarding-rules describe www-rule --region us-east1  --format="json" | jq -r .IPAddress)
echo $IPADDRESS
while true; do curl -m1 $IPADDRESS; done