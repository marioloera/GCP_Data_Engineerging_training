# Setting Up Network and HTTP Load Balancers [ACE]


MACHINE_TYPE=e2-medium
REGION=us-central1
ZONE=us-central1-a

# Set the default region and zone for all resources
gcloud config set compute/region $REGION
gcloud config set compute/zone $ZONE

# Create multiple web server instances
# To simulate serving from a cluster of machines,
# create a simple cluster of Nginx web servers to serve static content
# using Instance Templates and Managed Instance Groups.


#  create a startup script to be used by every virtual machine instance.
# This script sets up the Nginx server upon startup:

cat << EOF > startup.sh
#! /bin/bash
apt-get update
apt-get install -y nginx
service nginx start
sed -i -- 's/nginx/Google Cloud Platform - '"\$HOSTNAME"'/' /var/www/html/index.nginx-debian.html
EOF

# Create an instance template, which uses the startup script:
gcloud compute instance-templates create nginx-template \
         --metadata-from-file startup-script=startup.sh


# Create a target pool.
# A target pool allows a single access point to all the instances in a group
# and is necessary for load balancing in the future steps.
gcloud compute target-pools create nginx-pool

# Create a managed instance group using the instance template:
gcloud compute instance-groups managed create nginx-group \
    --base-instance-name nginx \
    --size 2 \
    --template nginx-template \
    --target-pool nginx-pool

# list compute instances
gcloud compute instances list

# Configure a firewall so that you can connect to the machines on port 80 via the EXTERNAL_IP addresses
gcloud compute firewall-rules create www-firewall --allow tcp:80

# 1. Create a Network Load Balancer
# Create an L4 network load balancer targeting your instance group:
gcloud compute forwarding-rules create nginx-lb \
    --region us-central1 \
    --ports=80 \
    --target-pool nginx-pool

gcloud compute forwarding-rules list


# 2. Create a HTTP(s) Load Balancer
# Create a health check. Health checks verify that the instance is responding to HTTP or HTTPS traffic:
gcloud compute http-health-checks create http-basic-check

# Define an HTTP service and map a port name to the relevant port for the instance group. 
# Now the load balancing service can forward traffic to the named port:
gcloud compute instance-groups managed \
    set-named-ports nginx-group \
    --named-ports http:80

# Create a backend service:
gcloud compute backend-services create nginx-backend \
      --protocol HTTP --http-health-checks http-basic-check --global

# Add the instance group into the backend service:
gcloud compute backend-services add-backend nginx-backend \
    --instance-group nginx-group \
    --instance-group-zone us-central1-a \
    --global

# Create a default URL map that directs all incoming requests to all your instances:
gcloud compute url-maps create web-map \
    --default-service nginx-backend

# Create a target HTTP proxy to route requests to your URL map:
gcloud compute target-http-proxies create http-lb-proxy \
    --url-map web-map

# Create a global forwarding rule to handle and route incoming requests.
# A forwarding rule sends traffic to a specific target HTTP or HTTPS proxy
# depending on the IP address, IP protocol, and port specified.
# The global forwarding rule does not support multiple ports.
gcloud compute forwarding-rules create http-content-rule \
    --global \
    --target-http-proxy http-lb-proxy \
    --ports 80

# 
gcloud compute forwarding-rules list

# From the browser, you should be able to connect to http://IP_ADDRESS/. 
# It may take three to five minutes.
