# Terraform Deployment Guide

This directory contains Terraform code for the AWS Multi-VPC Banking Microservices project.

The Terraform code provisions the same architecture that was first deployed manually.

## Prerequisites

Install and configure:

* Terraform
* AWS CLI
* AWS credentials with permissions to create the required AWS resources
* A registered Route 53 hosted zone if you want to use your own domain
* The `fake-service` binary stored locally before Terraform uploads it to S3

## Configure Variables

Go to the lab environment:

```bash
cd terraform/environments/lab
```

Create your local variables file:

```bash
cp terraform.tfvars.example terraform.tfvars
```

Update `terraform.tfvars` with your values.

Do not commit `terraform.tfvars`.

## Application Artifact

The `fake-service` binary is not included in this repository.

Place the binary in the local path expected by your Terraform configuration before deployment.

See:

```text
terraform/artifacts/README.md
```

## Deploy

Initialize Terraform:

```bash
terraform init
```

Format Terraform files:

```bash
terraform fmt -recursive
```

Validate the configuration:

```bash
terraform validate
```

Review the infrastructure plan:

```bash
terraform plan
```

Create the infrastructure:

```bash
terraform apply
```

## Verify

After Terraform finishes, test the public Customer Profile endpoint.

Expected service flow:

```text
Customer Profile Service
  ↓
Account Service
  ↓
Statement Service
  ↓
HTTP 200
```

Useful commands:

```bash
aws autoscaling describe-auto-scaling-groups
aws elbv2 describe-target-health --target-group-arn <target-group-arn>
curl -k https://customer-profile.your-domain.com
```

## Destroy

To remove the lab resources and avoid AWS charges:

```bash
terraform destroy
```

Review the destroy plan carefully before approval.

## Important Files Not Included in GitHub

```text
terraform.tfstate
terraform.tfstate.backup
terraform.tfvars
.terraform/
fake-service
*.pem
.env
```