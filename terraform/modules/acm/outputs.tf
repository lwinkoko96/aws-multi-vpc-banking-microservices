output "certificate_arn" {
  value = aws_acm_certificate_validation.customer_profile.certificate_arn
}

output "certificate_domain_name" {
  value = aws_acm_certificate.customer_profile.domain_name
}
