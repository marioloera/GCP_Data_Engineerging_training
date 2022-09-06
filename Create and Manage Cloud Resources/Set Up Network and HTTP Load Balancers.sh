# Task 1. Set the default region and zone for all resources
ZONE=us-west4-c
REGION=us-west4
MACHINE_TYPE=e2-medium

gcloud config set compute/zone $ZONE
gcloud config set compute/region $REGION

# Task 2. Create multiple web server instances
  gcloud compute instances create www1 \
    --zone= \
    --tags=network-lb-tag \
    --machine-type=e2-medium \
    --image-family=debian-11 \
    --image-project=debian-cloud \
    --metadata=startup-script='#!/bin/bash
      apt-get update
      apt-get install apache2 -y
      service apache2 restart
      echo "
<h3>Web Server: www1</h3>" | tee /var/www/html/index.html'

  gcloud compute instances create www2 \
    --zone= \
    --tags=network-lb-tag \
    --machine-type=e2-medium \
    --image-family=debian-11 \
    --image-project=debian-cloud \
    --metadata=startup-script='#!/bin/bash
      apt-get update
      apt-get install apache2 -y
      service apache2 restart
      echo "
<h3>Web Server: www2</h3>" | tee /var/www/html/index.html'

  gcloud compute instances create www3 \
    --zone= \
    --tags=network-lb-tag \
    --machine-type=e2-medium \
    --image-family=debian-11 \
    --image-project=debian-cloud \
    --metadata=startup-script='#!/bin/bash
      apt-get update
      apt-get install apache2 -y
      service apache2 restart
      echo "
<h3>Web Server: www3</h3>" | tee /var/www/html/index.html'

# Create a firewall rule to allow external traffic to the VM instances:
gcloud compute firewall-rules create www-firewall-network-lb --target-tags network-lb-tag --allow tcp:80


# Task 3. Configure the load balancing service

# Create a static external IP address for your load balancer:
gcloud compute addresses create network-lb-ip-1 --region  

# Add a legacy HTTP health check resource:
gcloud compute http-health-checks create basic-check

# Add a target pool in the same region as your instances. 
# Run the following to create the target pool and use the health check
#  which is required for the service to function:
gcloud compute target-pools create www-pool --region  --http-health-check basic-check

# Add the instances to the pool:
gcloud compute target-pools add-instances www-pool --instances www1,www2,www3

# Add a forwarding rule:
gcloud compute forwarding-rules create www-rule \
    --region   \
    --ports 80 \
    --address network-lb-ip-1 \
    --target-pool www-pool

# Task 4. Sending traffic to your instances

# Enter the following command to view the external IP address of the www-rule forwarding rule used by the load balancer:
gcloud compute forwarding-rules describe www-rule --region 

# Access the external IP address
IPADDRESS=$(gcloud compute forwarding-rules describe www-rule --region  --format="json" | jq -r .IPAddress)

# Show the external IP address
echo $IPADDRESS

# Use curl command to access the external IP address, replacing IP_ADDRESS with an external IP address from the previous command:
while true; do curl -m1 $IPADDRESS; done

Ctrl + c
