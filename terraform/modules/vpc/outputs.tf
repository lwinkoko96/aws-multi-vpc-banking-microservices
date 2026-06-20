output "customer_vpc_id" {
  value = aws_vpc.customer_profile.id
}

output "account_vpc_id" {
  value = aws_vpc.account.id
}

output "statement_vpc_id" {
  value = aws_vpc.statement.id
}

output "customer_public_subnet_ids" {
  value = [for s in aws_subnet.customer_profile_public : s.id]
}

output "customer_private_subnet_ids" {
  value = [for s in aws_subnet.customer_profile_private : s.id]
}

output "account_private_subnet_ids" {
  value = [for s in aws_subnet.account_private : s.id]
}

output "statement_private_subnet_ids" {
  value = [for s in aws_subnet.statement_private : s.id]
}

output "customer_route_table_ids" {
  value = [aws_route_table.customer_profile_public.id, aws_route_table.customer_profile_private.id]
}

output "account_route_table_ids" {
  value = [aws_route_table.account_private.id]
}

output "statement_route_table_ids" {
  value = [aws_route_table.statement_private.id]
}

output "customer_private_route_table_ids" {
  value = [aws_route_table.customer_profile_private.id]
}

output "account_private_route_table_ids" {
  value = [aws_route_table.account_private.id]
}

output "statement_private_route_table_ids" {
  value = [aws_route_table.statement_private.id]
}
