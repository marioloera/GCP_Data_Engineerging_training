# Task 1. Set the default region and zone for all resources
gcloud config set compute/zone
gcloud config set compute/region

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

################################################################
# Task 5. Create an HTTP load balancer
# To set up a load balancer with a Compute Engine backend, your VMs need to be in an instance group. 
# The managed instance group provides VMs running the backend servers of an external HTTP load balancer.
# For this lab, backends serve their own hostnames.


# First, create the load balancer template:
gcloud compute instance-templates create lb-backend-template \
   --region= \
   --network=default \
   --subnet=default \
   --tags=allow-health-check \
   --machine-type=e2-medium \
   --image-family=debian-11 \
   --image-project=debian-cloud \
   --metadata=startup-script='#!/bin/bash
     apt-get update
     apt-get install apache2 -y
     a2ensite default-ssl
     a2enmod ssl
     vm_hostname="$(curl -H "Metadata-Flavor:Google" \
     http://169.254.169.254/computeMetadata/v1/instance/name)"
     echo "Page served from: $vm_hostname" | \
     tee /var/www/html/index.html
     systemctl restart apache2'


# Create a managed instance group based on the template:
gcloud compute instance-groups managed create lb-backend-group --template=lb-backend-template --size=2 --zone= 

# Create the fw-allow-health-check firewall rule.
gcloud compute firewall-rules create fw-allow-health-check \
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
  --instance-group-zone= \
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

