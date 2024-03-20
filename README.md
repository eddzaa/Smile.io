# Part 1: REST API Development

## Clone the repository

```
git clone https://github.com/eddzaa/Smile.io.git
cd Smile.io
```

> Note: I chose to implement the REST API in Node.js using JavaScript and the Express.js framework because the public repositories of Smile.io indicate that the company primarily uses languages like JavaScript, Ruby, and others. Since JavaScript is listed as one of the top languages, I will use Node.js and Express.js, which align with the existing JavaScript ecosystem at Smile.io.

## Install dependencies
```
npm install
```

## Run the API
```
npm start
```

## Install express module
```
npm install express
```

> Note: I used Express.js to build the Node.js REST API because it's a minimalistic and lightweight web framework, well-suited for building small to medium-sized APIs and it provides an easy way to define routes and handle HTTP requests/responses, which is essential for RESTful APIs.

## Run the app

```
node app.js
```

## Access the API

> Note: Once the server is running, you should see a message in your terminal or command prompt indicating the port number the API is listening on (e.g., Server is running on port
3000).

http://localhost:3000/

> You should see the JSON response { "message": "Hello Smile" }.

# Part 2: Dockerization and Local Deployment

> The Dockerfile uses the official Node.js Alpine image as the base, copies the application code, installs dependencies, and sets the command to run the app-js file.

## To build the Docker image
``` 
docker build -t smile .
``` 
> Note: Run in the same directory as the Dockerfile. 

## To run the container locally you would execute docker 

``` 
docker run -p 3000:3000 smile
``` 
> if the port 3000 is already in use then we can choose a different port for Docker container to use. For example, by running the container with -p 3001:3000 to map port 3001 on your host to port 3000 inside the container.

## Access the service running inside Docker container

http://localhost:3000/

# Part 3: Deployment in a Production Environment

## 3.1 Kubernetes

### Tag the docker image 
 
> Note:  Before pushing the image, Tag your local image with the repository name you want on Docker Hub. Use the below docker tag command.

```
docker tag smile:v1 yourusername/smile:v1

```

### Login to Dockerhub 

```
docker login
```
> You'll be prompted to enter your Docker Hub username and password.

### Push the Image

```
docker push yourusername/smile:v1
```

### Apply Kubernetes Manifests: Apply the Kubernetes manifests to deploy the application.

```
kubectl apply -f deployment.yaml 

kubectl apply -f service.yaml   
```       
### Local test 
>You can use Minikube, Kind (Kubernetes in Docker), Docker Desktop with Kubernetes, or MicroK8s. Each has its own advantages and use cases. For simplicity, let's use Minikube for this guide.

```
minikube service smile  
```

## Deploying Kubernetes manifests ie deployment.yaml and service.yaml to AWS for production steps. 

>Set Up AWS: Create resources like EC2 instances, EKS clusters, IAM roles, etc.
>created an Amazon ECR repository where we can store and manage your Docker images. 
 Use the ECR generated push commands 
 eg:
    ```
    aws ecr get-login-password --region <region> | docker login --username AWS --password-stdin <aws_account_id>.dkr.ecr.<region>.amazonaws.com
    docker tag <local_image_name>:<tag> <aws_account_id>.dkr.ecr.<region>.amazonaws.com/<repository_name>:<tag>
    docker push <aws_account_id>.dkr.ecr.<region>.amazonaws.com/<repository_name>:<tag>
    ```
>Set Up Amazon EKS: Create an Amazon EKS cluster using Terraform. 
>Configure kubectl to connect to your EKS cluster.

Install the AWS CLI and run bellow command to enable kubectl to communicate with an EKS cluster. 
 ```
aws eks --region us-east-1 update-kubeconfig --name TestOne
```
### Deploy Your Kubernetes Resources:
Make sure to replace the image reference with the correct Amazon ECR repository URL and image tag that you want to deploy in deployment.yaml file.
> Apply the deployment.yaml and service.yaml files to EKS cluster using kubectl:

```
aws eks --region us-east-1 update-kubeconfig --name TestOne
kubectl apply -f deployment.yaml
kubectl apply -f service.yaml
```
>Note: Repo: https://github.com/eddzaa/Smile.io.git

> Verify the status of  deployment and service:

``` 
kubectl get deployments
kubectl get pods
kubectl get services
```
> Expose LoadBalancer Service, AWS should automatically provision an ELB (Elastic Load Balancer). Retrieve the external IP address of the load balancer using:

``` 

kubectl get svc <service_name>
``` 
>The application can maintain high availability by running multiple instances and automatically scale up or down to handle levels of traffic and workload based on demand.


## 3.2 Terraform for AWS
>This repository contains Terraform code to provision the necessary AWS resources for deploying a simple REST API.

### Prerequisites

Ensure you have the following installed:

- Terraform
- Ensure that the AWS CLI is configured and the access credentials , use command ``` aws configure ```, and provide the AWS Access Key ID and Secret Access Key.

#### S3 to store the backend :

```
cd terraforms3
terraform init
terraform plan
terraform apply 
cd ..
```

#### Deploying resources using Terraform 

- `modules/`: Contains the custom modules used for the EKS cluster deployment.
  - `vpc/`: Defines the VPC configuration for the EKS cluster.
  - `iam-roles/`: Manages the IAM roles required for EKS.
  - `eks-cluster/`: Configures the EKS cluster.
  - `eks-worker-nodes/`: Manages the EKS worker nodes.
- `main.tf`: The main Terraform configuration file for deploying the EKS cluster.
- `variables.tf`: Defines the variables used in the configurations.
- `outputs.tf`: Specifies the output information from the Terraform deployment.
>Note: Update AWS Key pair name in variable.tf 

```
cd Terraform
terraform init
terraform plan
terraform apply 
```

#### Deploying the infrastructure on AWS

1. After deploying the infrastructure using Terraform.
2. In the AWS Management Console, navigate to the EC2 dashboard and locate the instance associated with the public IP and verify  .
3. Install the AWS CLI,configure, clone the repo and run bellow command to enable kubectl to communicate with an EKS cluster. 
 ```
sudo apt update
snap install aws-cli --classic
aws configure
curl -O https://s3.us-west-2.amazonaws.com/amazon-eks/1.29.0/2024-01-04/bin/linux/amd64/kubectl
chmod +x kubectl 
mv kubectl /usr/local/bin
aws eks --region ca-central-1 update-kubeconfig --name TestOne
kubectl apply -f deployment.yaml  
kubectl apply -f service.yaml  
```


        
If I had more time, I would prioritize enhancing the scalability, security, and automation aspects of the deployment to ensure optimal performance, reliability, and efficiency. This includes exploring features such as auto-scaling, blue-green deployments, and integration with CI/CD pipelines using Jenkins, along with SonarScanner for code quality . Additionally, I would integrating Route 53 for DNS management, CloudFront for content delivery, WAF for web application firewall protection, API Gateway for API management, and AWS Shield for DDoS protection, enable notification .

Load testing, thresholds, and resource limits for ensuring smooth operation of the pod. To enhance monitoring and observability, I would implement logging and monitoring solutions using tools like Prometheus and Grafana, to get visibility into system metrics and performance indicators. I would leverage Helm for streamlined deployment and management, Health checks and liveness probes in Kubernetes manifests to ensure the reliability of the application.

I would strengthen the Security by implementing SSL/TLS , encryption at rest, and network policies to control traffic flow within the cluster. Continuous updates and maintenance of both infrastructure and applications to address security vulnerabilities and ensure ongoing reliability.


