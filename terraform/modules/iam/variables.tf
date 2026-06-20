variable "project_tags" {
  type        = map(string)
  description = "Tags applied to IAM resources."
}

variable "manage_existing_role" {
  type        = bool
  description = "If true, use an existing IAM role instead of creating a new one."
}

variable "existing_role_arn" {
  type        = string
  description = "ARN of an existing IAM role used when manage_existing_role is true."
}

variable "package_bucket_name" {
  type        = string
  description = "S3 bucket name for the fake service package."
}

variable "fake_service_object_key" {
  type        = string
  description = "S3 object key for the fake service binary."
}
