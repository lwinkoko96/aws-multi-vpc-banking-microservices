resource "aws_acm_certificate" "customer_profile" {
  domain_name       = var.public_service_domain
  validation_method = "DNS"
  lifecycle {
    create_before_destroy = true
  }

  tags = merge(var.project_tags, {
    Name = "customer-profile-cert"
  })
}

resource "aws_route53_record" "customer_profile_validation" {
  for_each = {
    for dvo in aws_acm_certificate.customer_profile.domain_validation_options : dvo.domain_name => dvo
  }

  zone_id = var.hosted_zone_id
  name    = each.value.resource_record_name
  type    = each.value.resource_record_type
  ttl     = 60
  records = [each.value.resource_record_value]
}

resource "aws_acm_certificate_validation" "customer_profile" {
  certificate_arn = aws_acm_certificate.customer_profile.arn

  validation_record_fqdns = [for record in aws_route53_record.customer_profile_validation : record.fqdn]
}
