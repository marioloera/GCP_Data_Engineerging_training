gcloud compute project-info describe --project $PROJECT_ID

RULE_NAME=allow-tcp-rule-797
MACHINE_TYPE=n1-standard-1 
ZONE=us-east1-b
REGION=us-east1

# Task 3. Create an HTTP load balancer
# Set the default region and zone for all resources
# gcloud config set compute/zone $ZONE
# gcloud config set compute/region $REGION

# To set up a load balancer with a Compute Engine backend, your VMs need to be in an instance group. 
# The managed instance group provides VMs running the backend servers of an external HTTP load balancer.
# For this lab, backends serve their own hostnames.

# create a file to pass as startup-script for the nginx template
cat << EOF > startup.sh
#! /bin/bash
apt-get update
apt-get install -y nginx
service nginx start
sed -i -- 's/nginx/Google Cloud Platform - '"\$HOSTNAME"'/' /var/www/html/index.nginx-debian.html
EOF

# First, create the load balancer template:
gcloud compute instance-templates create lb-backend-template \
   --region=$REGION \
   --network=default \
   --subnet=default \
   --tags=allow-health-check,http-server \
   --machine-type=$MACHINE_TYPE \
   --image-family=debian-11 \
   --image-project=debian-cloud \
   --metadata-from-file=startup-script=startup.sh

# Create a managed instance group based on the template:
gcloud compute instance-groups managed create lb-backend-group --template=lb-backend-template --size=2 --zone=$ZONE

# Create the firewall rule.
gcloud compute firewall-rules create $RULE_NAME \
  --network=default \
  --action=allow \
  --direction=ingress \
  --source-ranges=130.211.0.0/22,35.191.0.0/16 \
  --target-tags=allow-health-check \
  --rules=tcp:80

# Now that the instances are up and running
# set up a global static external IP address that your customers use to reach your load balancer:
gcloud compute addresses create lb-ipv4-1 \
  --ip-version=IPV4 \
  --global

# Note the IPv4 address that was reserved:
gcloud compute addresses describe lb-ipv4-1 \
  --format="get(address)" \
  --global

# Create a health check for the load balancer:
gcloud compute health-checks create http http-basic-check \
  --port 80

# Create a backend service:
gcloud compute backend-services create web-backend-service \
  --protocol=HTTP \
  --port-name=http \
  --health-checks=http-basic-check \
  --global

# Add your instance group as the backend to the backend service:
gcloud compute backend-services add-backend web-backend-service \
  --instance-group=lb-backend-group \
  --instance-group-zone=$ZONE \
  --global

# Create a URL map to route the incoming requests to the default backend service:
gcloud compute url-maps create web-map-http \
    --default-service web-backend-service

# Create a target HTTP proxy to route requests to your URL map:
gcloud compute target-http-proxies create http-lb-proxy \
    --url-map web-map-http

# Create a global forwarding rule to route incoming requests to the proxy:
gcloud compute forwarding-rules create http-content-rule \
    --address=lb-ipv4-1\
    --global \
    --target-http-proxy=http-lb-proxy \
    --ports=80

