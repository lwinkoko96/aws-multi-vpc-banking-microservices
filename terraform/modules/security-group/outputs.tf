output "ids" {
  value = [
    aws_security_group.customer_profile_alb.id,
    aws_security_group.customer_profile_ec2.id,
    aws_security_group.account_alb.id,
    aws_security_group.account_ec2.id,
    aws_security_group.statement_alb.id,
    aws_security_group.statement_ec2.id,
  ]
}

output "customer_alb_sg_id" {
  value = aws_security_group.customer_profile_alb.id
}

output "customer_ec2_sg_id" {
  value = aws_security_group.customer_profile_ec2.id
}

output "account_alb_sg_id" {
  value = aws_security_group.account_alb.id
}

output "account_ec2_sg_id" {
  value = aws_security_group.account_ec2.id
}

output "statement_alb_sg_id" {
  value = aws_security_group.statement_alb.id
}

output "statement_ec2_sg_id" {
  value = aws_security_group.statement_ec2.id
}
