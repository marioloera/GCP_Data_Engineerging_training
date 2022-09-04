LAB:
gcloud container clusters create --machine-type=e2-medium lab-cluster 

_______________
CHALLENGE:

MACHINE_TYPE=n1-standard-1 
ZONE=us-east1-b
CLUSTER_NAME=hello-app
IMAGE=gcr.io/google-samples/hello-app:2.0
PORT=8082

gcloud container clusters create --machine-type=$MACHINE_TYPE --zone=$ZONE lab-cluster
gcloud container clusters get-credentials --zone=$ZONE lab-cluster
kubectl create deployment $CLUSTER_NAME --image=$IMAGE
kubectl expose deployment $CLUSTER_NAME --type=LoadBalancer --port $PORT
_______________