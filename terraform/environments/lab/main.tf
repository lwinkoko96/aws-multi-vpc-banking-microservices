locals {
  existing_iam_role_arn = "arn:aws:iam::541341196654:role/ssm-role-for-ec2"
}

module "vpc" {
  source = "../../modules/vpc"

  region                    = var.aws_region
  project_name              = var.project_name
  environment               = var.environment
  customer_profile_vpc_cidr = local.customer_profile_vpc.cidr
  account_vpc_cidr          = local.account_vpc.cidr
  statement_vpc_cidr        = local.statement_vpc.cidr
  customer_public_subnets   = var.public_alb_subnet_cidrs
  customer_private_subnets  = var.customer_private_subnet_cidrs
  account_alb_subnets       = var.account_private_alb_subnet_cidrs
  account_private_subnets   = var.account_private_app_subnet_cidrs
  statement_alb_subnets     = var.statement_private_alb_subnet_cidrs
  statement_private_subnets = var.statement_private_app_subnet_cidrs
  project_tags              = local.project_tag
}

module "vpc_peering" {
  source = "../../modules/vpc-peering"

  region                            = var.aws_region
  project_tags                      = local.project_tag
  customer_vpc_id                   = module.vpc.customer_vpc_id
  account_vpc_id                    = module.vpc.account_vpc_id
  statement_vpc_id                  = module.vpc.statement_vpc_id
  customer_account_routes           = ["10.2.0.0/16"]
  account_customer_routes           = ["10.1.0.0/16"]
  account_statement_routes          = ["10.3.0.0/16"]
  statement_account_routes          = ["10.2.0.0/16"]
  customer_private_route_table_ids  = module.vpc.customer_private_route_table_ids
  account_private_route_table_ids   = module.vpc.account_private_route_table_ids
  statement_private_route_table_ids = module.vpc.statement_private_route_table_ids
}

module "security_group" {
  source = "../../modules/security-group"

  project_name            = var.project_name
  environment             = var.environment
  customer_vpc_id         = module.vpc.customer_vpc_id
  account_vpc_id          = module.vpc.account_vpc_id
  statement_vpc_id        = module.vpc.statement_vpc_id
  customer_private_cidrs  = [for s in var.customer_private_subnet_cidrs : s.cidr]
  account_private_cidrs   = [for s in var.account_private_app_subnet_cidrs : s.cidr]
  statement_private_cidrs = [for s in var.statement_private_app_subnet_cidrs : s.cidr]
  project_tags            = local.project_tag
}

module "iam" {
  source = "../../modules/iam"

  project_tags            = local.project_tag
  manage_existing_role    = var.manage_existing_iam_role
  existing_role_arn       = local.existing_iam_role_arn
  package_bucket_name     = var.package_bucket_name
  fake_service_object_key = var.fake_service_object_key
}

module "s3_endpoint" {
  source = "../../modules/s3-endpoint"

  region                            = var.aws_region
  project_tags                      = local.project_tag
  customer_vpc_id                   = module.vpc.customer_vpc_id
  account_vpc_id                    = module.vpc.account_vpc_id
  statement_vpc_id                  = module.vpc.statement_vpc_id
  customer_private_route_table_ids  = module.vpc.customer_private_route_table_ids
  account_private_route_table_ids   = module.vpc.account_private_route_table_ids
  statement_private_route_table_ids = module.vpc.statement_private_route_table_ids
}

module "alb" {
  source = "../../modules/alb"

  project_name                 = var.project_name
  environment                  = var.environment
  customer_vpc_id              = module.vpc.customer_vpc_id
  account_vpc_id               = module.vpc.account_vpc_id
  statement_vpc_id             = module.vpc.statement_vpc_id
  customer_public_subnet_ids   = module.vpc.customer_public_subnet_ids
  account_private_subnet_ids   = module.vpc.account_private_subnet_ids
  statement_private_subnet_ids = module.vpc.statement_private_subnet_ids
  customer_alb_sg_id           = module.security_group.customer_alb_sg_id
  account_alb_sg_id            = module.security_group.account_alb_sg_id
  statement_alb_sg_id          = module.security_group.statement_alb_sg_id
  certificate_arn              = module.acm.certificate_arn
  project_tags                 = local.project_tag
}

module "acm" {
  source = "../../modules/acm"

  project_name          = var.project_name
  environment           = var.environment
  region                = var.aws_region
  public_service_domain = var.public_service_domain
  hosted_zone_id        = data.aws_route53_zone.public.zone_id
  project_tags          = local.project_tag
}

module "route53" {
  source = "../../modules/route53"

