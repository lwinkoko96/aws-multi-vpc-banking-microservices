# AWS Multi-VPC Banking Microservices

A hands-on AWS networking and Infrastructure as Code project that deploys a fake banking microservices application across three VPCs.

This project was first deployed manually to understand each AWS component and network flow step by step. After confirming that the architecture worked, I rebuilt the same infrastructure using Terraform.

## Project Overview

The application contains three services:

* Customer Profile Service
* Account Service
* Statement Service

Each service runs in its own VPC and communicates privately with the next service.

Only the Customer Profile service is publicly accessible.

```text
User
  ↓
Customer Profile Public ALB
  ↓
Customer Profile Service
  ↓
Account Internal ALB
  ↓
Account Service
  ↓
Statement Internal ALB
  ↓
Statement Service
```

## Architecture Diagram

![AWS Multi-VPC Banking Architecture](./architecture/banking-vpc-peering-architecture.png)

## Deployment Approaches

| Approach             | Purpose                                                                                                   |
| -------------------- | --------------------------------------------------------------------------------------------------------- |
| Manual Deployment    | Used to understand AWS networking, routing, security groups, ALBs, and service communication step by step |
| Terraform Deployment | Used to automate and recreate the same architecture consistently using Infrastructure as Code             |

## AWS Services Used

* Amazon VPC
* Public and private subnets
* Internet Gateway
* Application Load Balancer
* Internal Application Load Balancer
* Amazon EC2
* Launch Templates
* Auto Scaling Groups
* Target Groups
* VPC Peering
* Route Tables
* Security Groups
* Amazon Route 53
* AWS Certificate Manager
* Amazon S3
* S3 Gateway VPC Endpoint
* IAM Role and Instance Profile
* EC2 Instance Connect Endpoint
* Systems Manager VPC Endpoints

## Architecture Overview

| Service          | VPC CIDR      | Load Balancer       | Instance Location | Application Port |
| ---------------- | ------------- | ------------------- | ----------------- | ---------------: |
| Customer Profile | `10.1.0.0/16` | Internet-facing ALB | Private subnets   |           `9091` |
| Account          | `10.2.0.0/16` | Internal ALB        | Private subnets   |           `9092` |
| Statement        | `10.3.0.0/16` | Internal ALB        | Private subnets   |           `9093` |

Each VPC spans two Availability Zones.

## Security Design

Only the Customer Profile ALB accepts public traffic.

| Source                   | Destination                    |        Port |
| ------------------------ | ------------------------------ | ----------: |
| Internet                 | Customer Profile ALB           | `80`, `443` |
| Customer Profile ALB     | Customer Profile EC2 instances |      `9091` |
| Customer Profile service | Account internal ALB           |        `80` |
| Account ALB              | Account EC2 instances          |      `9092` |
| Account service          | Statement internal ALB         |        `80` |
| Statement ALB            | Statement EC2 instances        |      `9093` |

The Account and Statement services are private. They are not directly exposed to the internet.

## Application Runtime

The fake banking services run as `systemd` services on Amazon EC2.

During instance startup, Launch Template user data performs the following steps:

1. Downloads the `fake-service` binary from Amazon S3.
2. Installs it at `/usr/local/bin/fake-service`.
3. Creates or configures the systemd service.
4. Enables and starts the application.
5. Allows the ALB target group health check to verify the service.

| Service          |   Port | Upstream Service       |
| ---------------- | -----: | ---------------------- |
| Customer Profile | `9091` | Account internal ALB   |
| Account          | `9092` | Statement internal ALB |
| Statement        | `9093` | No upstream service    |

## Private S3 Access

The application binary is stored in an S3 bucket.

Private EC2 instances download the binary through S3 Gateway VPC Endpoints. This allows the instances to access S3 without requiring a NAT Gateway for the application artifact download.

The `fake-service` binary is intentionally not included in this GitHub repository.

## Terraform Implementation

The same architecture is automated using Terraform.

Terraform code is organized into reusable modules for networking, load balancing, Auto Scaling, IAM, Route 53, ACM, S3, VPC endpoints, and VPC peering.

```text
terraform/
├── artifacts/
│   └── README.md
├── environments/
│   └── lab/
│       ├── main.tf
│       ├── provider.tf
│       ├── variables.tf
│       ├── outputs.tf
│       ├── versions.tf
│       ├── terraform.tfvars.example
│       └── templates/
└── modules/
    ├── acm/
    ├── alb/
    ├── autoscaling/
    ├── iam/
    ├── route53/
    ├── s3-bucket/
    ├── s3-endpoint/
    ├── security-group/
    ├── ssm-endpoints/
    ├── vpc/
    └── vpc-peering/
```

See [terraform/README.md](./terraform/README.md) for Terraform deployment instructions.

## Test Results

### Manual Deployment Result

The manually deployed environment successfully returned the complete upstream response chain:

```text
Customer Profile → Account → Statement → HTTP 200
```

![Manual Deployment Result](./screenshots/manual-deployment-result.png)

### Terraform Deployment Result

After rebuilding the same architecture with Terraform, the public Customer Profile endpoint successfully reached all backend services.

```text
Customer Profile → Account → Statement → HTTP 200
```

![Terraform Deployment Result](./screenshots/terraform-deployment-result.png)

This confirms that the same multi-VPC service chain was successfully recreated using Terraform.

## Key Learning Points

* Designing multi-VPC architectures on AWS
* Private service-to-service communication using VPC Peering
* Route table configuration for cross-VPC traffic
* Public versus internal Application Load Balancer design
* Security group rules between ALBs and EC2 instances
* Launch Templates and Auto Scaling Groups
* Private S3 access using Gateway VPC Endpoints
* Running applications through systemd on EC2
* Rebuilding infrastructure consistently using Terraform modules

## Important Security Notes

The following files are not committed to this repository:

```text
terraform.tfstate
terraform.tfstate.backup
terraform.tfvars
.terraform/
fake-service
*.pem
*.key
.env
```

## Cleanup

For the Terraform deployment:

```bash
cd terraform/environments/lab
terraform destroy
```

Review the destroy plan carefully before confirming.

## Author

Created by Lwin Ko Ko

DevOps Engineer | Cloud Engineer

This project is part of my AWS and DevOps hands-on learning journey.
