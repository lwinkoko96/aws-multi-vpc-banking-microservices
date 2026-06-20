resource "aws_vpc" "customer_profile" {
  cidr_block           = var.customer_profile_vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge(var.project_tags, {
    Name = "customer-profile-vpc"
  })
}

resource "aws_vpc" "account" {
  cidr_block           = var.account_vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge(var.project_tags, {
    Name = "account-vpc"
  })
}

resource "aws_vpc" "statement" {
  cidr_block           = var.statement_vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge(var.project_tags, {
    Name = "statement-vpc"
  })
}

resource "aws_internet_gateway" "customer_profile" {
  vpc_id = aws_vpc.customer_profile.id

  tags = merge(var.project_tags, {
    Name = "customer-profile-igw"
  })
}

resource "aws_subnet" "customer_profile_public" {
  for_each = { for idx, subnet in var.customer_public_subnets : "customer_public_${idx}" => subnet }

  vpc_id                  = aws_vpc.customer_profile.id
  cidr_block              = each.value.cidr
  availability_zone       = each.value.az
  map_public_ip_on_launch = true

  tags = merge(var.project_tags, {
    Name = "customer-profile-public-${each.key}"
    Tier = "public"
    Purpose = "ALB"
  })
}

resource "aws_subnet" "customer_profile_private" {
  for_each = { for idx, subnet in var.customer_private_subnets : "customer_private_${idx}" => subnet }

  vpc_id                  = aws_vpc.customer_profile.id
  cidr_block              = each.value.cidr
  availability_zone       = each.value.az
  map_public_ip_on_launch = false

  tags = merge(var.project_tags, {
    Name = "customer-profile-private-${each.key}"
    Tier = "private"
    Purpose = "AppService"
  })
}

resource "aws_route_table" "customer_profile_public" {
  vpc_id = aws_vpc.customer_profile.id

  tags = merge(var.project_tags, {
    Name = "customer-profile-public-rt"
  })
}

resource "aws_route_table" "customer_profile_private" {
  vpc_id = aws_vpc.customer_profile.id

  tags = merge(var.project_tags, {
    Name = "customer-profile-private-rt"
  })
}

resource "aws_route" "customer_profile_public_internet" {
  route_table_id         = aws_route_table.customer_profile_public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.customer_profile.id
}

resource "aws_route_table_association" "customer_profile_public" {
  for_each = aws_subnet.customer_profile_public

  subnet_id      = each.value.id
  route_table_id = aws_route_table.customer_profile_public.id
}

resource "aws_route_table_association" "customer_profile_private" {
  for_each = aws_subnet.customer_profile_private

  subnet_id      = each.value.id
  route_table_id = aws_route_table.customer_profile_private.id
}

resource "aws_subnet" "account_alb" {
  for_each = { for idx, subnet in var.account_alb_subnets : "account_alb_${idx}" => subnet }

  vpc_id                  = aws_vpc.account.id
  cidr_block              = each.value.cidr
  availability_zone       = each.value.az
  map_public_ip_on_launch = false

  tags = merge(var.project_tags, {
    Name = "account-alb-${each.key}"
    Tier = "private"
    Purpose = "InternalALB"
  })
}

resource "aws_subnet" "account_private" {
  for_each = { for idx, subnet in var.account_private_subnets : "account_private_${idx}" => subnet }

  vpc_id                  = aws_vpc.account.id
  cidr_block              = each.value.cidr
  availability_zone       = each.value.az
  map_public_ip_on_launch = false

  tags = merge(var.project_tags, {
    Name = "account-private-${each.key}"
    Tier = "private"
    Purpose = "AppService"
  })
}

resource "aws_route_table" "account_private" {
  vpc_id = aws_vpc.account.id

  tags = merge(var.project_tags, {
    Name = "account-private-rt"
  })
}

resource "aws_route_table_association" "account_private" {
  for_each = aws_subnet.account_private

  subnet_id      = each.value.id
  route_table_id = aws_route_table.account_private.id
}

resource "aws_route_table" "statement_private" {
  vpc_id = aws_vpc.statement.id

  tags = merge(var.project_tags, {
    Name = "statement-private-rt"
  })
}

resource "aws_subnet" "statement_alb" {
  for_each = { for idx, subnet in var.statement_alb_subnets : "statement_alb_${idx}" => subnet }

  vpc_id                  = aws_vpc.statement.id
  cidr_block              = each.value.cidr
  availability_zone       = each.value.az
  map_public_ip_on_launch = false

  tags = merge(var.project_tags, {
    Name = "statement-alb-${each.key}"
    Tier = "private"
    Purpose = "InternalALB"
  })
}

resource "aws_subnet" "statement_private" {
  for_each = { for idx, subnet in var.statement_private_subnets : "statement_private_${idx}" => subnet }

  vpc_id                  = aws_vpc.statement.id
  cidr_block              = each.value.cidr
  availability_zone       = each.value.az
  map_public_ip_on_launch = false

  tags = merge(var.project_tags, {
    Name = "statement-private-${each.key}"
    Tier = "private"
    Purpose = "AppService"
  })
}

resource "aws_route_table_association" "statement_private" {
  for_each = aws_subnet.statement_private

  subnet_id      = each.value.id
  route_table_id = aws_route_table.statement_private.id
}

