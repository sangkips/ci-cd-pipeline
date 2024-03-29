## AWS CI/CD Pipeline

The goal of this project is to set up a complete CI/CD pipeline for deploying a containerized application on AWS infrastructure using Terraform, Jenkins.

### What to accomplish

1. Virtual Private Cloud (VPC)
    - Create a custom VPC with private and public subnets.
    - Create S3 bucket
    - Create an S3 backend to store `.tfstate` file
    - Create a DynamoDB for locking the state file, this is usefull when we have many developers woroking on the same state file. Chaos is what we need to minimize here
2. Route53
    - Configure a Route53 hosted zone for DNS management.
3. Elastic Container Service (ECS)
    - Set up ECS clusters for container orchestration.
4. Elastic Container Registry (ECR)
    - Create an ECR repository to store Docker images.
5. Jenkins
    - Configure Jenkins as a CI/CD server for building and deploying the application.
6. SonarQube
    - Set up SonarQube for code quality analysis.

