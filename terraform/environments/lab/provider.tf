provider "aws" {
  region  = var.aws_region
  profile = "lwinkoko"

  default_tags {
    tags = merge(
      {
        Project     = var.project_name
        Environment = var.environment
        ManagedBy   = "Terraform"
        Owner       = "CloudPractix"
      },
      var.additional_tags
    )
  }
}
