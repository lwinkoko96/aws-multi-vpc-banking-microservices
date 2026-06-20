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

variable "customer_public_subnet_ids" {
  type = list(string)
}

variable "account_private_subnet_ids" {
  type = list(string)
}

variable "statement_private_subnet_ids" {
  type = list(string)
}

variable "customer_alb_sg_id" {
  type = string
}

variable "account_alb_sg_id" {
  type = string
}

variable "statement_alb_sg_id" {
  type = string
}

variable "certificate_arn" {
  type = string
}

variable "project_tags" {
  type = map(string)
}
