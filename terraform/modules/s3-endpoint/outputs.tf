output "customer_s3_endpoint_id" {
  value = aws_vpc_endpoint.customer_s3.id
}

output "account_s3_endpoint_id" {
  value = aws_vpc_endpoint.account_s3.id
}

output "statement_s3_endpoint_id" {
  value = aws_vpc_endpoint.statement_s3.id
}

output "endpoint_ids" {
  value = [
    aws_vpc_endpoint.customer_s3.id,
    aws_vpc_endpoint.account_s3.id,
    aws_vpc_endpoint.statement_s3.id,
  ]
}
