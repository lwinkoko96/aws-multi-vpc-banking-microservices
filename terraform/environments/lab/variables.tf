variable "aws_region" {
  type        = string
  description = "AWS region where resources will be deployed."
  default     = "us-east-1"
}

variable "project_name" {
  type        = string
  description = "Project name used for tags and naming."
  default     = "fake-service"
}

variable "environment" {
  type        = string
  description = "Deployment environment identifier."
  default     = "lab"
}

variable "domain_name" {
  type        = string
  description = "Public Route 53 hosted zone domain name."
  default     = "lwinkoko.site"
}

variable "public_service_domain" {
  type        = string
  description = "Public service DNS record for customer-profile."
  default     = "customer-profile.lwinkoko.site"
}

variable "internal_domain_name" {
  type        = string
  description = "Private hosted zone root domain name."
  default     = "internal.lwinkoko.site"
}

variable "package_bucket_name" {
  type        = string
  description = "Existing S3 bucket storing the application binary."
  default     = "lkk-app-packages"
}

variable "fake_service_object_key" {
  type        = string
  description = "S3 object key for the fake service binary."
  default     = "fake-service"
}

variable "instance_type" {
  type        = string
  description = "EC2 instance type for application instances."
  default     = "t3.micro"
  validation {
    condition     = length(var.instance_type) > 0
    error_message = "instance_type must not be empty."
  }
}

variable "customer_profile_port" {
  type        = number
  description = "Customer profile application port."
  default     = 9091
  validation {
    condition     = var.customer_profile_port >= 1 && var.customer_profile_port <= 65535
    error_message = "customer_profile_port must be between 1 and 65535."
  }
}

variable "account_port" {
  type        = number
  description = "Account application port."
  default     = 9092
  validation {
    condition     = var.account_port >= 1 && var.account_port <= 65535
    error_message = "account_port must be between 1 and 65535."
  }
}

variable "statement_port" {
  type        = number
  description = "Statement application port."
  default     = 9093
  validation {
    condition     = var.statement_port >= 1 && var.statement_port <= 65535
    error_message = "statement_port must be between 1 and 65535."
  }
}

variable "desired_capacity" {
  type        = number
  description = "Desired capacity for each Auto Scaling Group."
  default     = 1
  validation {
    condition     = var.desired_capacity >= 1 && var.desired_capacity <= 10
    error_message = "desired_capacity must be between 1 and 10."
  }
}

variable "minimum_capacity" {
  type        = number
  description = "Minimum capacity for each Auto Scaling Group."
  default     = 1
  validation {
    condition     = var.minimum_capacity >= 1 && var.minimum_capacity <= var.desired_capacity
    error_message = "minimum_capacity must be between 1 and desired_capacity."
  }
}

variable "maximum_capacity" {
  type        = number
  description = "Maximum capacity for each Auto Scaling Group."
  default     = 4
  validation {
    condition     = var.maximum_capacity >= var.minimum_capacity && var.maximum_capacity <= 10
    error_message = "maximum_capacity must be between minimum_capacity and 10."
  }
}

variable "restrict_s3_to_vpc_endpoints" {
  type        = bool
  description = "Restrict S3 bucket access to the configured VPC endpoints."
  default     = false
}

variable "manage_existing_iam_role" {
  type        = bool
  description = "If true, use an existing IAM role instead of creating a new one."
  default     = false
}

variable "manage_existing_bucket_policy" {
  type        = bool
  description = "If true, do not manage the bucket policy in Terraform."
  default     = false
}

variable "additional_tags" {
  type        = map(string)
  description = "Additional tags to apply globally."
  default     = {}
}

variable "existing_iam_role_arn" {
  type        = string
  description = "ARN of an existing IAM role to use when manage_existing_iam_role is true."
  default     = "arn:aws:iam::541341196654:role/ssm-role-for-ec2"
}

variable "public_alb_subnet_cidrs" {
  type = list(object({
    cidr = string
    az   = string
  }))
  description = "Public ALB subnet definitions for the customer-profile VPC."
  default = [
    {
      cidr = "10.1.1.0/24"
      az   = "us-east-1a"
    },
    {
      cidr = "10.1.2.0/24"
      az   = "us-east-1b"
    }
  ]
}

variable "customer_private_subnet_cidrs" {
  type = list(object({
    cidr = string
    az   = string
  }))
  description = "Private application subnet definitions for the customer-profile VPC."
  default = [
    {
      cidr = "10.1.11.0/24"
      az   = "us-east-1a"
    },
    {
      cidr = "10.1.12.0/24"
      az   = "us-east-1b"
    }
  ]
}

variable "account_private_alb_subnet_cidrs" {
  type = list(object({
    cidr = string
    az   = string
  }))
  description = "Private ALB subnet definitions for the account VPC."
  default = [
    {
      cidr = "10.2.1.0/24"
      az   = "us-east-1a"
    },
    {
      cidr = "10.2.2.0/24"
      az   = "us-east-1b"
    }
  ]
}

variable "account_private_app_subnet_cidrs" {
  type = list(object({
    cidr = string
    az   = string
  }))
  description = "Private application subnet definitions for the account VPC."
  default = [
    {
      cidr = "10.2.11.0/24"
      az   = "us-east-1a"
    },
    {
      cidr = "10.2.12.0/24"
      az   = "us-east-1b"
    }
  ]
}

variable "statement_private_alb_subnet_cidrs" {
  type = list(object({
    cidr = string
    az   = string
  }))
  description = "Private ALB subnet definitions for the statement VPC."
  default = [
    {
      cidr = "10.3.1.0/24"
      az   = "us-east-1a"
    },
    {
      cidr = "10.3.2.0/24"
      az   = "us-east-1b"
    }
  ]
}

variable "statement_private_app_subnet_cidrs" {
  type = list(object({
    cidr = string
    az   = string
  }))
  description = "Private application subnet definitions for the statement VPC."
  default = [
    {
      cidr = "10.3.11.0/24"
      az   = "us-east-1a"
    },
    {
      cidr = "10.3.12.0/24"
      az   = "us-east-1b"
    }
  ]
}
