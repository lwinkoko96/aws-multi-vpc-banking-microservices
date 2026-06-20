resource "aws_vpc_endpoint" "customer_s3" {
  vpc_id            = var.customer_vpc_id
  service_name      = "com.amazonaws.${var.region}.s3"
  vpc_endpoint_type = "Gateway"
  route_table_ids   = var.customer_private_route_table_ids

  tags = merge(var.project_tags, {
    Name = "customer-profile-s3-endpoint"
  })
}

resource "aws_vpc_endpoint" "account_s3" {
  vpc_id            = var.account_vpc_id
  service_name      = "com.amazonaws.${var.region}.s3"
  vpc_endpoint_type = "Gateway"
  route_table_ids   = var.account_private_route_table_ids

  tags = merge(var.project_tags, {
    Name = "account-s3-endpoint"
  })
}

resource "aws_vpc_endpoint" "statement_s3" {
  vpc_id            = var.statement_vpc_id
  service_name      = "com.amazonaws.${var.region}.s3"
  vpc_endpoint_type = "Gateway"
  route_table_ids   = var.statement_private_route_table_ids

  tags = merge(var.project_tags, {
    Name = "statement-s3-endpoint"
  })
}
