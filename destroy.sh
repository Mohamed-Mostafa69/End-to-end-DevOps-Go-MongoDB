#!/bin/bash
cluster_name="cluster-1-test" # If you wanna change the cluster name make sure you change it in the terraform directory variables.tf (name_prefix & environment)
region="eu-central-1"
aws_id="486307699559"
repo_name="goapp-survey" # If you wanna change the repository name make sure you change it in the k8s/app.yml (Image name) 
image_name="$aws_id.dkr.ecr.$region.amazonaws.com/$repo_name:latest"
domain="soshost.online"
namespace="go-survey"


#ECR Login
echo "--------------------Login to ECR--------------------"
aws ecr get-login-password --region $region | docker login --username AWS --password-stdin $aws_id.dkr.ecr.$region.amazonaws.com

# delete Docker-img from ECR
echo "--------------------Deleting ECR-IMG--------------------"
aws ecr batch-delete-image --repository-name $repo_name --image-ids imageTag=latest

# delete deployment
echo "--------------------Deleting Deployment--------------------"
kubectl delete -n $namespace -f k8s/

# delete namespace
echo "--------------------Deleting Namespace--------------------"
kubectl delete ns $namespace

# delete AWS resources
echo "--------------------Deleting AWS Resources--------------------"
cd terraform && \
terraform destroy -auto-approve
