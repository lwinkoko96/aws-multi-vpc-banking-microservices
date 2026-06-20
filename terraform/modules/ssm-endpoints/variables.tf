variable "region" {
  type        = string
  description = "AWS region for interface endpoint service names."
}

variable "project_tags" {
  type        = map(string)
}

variable "enable_ssm_endpoints" {
  type        = bool
}

variable "customer_vpc_id" {
  type        = string
}

variable "account_vpc_id" {
  type        = string
}

variable "statement_vpc_id" {
  type        = string
}

variable "customer_private_subnet_ids" {
  type        = list(string)
}

variable "account_private_subnet_ids" {
  type        = list(string)
}

variable "statement_private_subnet_ids" {
  type        = list(string)
}

variable "customer_private_cidrs" {
  type        = list(string)
}

variable "account_private_cidrs" {
  type        = list(string)
}

variable "statement_private_cidrs" {
  type        = list(string)
}
