variable "project_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "region" {
  type = string
}

variable "public_service_domain" {
  type = string
}

variable "hosted_zone_id" {
  type = string
}

variable "project_tags" {
  type = map(string)
}
