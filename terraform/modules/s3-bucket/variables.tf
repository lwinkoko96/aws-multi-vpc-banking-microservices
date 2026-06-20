variable "bucket_name" {
  type        = string
  description = "Name of the S3 bucket to create."
}

variable "object_key" {
  type        = string
  description = "Object key used by the fake service binary in S3."
}

variable "role_arn" {
  type        = string
  description = "IAM role ARN allowed to read the object."
}

variable "manage_existing_bucket_policy" {
  type        = bool
  description = "If true, do not create the bucket policy."
  default     = false
}

variable "project_tags" {
  type        = map(string)
  description = "Tags to assign to the S3 bucket."
  default     = {}
}

variable "restrict_s3_to_vpc_endpoints" {
  type        = bool
  description = "If true, restrict bucket access to provided VPC endpoint IDs."
  default     = false
}

variable "source_vpce_ids" {
  type        = list(string)
  description = "VPC endpoint IDs allowed by the bucket policy condition."
  default     = []
}

variable "source_file_path" {
  type        = string
  description = "Local file path to the fake-service binary to upload to S3."
  default     = ""
}
