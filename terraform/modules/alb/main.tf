resource "aws_lb" "customer_profile" {
  name               = "customer-profile-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.customer_alb_sg_id]
  subnets            = var.customer_public_subnet_ids

  tags = merge(var.project_tags, {
    Name = "customer-profile-alb"
  })
}

resource "aws_lb_target_group" "customer_profile" {
  name        = "customer-profile-tg"
  port        = 9091
  protocol    = "HTTP"
  vpc_id      = var.customer_vpc_id
  target_type = "instance"

  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200-399"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 3
  }

  tags = merge(var.project_tags, {
    Name = "customer-profile-tg"
  })
}

resource "aws_lb_listener" "customer_profile_https" {
  load_balancer_arn = aws_lb.customer_profile.arn
  port              = 443
  protocol          = "HTTPS"

  ssl_policy = "ELBSecurityPolicy-2016-08"

  certificate_arn = var.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.customer_profile.arn
  }
}

resource "aws_lb_listener" "customer_profile_http" {
  load_balancer_arn = aws_lb.customer_profile.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      protocol = "HTTPS"
      port     = "443"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_lb" "account" {
  name               = "account-internal-alb"
  internal           = true
  load_balancer_type = "application"
  security_groups    = [var.account_alb_sg_id]
  subnets            = var.account_private_subnet_ids

  tags = merge(var.project_tags, {
    Name = "account-internal-alb"
  })
}

resource "aws_lb_target_group" "account" {
  name        = "account-tg"
  port        = 9092
  protocol    = "HTTP"
  vpc_id      = var.account_vpc_id
  target_type = "instance"

  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200-399"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 3
  }

  tags = merge(var.project_tags, {
    Name = "account-tg"
  })
}

resource "aws_lb_listener" "account_http" {
  load_balancer_arn = aws_lb.account.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.account.arn
  }
}

resource "aws_lb" "statement" {
  name               = "statement-internal-alb"
  internal           = true
  load_balancer_type = "application"
  security_groups    = [var.statement_alb_sg_id]
  subnets            = var.statement_private_subnet_ids

  tags = merge(var.project_tags, {
    Name = "statement-internal-alb"
  })
}

resource "aws_lb_target_group" "statement" {
  name        = "statement-tg"
  port        = 9093
  protocol    = "HTTP"
  vpc_id      = var.statement_vpc_id
  target_type = "instance"

  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200-399"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 3
  }

  tags = merge(var.project_tags, {
    Name = "statement-tg"
  })
}

resource "aws_lb_listener" "statement_http" {
  load_balancer_arn = aws_lb.statement.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.statement.arn
  }
}
