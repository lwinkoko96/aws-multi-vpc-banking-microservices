output "endpoint_ids" {
  value = concat(
    aws_vpc_endpoint.customer_ssm.*.id,
    aws_vpc_endpoint.customer_ssmmessages.*.id,
    aws_vpc_endpoint.customer_ec2messages.*.id,
    aws_vpc_endpoint.account_ssm.*.id,
    aws_vpc_endpoint.account_ssmmessages.*.id,
    aws_vpc_endpoint.account_ec2messages.*.id,
    aws_vpc_endpoint.statement_ssm.*.id,
    aws_vpc_endpoint.statement_ssmmessages.*.id,
    aws_vpc_endpoint.statement_ec2messages.*.id,
  )
}
