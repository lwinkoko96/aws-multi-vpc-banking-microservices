resource "aws_vpc_peering_connection" "customer_account" {
  vpc_id        = var.customer_vpc_id
  peer_vpc_id   = var.account_vpc_id
  auto_accept   = false
  peer_region   = var.region

  tags = merge(var.project_tags, {
    Name = "customer-account-peering"
  })
}

resource "aws_vpc_peering_connection_accepter" "customer_account" {
  vpc_peering_connection_id = aws_vpc_peering_connection.customer_account.id
  auto_accept               = true
  accepter {
    allow_remote_vpc_dns_resolution = true
  }
  requester {
    allow_remote_vpc_dns_resolution = true
  }
}

resource "aws_vpc_peering_connection" "account_statement" {
  vpc_id      = var.account_vpc_id
  peer_vpc_id = var.statement_vpc_id
  auto_accept = false
  peer_region = var.region

  tags = merge(var.project_tags, {
    Name = "account-statement-peering"
  })
}

resource "aws_vpc_peering_connection_accepter" "account_statement" {
  vpc_peering_connection_id = aws_vpc_peering_connection.account_statement.id
  auto_accept               = true
  accepter {
    allow_remote_vpc_dns_resolution = true
  }
  requester {
    allow_remote_vpc_dns_resolution = true
  }
}

resource "aws_route" "customer_profile_to_account" {
  route_table_id            = var.customer_private_route_table_ids[0]
  destination_cidr_block    = var.customer_account_routes[0]
  vpc_peering_connection_id = aws_vpc_peering_connection.customer_account.id
}

resource "aws_route" "account_to_customer" {
  route_table_id            = var.account_private_route_table_ids[0]
  destination_cidr_block    = var.account_customer_routes[0]
  vpc_peering_connection_id = aws_vpc_peering_connection.customer_account.id
}

resource "aws_route" "account_to_statement" {
  route_table_id            = var.account_private_route_table_ids[0]
  destination_cidr_block    = var.account_statement_routes[0]
  vpc_peering_connection_id = aws_vpc_peering_connection.account_statement.id
}

resource "aws_route" "statement_to_account" {
  route_table_id            = var.statement_private_route_table_ids[0]
  destination_cidr_block    = var.statement_account_routes[0]
  vpc_peering_connection_id = aws_vpc_peering_connection.account_statement.id
}
