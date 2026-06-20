variable "region" {
  type = string
}

variable "project_tags" {
  type = map(string)
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

variable "customer_account_routes" {
  type = list(string)
}

variable "account_customer_routes" {
  type = list(string)
}

variable "account_statement_routes" {
  type = list(string)
}

variable "statement_account_routes" {
  type = list(string)
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
