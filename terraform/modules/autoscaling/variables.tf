variable "project_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "customer_private_subnet_ids" {
  type = list(string)
}

variable "account_private_subnet_ids" {
  type = list(string)
}

variable "statement_private_subnet_ids" {
  type = list(string)
}

variable "customer_ec2_sg_id" {
  type = string
}

variable "account_ec2_sg_id" {
  type = string
}

variable "statement_ec2_sg_id" {
  type = string
}

variable "customer_alb_tg_arn" {
  type = string
}

variable "account_alb_tg_arn" {
  type = string
}

variable "statement_alb_tg_arn" {
  type = string
}

variable "iam_instance_profile_name" {
  type = string
}

variable "package_bucket_name" {
  type = string
}

variable "fake_service_object_key" {
  type = string
}

variable "customer_service_port" {
  type = number
}

variable "account_service_port" {
  type = number
}

variable "statement_service_port" {
  type = number
}

variable "desired_capacity" {
  type = number
}

variable "minimum_capacity" {
  type = number
}

variable "maximum_capacity" {
  type = number
}

variable "instance_type" {
  type = string
}

variable "project_tags" {
  type = map(string)
}

variable "customer_user_data_template" {
  type = string
}

variable "account_user_data_template" {
  type = string
}

variable "statement_user_data_template" {
  type = string
}
