output "customer_profile_public_record_fqdn" {
  value = aws_route53_record.customer_profile_public.fqdn
}

output "account_private_record_fqdn" {
  value = aws_route53_record.account_private.fqdn
}

output "statement_private_record_fqdn" {
  value = aws_route53_record.statement_private.fqdn
}

output "internal_hosted_zone_id" {
  value = aws_route53_zone.internal.zone_id
}
