variable "project_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "domain_name" {
  type = string
}

variable "public_service_domain" {
  type = string
}

variable "internal_domain_name" {
  type = string
}

variable "customer_alb_dns_name" {
  type = string
}

variable "customer_alb_zone_id" {
  type = string
}

variable "account_alb_dns_name" {
  type = string
}

variable "account_alb_zone_id" {
  type = string
}

variable "statement_alb_dns_name" {
  type = string
}

variable "statement_alb_zone_id" {
  type = string
}

variable "public_hosted_zone_id" {
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

variable "project_tags" {
  type = map(string)
}
