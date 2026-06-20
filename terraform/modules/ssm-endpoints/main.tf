resource "aws_security_group" "customer_ssm" {
  count       = var.enable_ssm_endpoints ? 1 : 0
  name        = "customer-ssm-endpoint-sg"
  description = "Allow customer profile instances to connect to SSM interface endpoints."
  vpc_id      = var.customer_vpc_id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = var.customer_private_cidrs
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.project_tags, {
    Name = "customer-ssm-endpoint-sg"
  })
}

resource "aws_security_group" "account_ssm" {
  count       = var.enable_ssm_endpoints ? 1 : 0
  name        = "account-ssm-endpoint-sg"
  description = "Allow account instances to connect to SSM interface endpoints."
  vpc_id      = var.account_vpc_id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = var.account_private_cidrs
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.project_tags, {
    Name = "account-ssm-endpoint-sg"
  })
}

resource "aws_security_group" "statement_ssm" {
  count       = var.enable_ssm_endpoints ? 1 : 0
  name        = "statement-ssm-endpoint-sg"
  description = "Allow statement instances to connect to SSM interface endpoints."
  vpc_id      = var.statement_vpc_id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = var.statement_private_cidrs
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.project_tags, {
    Name = "statement-ssm-endpoint-sg"
  })
}

resource "aws_vpc_endpoint" "customer_ssm" {
  count             = var.enable_ssm_endpoints ? 1 : 0
  vpc_id            = var.customer_vpc_id
  service_name      = "com.amazonaws.${var.region}.ssm"
  vpc_endpoint_type = "Interface"
  subnet_ids        = var.customer_private_subnet_ids
  security_group_ids = [aws_security_group.customer_ssm[0].id]
  private_dns_enabled = true

  tags = merge(var.project_tags, {
    Name = "customer-ssm-endpoint"
  })
}

resource "aws_vpc_endpoint" "customer_ssmmessages" {
  count             = var.enable_ssm_endpoints ? 1 : 0
  vpc_id            = var.customer_vpc_id
  service_name      = "com.amazonaws.${var.region}.ssmmessages"
  vpc_endpoint_type = "Interface"
  subnet_ids        = var.customer_private_subnet_ids
  security_group_ids = [aws_security_group.customer_ssm[0].id]
  private_dns_enabled = true

  tags = merge(var.project_tags, {
    Name = "customer-ssmmessages-endpoint"
  })
}

resource "aws_vpc_endpoint" "customer_ec2messages" {
  count             = var.enable_ssm_endpoints ? 1 : 0
  vpc_id            = var.customer_vpc_id
  service_name      = "com.amazonaws.${var.region}.ec2messages"
  vpc_endpoint_type = "Interface"
  subnet_ids        = var.customer_private_subnet_ids
  security_group_ids = [aws_security_group.customer_ssm[0].id]
  private_dns_enabled = true

  tags = merge(var.project_tags, {
    Name = "customer-ec2messages-endpoint"
  })
}

resource "aws_vpc_endpoint" "account_ssm" {
  count             = var.enable_ssm_endpoints ? 1 : 0
  vpc_id            = var.account_vpc_id
  service_name      = "com.amazonaws.${var.region}.ssm"
  vpc_endpoint_type = "Interface"
  subnet_ids        = var.account_private_subnet_ids
  security_group_ids = [aws_security_group.account_ssm[0].id]
  private_dns_enabled = true

  tags = merge(var.project_tags, {
    Name = "account-ssm-endpoint"
  })
}

resource "aws_vpc_endpoint" "account_ssmmessages" {
  count             = var.enable_ssm_endpoints ? 1 : 0
  vpc_id            = var.account_vpc_id
  service_name      = "com.amazonaws.${var.region}.ssmmessages"
  vpc_endpoint_type = "Interface"
  subnet_ids        = var.account_private_subnet_ids
  security_group_ids = [aws_security_group.account_ssm[0].id]
  private_dns_enabled = true

  tags = merge(var.project_tags, {
    Name = "account-ssmmessages-endpoint"
  })
}

resource "aws_vpc_endpoint" "account_ec2messages" {
  count             = var.enable_ssm_endpoints ? 1 : 0
  vpc_id            = var.account_vpc_id
  service_name      = "com.amazonaws.${var.region}.ec2messages"
  vpc_endpoint_type = "Interface"
  subnet_ids        = var.account_private_subnet_ids
  security_group_ids = [aws_security_group.account_ssm[0].id]
  private_dns_enabled = true

  tags = merge(var.project_tags, {
    Name = "account-ec2messages-endpoint"
  })
}

resource "aws_vpc_endpoint" "statement_ssm" {
  count             = var.enable_ssm_endpoints ? 1 : 0
  vpc_id            = var.statement_vpc_id
  service_name      = "com.amazonaws.${var.region}.ssm"
  vpc_endpoint_type = "Interface"
  subnet_ids        = var.statement_private_subnet_ids
  security_group_ids = [aws_security_group.statement_ssm[0].id]
  private_dns_enabled = true

  tags = merge(var.project_tags, {
    Name = "statement-ssm-endpoint"
  })
}

resource "aws_vpc_endpoint" "statement_ssmmessages" {
  count             = var.enable_ssm_endpoints ? 1 : 0
  vpc_id            = var.statement_vpc_id
  service_name      = "com.amazonaws.${var.region}.ssmmessages"
  vpc_endpoint_type = "Interface"
  subnet_ids        = var.statement_private_subnet_ids
  security_group_ids = [aws_security_group.statement_ssm[0].id]
  private_dns_enabled = true

  tags = merge(var.project_tags, {
    Name = "statement-ssmmessages-endpoint"
  })
}

resource "aws_vpc_endpoint" "statement_ec2messages" {
  count             = var.enable_ssm_endpoints ? 1 : 0
  vpc_id            = var.statement_vpc_id
  service_name      = "com.amazonaws.${var.region}.ec2messages"
  vpc_endpoint_type = "Interface"
  subnet_ids        = var.statement_private_subnet_ids
  security_group_ids = [aws_security_group.statement_ssm[0].id]
  private_dns_enabled = true

  tags = merge(var.project_tags, {
    Name = "statement-ec2messages-endpoint"
  })
}
