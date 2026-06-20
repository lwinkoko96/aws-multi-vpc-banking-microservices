variable "project_tags" {
  type = map(string)
}

variable "region" {
  type        = string
  description = "AWS region for the S3 gateway VPC endpoints."
}

variable "customer_vpc_id" {
  type = string
}

variable "account_vpc_id" {
  type = string
}

variable "statement_vpc_id" {
  type = string
}

variable "customer_private_route_table_ids" {
  type = list(string)
}

variable "account_private_route_table_ids" {
  type = list(string)
}

variable "statement_private_route_table_ids" {
  type = list(string)
}
