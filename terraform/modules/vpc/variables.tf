variable "region" {
  type        = string
  description = "AWS region for VPC resources."
}

variable "project_name" {
  type        = string
  description = "Project name used for tags and resource names."
}

variable "environment" {
  type        = string
  description = "Deployment environment used for tags and resource names."
}

variable "customer_profile_vpc_cidr" {
  type        = string
  description = "CIDR block for the customer-profile VPC."
}

variable "account_vpc_cidr" {
  type        = string
  description = "CIDR block for the account VPC."
}

variable "statement_vpc_cidr" {
  type        = string
  description = "CIDR block for the statement VPC."
}

variable "customer_public_subnets" {
  type = list(object({
    cidr = string
    az   = string
  }))
  description = "Public subnet CIDRs and availability zones for customer-profile ALB."
}

variable "customer_private_subnets" {
  type = list(object({
    cidr = string
    az   = string
  }))
  description = "Private application subnets for customer-profile VPC."
}

variable "account_alb_subnets" {
  type = list(object({
    cidr = string
    az   = string
  }))
  description = "Private ALB subnets for account VPC."
}

variable "account_private_subnets" {
  type = list(object({
    cidr = string
    az   = string
  }))
  description = "Private application subnets for account VPC."
}

variable "statement_alb_subnets" {
  type = list(object({
    cidr = string
    az   = string
  }))
  description = "Private ALB subnets for statement VPC."
}

variable "statement_private_subnets" {
  type = list(object({
    cidr = string
    az   = string
  }))
  description = "Private application subnets for statement VPC."
}

variable "project_tags" {
  type        = map(string)
  description = "Tags applied to all VPC resources."
}
