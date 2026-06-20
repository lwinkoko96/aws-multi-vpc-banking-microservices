data "aws_route53_zone" "public" {
  zone_id = var.public_hosted_zone_id
}

resource "aws_route53_zone" "internal" {
  name = var.internal_domain_name
  vpc {
    vpc_id = var.customer_vpc_id
  }
  vpc {
    vpc_id = var.account_vpc_id
  }
  vpc {
    vpc_id = var.statement_vpc_id
  }

  tags = merge(var.project_tags, {
    Name = "internal.${var.internal_domain_name}"
  })
}

resource "aws_route53_record" "customer_profile_public" {
  zone_id = data.aws_route53_zone.public.zone_id
  name    = var.public_service_domain
  type    = "A"

  alias {
    name                   = var.customer_alb_dns_name
    zone_id                = var.customer_alb_zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "account_private" {
  zone_id = aws_route53_zone.internal.zone_id
  name    = "account.${var.internal_domain_name}"
  type    = "A"

  alias {
    name                   = var.account_alb_dns_name
    zone_id                = var.account_alb_zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "statement_private" {
  zone_id = aws_route53_zone.internal.zone_id
  name    = "statement.${var.internal_domain_name}"
  type    = "A"

  alias {
    name                   = var.statement_alb_dns_name
    zone_id                = var.statement_alb_zone_id
    evaluate_target_health = true
  }
}