  project_name           = var.project_name
  environment            = var.environment
  domain_name            = var.domain_name
  public_service_domain  = var.public_service_domain
  internal_domain_name   = var.internal_domain_name
  customer_alb_dns_name  = module.alb.customer_profile_alb_dns_name
  customer_alb_zone_id   = module.alb.customer_profile_alb_zone_id
  account_alb_dns_name   = module.alb.account_alb_dns_name
  account_alb_zone_id    = module.alb.account_alb_zone_id
  statement_alb_dns_name = module.alb.statement_alb_dns_name
  statement_alb_zone_id  = module.alb.statement_alb_zone_id
  public_hosted_zone_id  = data.aws_route53_zone.public.zone_id
  customer_vpc_id        = module.vpc.customer_vpc_id
  account_vpc_id         = module.vpc.account_vpc_id
  statement_vpc_id       = module.vpc.statement_vpc_id
  project_tags           = local.project_tag
}

module "autoscaling" {
  source = "../../modules/autoscaling"

  project_name                 = var.project_name
  environment                  = var.environment
  customer_private_subnet_ids  = module.vpc.customer_private_subnet_ids
  account_private_subnet_ids   = module.vpc.account_private_subnet_ids
  statement_private_subnet_ids = module.vpc.statement_private_subnet_ids
  customer_ec2_sg_id           = module.security_group.customer_ec2_sg_id
  account_ec2_sg_id            = module.security_group.account_ec2_sg_id
  statement_ec2_sg_id          = module.security_group.statement_ec2_sg_id
  customer_alb_tg_arn          = module.alb.customer_target_group_arn
  account_alb_tg_arn           = module.alb.account_target_group_arn
  statement_alb_tg_arn         = module.alb.statement_target_group_arn
  iam_instance_profile_name    = module.iam.instance_profile_name
  package_bucket_name          = var.package_bucket_name
  fake_service_object_key      = var.fake_service_object_key
  customer_service_port        = var.customer_profile_port
  account_service_port         = var.account_port
  statement_service_port       = var.statement_port
  desired_capacity             = var.desired_capacity
  minimum_capacity             = var.minimum_capacity
  maximum_capacity             = var.maximum_capacity
  instance_type                = var.instance_type
  project_tags                 = local.project_tag
  customer_user_data_template = templatefile("${path.module}/templates/customer-profile-user-data.sh", {
    service_name         = local.service_user_data.customer.service_name
    service_port         = local.service_user_data.customer.service_port
    service_user         = "ec2-user"
    s3_binary_path       = local.s3_binary_s3_path
    install_path         = "/usr/local/bin/fake-service"
    service_display_name = local.service_user_data.customer.service_display_name
    service_message      = local.service_user_data.customer.service_message
    upstream_uris        = local.service_user_data.customer.upstream_uris
  })
  account_user_data_template = templatefile("${path.module}/templates/account-user-data.sh", {
    service_name         = local.service_user_data.account.service_name
    service_port         = local.service_user_data.account.service_port
    service_user         = "ec2-user"
    s3_binary_path       = local.s3_binary_s3_path
    install_path         = "/usr/local/bin/fake-service"
    service_display_name = local.service_user_data.account.service_display_name
    service_message      = local.service_user_data.account.service_message
    upstream_uris        = local.service_user_data.account.upstream_uris
  })
  statement_user_data_template = templatefile("${path.module}/templates/statement-user-data.sh", {
    service_name         = local.service_user_data.statement.service_name
    service_port         = local.service_user_data.statement.service_port
    service_user         = "ec2-user"
    s3_binary_path       = local.s3_binary_s3_path
    install_path         = "/usr/local/bin/fake-service"
    service_display_name = local.service_user_data.statement.service_display_name
    service_message      = local.service_user_data.statement.service_message
    upstream_uris        = local.service_user_data.statement.upstream_uris
  })
}

module "s3_bucket" {
  source = "../../modules/s3-bucket"

  bucket_name                   = var.package_bucket_name
  object_key                    = var.fake_service_object_key
  role_arn                      = local.existing_iam_role_arn
  manage_existing_bucket_policy = var.manage_existing_bucket_policy
  project_tags                  = local.project_tag
  restrict_s3_to_vpc_endpoints  = var.restrict_s3_to_vpc_endpoints
  source_vpce_ids = [
    module.s3_endpoint.customer_s3_endpoint_id,
    module.s3_endpoint.account_s3_endpoint_id,
    module.s3_endpoint.statement_s3_endpoint_id,
  ]
  source_file_path = abspath("${path.module}/../../fake-service")
}

data "aws_route53_zone" "public" {
  name         = var.domain_name
  private_zone = false
}
