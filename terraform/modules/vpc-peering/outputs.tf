output "peering_connection_ids" {
  value = [
    aws_vpc_peering_connection.customer_account.id,
    aws_vpc_peering_connection.account_statement.id,
  ]
}
