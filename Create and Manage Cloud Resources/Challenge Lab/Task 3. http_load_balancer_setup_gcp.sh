PROJECT_ID=qwiklabs-gcp-01-8dcb333a9564
gcloud compute project-info describe --project $PROJECT_ID

RULE_NAME=allow-tcp-rule-797
MACHINE_TYPE=n1-standard-1 
ZONE=us-east4-b
REGION=us-east4

# setup
gcloud auth list
gcloud config set compute/zone $ZONE
gcloud config set compute/region $REGION

# create an instance template
cat << EOF > startup.sh
#! /bin/bash
apt-get update
apt-get install -y nginx
service nginx start
sed -i -- 's/nginx/Google Cloud Platform - '"\$HOSTNAME"'/' /var/www/html/index.nginx-debian.html
EOF

gcloud compute instance-templates create nginx-template \
   --region=$REGION \
   --machine-type=$MACHINE_TYPE \
   --metadata-from-file startup-script=startup.sh

# create a target pool
gcloud compute target-pools create nginx-pool

# create a managed instance group of 2 nginx web servers
gcloud compute instance-groups managed create nginx-group \
	--base-instance-name nginx \
	--size 2 \
	--template nginx-template \
	--target-pool nginx-pool


gcloud compute instances list

# create a firewall rule
gcloud compute firewall-rules create www-firewall --allow tcp:80

# create a forwarding rule
gcloud compute forwarding-rules create $RULE_NAME \
	--region $REGION \
	--ports=80 \
	--target-pool nginx-pool

gcloud compute forwarding-rules list

# create a health check
gcloud compute http-health-checks create http-basic-check

# create a backend service and attach the managed instasnce group
gcloud compute instance-groups managed \
	set-named-ports nginx-group \
	--named-ports http:80

gcloud compute backend-services create nginx-backend \
	--protocol HTTP \
	--http-health-checks http-basic-check \
	--global

gcloud compute backend-services add-backend nginx-backend \
	--instance-group nginx-group \
	--instance-group-zone $ZONE \
	--global

# create a url map and target the HTTP proxy
gcloud compute url-maps create web-map \
	--default-service nginx-backend

gcloud compute target-http-proxies create http-lb-proxy \
	--url-map web-map

# create a forwarding rule
gcloud compute forwarding-rules create http-content-rule \
	--global \
	--target-http-proxy http-lb-proxy \
	--ports 80

gcloud compute forwarding-rules list