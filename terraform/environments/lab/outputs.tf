output "customer_profile_url" {
  description = "Public URL for the customer-profile service."
  value       = module.route53.customer_profile_public_record_fqdn
}

output "customer_profile_alb_dns_name" {
  description = "DNS name for the customer-profile internet-facing ALB."
  value       = module.alb.customer_profile_alb_dns_name
}

output "account_internal_url" {
  description = "Private internal URL for the account service."
  value       = module.route53.account_private_record_fqdn
}

output "account_internal_alb_dns_name" {
  description = "DNS name for the account internal ALB."
  value       = module.alb.account_alb_dns_name
}

output "statement_internal_url" {
  description = "Private internal URL for the statement service."
  value       = module.route53.statement_private_record_fqdn
}

output "statement_internal_alb_dns_name" {
  description = "DNS name for the statement internal ALB."
  value       = module.alb.statement_alb_dns_name
}

output "customer_profile_vpc_id" {
  value = module.vpc.customer_vpc_id
}

output "account_vpc_id" {
  value = module.vpc.account_vpc_id
}

output "statement_vpc_id" {
  value = module.vpc.statement_vpc_id
}

output "public_subnet_ids" {
  value = module.vpc.customer_public_subnet_ids
}

output "private_subnet_ids" {
  value = concat(module.vpc.customer_private_subnet_ids, module.vpc.account_private_subnet_ids, module.vpc.statement_private_subnet_ids)
}

output "route_table_ids" {
  value = concat(module.vpc.customer_route_table_ids, module.vpc.account_route_table_ids, module.vpc.statement_route_table_ids)
}

output "vpc_peering_connection_ids" {
  value = module.vpc_peering.peering_connection_ids
}

output "security_group_ids" {
  value = module.security_group.ids
}

output "target_group_arns" {
  value = [
    module.alb.customer_target_group_arn,
    module.alb.account_target_group_arn,
    module.alb.statement_target_group_arn,
  ]
}

output "autoscaling_group_names" {
  value = module.autoscaling.asg_names
}

output "launch_template_ids" {
  value = module.autoscaling.launch_template_ids
}

output "iam_role_name" {
  value = module.iam.role_name
}

output "instance_profile_name" {
  value = module.iam.instance_profile_name
}

output "s3_gateway_endpoint_ids" {
  value = module.s3_endpoint.endpoint_ids
}

output "acm_certificate_arn" {
  value = module.acm.certificate_arn
}

output "route53_public_record" {
  value = module.route53.customer_profile_public_record_fqdn
}

output "route53_private_records" {
  value = {
    account   = module.route53.account_private_record_fqdn
    statement = module.route53.statement_private_record_fqdn
  }
}
