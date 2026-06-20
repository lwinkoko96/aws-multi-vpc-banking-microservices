resource "aws_security_group" "customer_profile_alb" {
  name        = "${var.project_name}-${var.environment}-customer-profile-alb"
  description = "Security group for the customer profile public ALB"
  vpc_id      = var.customer_vpc_id

  ingress {
    description = "Allow HTTP from the internet"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow HTTPS from the internet"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow outbound traffic from the public ALB"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.project_tags, {
    Name = "customer-profile-alb"
  })
}

resource "aws_security_group" "account_alb" {
  name        = "${var.project_name}-${var.environment}-account-internal-alb"
  description = "Security group for the account internal ALB"
  vpc_id      = var.account_vpc_id

  ingress {
    description = "Allow HTTP from the customer VPC private CIDRs"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = var.customer_private_cidrs
  }

  egress {
    description = "Allow outbound traffic from the account internal ALB"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.project_tags, {
    Name = "account-internal-alb"
  })
}

resource "aws_security_group" "statement_alb" {
  name        = "${var.project_name}-${var.environment}-statement-internal-alb"
  description = "Security group for the statement internal ALB"
  vpc_id      = var.statement_vpc_id

  ingress {
    description = "Allow HTTP from the account VPC private CIDRs"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = var.account_private_cidrs
  }

  egress {
    description = "Allow outbound traffic from the statement internal ALB"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.project_tags, {
    Name = "statement-internal-alb"
  })
}

resource "aws_security_group" "customer_profile_ec2" {
  name        = "${var.project_name}-${var.environment}-customer-profile-ec2"
  description = "Security group for the customer profile EC2 instances"
  vpc_id      = var.customer_vpc_id

  ingress {
    description     = "Allow ALB traffic to customer profile service"
    from_port       = 9091
    to_port         = 9091
    protocol        = "tcp"
    security_groups = [aws_security_group.customer_profile_alb.id]
  }
  egress {
    description = "Allow outbound traffic from the customer profile EC2 instances"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.project_tags, {
    Name = "customer-profile-ec2"
  })
}
resource "aws_security_group" "account_ec2" {
  name        = "${var.project_name}-${var.environment}-account-ec2"
  description = "Security group for the account service EC2 instances"
  vpc_id      = var.account_vpc_id

  ingress {
    description     = "Allow ALB traffic to account service"
    from_port       = 9092
    to_port         = 9092
    protocol        = "tcp"
    security_groups = [aws_security_group.account_alb.id]
  }
  egress {
    description = "Allow outbound traffic from the account EC2 instances"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.project_tags, {
    Name = "account-ec2"
  })
}

resource "aws_security_group" "statement_ec2" {
  name        = "${var.project_name}-${var.environment}-statement-ec2"
  description = "Security group for the statement service EC2 instances"
  vpc_id      = var.statement_vpc_id

  ingress {
    description     = "Allow ALB traffic to statement service"
    from_port       = 9093
    to_port         = 9093
    protocol        = "tcp"
    security_groups = [aws_security_group.statement_alb.id]
  }

    egress {
    description = "Allow outbound traffic from the statement EC2 instances"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    }
  tags = merge(var.project_tags, {
    Name = "statement-ec2"
  })
}
