output "customer_profile_alb_dns_name" {
  value = aws_lb.customer_profile.dns_name
}

output "customer_profile_alb_zone_id" {
  value = aws_lb.customer_profile.zone_id
}

output "customer_target_group_arn" {
  value = aws_lb_target_group.customer_profile.arn
}

output "account_alb_dns_name" {
  value = aws_lb.account.dns_name
}

output "account_alb_zone_id" {
  value = aws_lb.account.zone_id
}

output "account_target_group_arn" {
  value = aws_lb_target_group.account.arn
}

output "statement_alb_dns_name" {
  value = aws_lb.statement.dns_name
}

output "statement_alb_zone_id" {
  value = aws_lb.statement.zone_id
}

output "statement_target_group_arn" {
  value = aws_lb_target_group.statement.arn
}
