variable "project_name" {
  type = string
}

variable "environment" {
  type = string
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

variable "customer_private_cidrs" {
  type = list(string)
}

variable "account_private_cidrs" {
  type = list(string)
}

variable "statement_private_cidrs" {
  type = list(string)
}

variable "project_tags" {
  type = map(string)
}
