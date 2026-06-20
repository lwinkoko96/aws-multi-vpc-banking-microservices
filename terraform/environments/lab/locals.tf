locals {
  project_tag = {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "Terraform"
    Owner       = "CloudPractix"
  }

  customer_profile_vpc = {
    name = "customer-profile-vpc"
    cidr = "10.1.0.0/16"
  }

  account_vpc = {
    name = "account-vpc"
    cidr = "10.2.0.0/16"
  }

  statement_vpc = {
    name = "statement-vpc"
    cidr = "10.3.0.0/16"
  }

  s3_binary_s3_path = "s3://${var.package_bucket_name}/${var.fake_service_object_key}"

  service_user_data = {
    customer = {
      service_name         = "customer-profile"
      service_port         = var.customer_profile_port
      service_display_name = "customer-profile-svc"
      service_message      = "HelloCloudBank - Retail Banking - customer-profile-svc"
      upstream_uris        = "http://account.internal.${var.domain_name}"
    }
    account = {
      service_name         = "account"
      service_port         = var.account_port
      service_display_name = "account-svc"
      service_message      = "HelloCloudBank - Retail Banking - account-svc"
      upstream_uris        = "http://statement.internal.${var.domain_name}"
    }
    statement = {
      service_name         = "statement"
      service_port         = var.statement_port
      service_display_name = "statement-svc"
      service_message      = "HelloCloudBank - Retail Banking - statement-svc"
      upstream_uris        = ""
    }
  }
}
