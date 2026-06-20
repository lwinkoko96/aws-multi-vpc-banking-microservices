data "aws_ami" "amazon_linux_2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "state"
    values = ["available"]
  }
}

resource "aws_launch_template" "customer_profile" {
  name_prefix   = "customer-profile-lt-"
  image_id      = data.aws_ami.amazon_linux_2.id
  instance_type = var.instance_type

  iam_instance_profile {
    name = var.iam_instance_profile_name
  }

  network_interfaces {
    associate_public_ip_address = false
    security_groups             = [var.customer_ec2_sg_id]
  }

  user_data = base64encode(var.customer_user_data_template)

  tag_specifications {
    resource_type = "instance"
    tags = merge(var.project_tags, {
      Name        = "customer-profile-instance"
      Service     = "customer-profile"
    })
  }
}

resource "aws_autoscaling_group" "customer_profile" {
  name                      = "customer-profile-asg"
  max_size                  = var.maximum_capacity
  min_size                  = var.minimum_capacity
  desired_capacity          = var.desired_capacity
  vpc_zone_identifier       = var.customer_private_subnet_ids
  launch_template {
    id      = aws_launch_template.customer_profile.id
    version = "$Latest"
  }

  target_group_arns = [var.customer_alb_tg_arn]
  health_check_type = "ELB"
  health_check_grace_period = 300
  force_delete = true

  tag {
    key                 = "Name"
    value               = "customer-profile-asg"
    propagate_at_launch = true
  }
}

resource "aws_launch_template" "account" {
  name_prefix   = "account-lt-"
  image_id      = data.aws_ami.amazon_linux_2.id
  instance_type = var.instance_type

  iam_instance_profile {
    name = var.iam_instance_profile_name
  }

  network_interfaces {
    associate_public_ip_address = false
    security_groups             = [var.account_ec2_sg_id]
  }

  user_data = base64encode(var.account_user_data_template)

  tag_specifications {
    resource_type = "instance"
    tags = merge(var.project_tags, {
      Name    = "account-instance"
      Service = "account"
    })
  }
}

resource "aws_autoscaling_group" "account" {
  name                      = "account-asg"
  max_size                  = var.maximum_capacity
  min_size                  = var.minimum_capacity
  desired_capacity          = var.desired_capacity
  vpc_zone_identifier       = var.account_private_subnet_ids
  launch_template {
    id      = aws_launch_template.account.id
    version = "$Latest"
  }

  target_group_arns = [var.account_alb_tg_arn]
  health_check_type = "ELB"
  health_check_grace_period = 300
  force_delete = true

  tag {
    key                 = "Name"
    value               = "account-asg"
    propagate_at_launch = true
  }
}

resource "aws_launch_template" "statement" {
  name_prefix   = "statement-lt-"
  image_id      = data.aws_ami.amazon_linux_2.id
  instance_type = var.instance_type

  iam_instance_profile {
    name = var.iam_instance_profile_name
  }

  network_interfaces {
    associate_public_ip_address = false
    security_groups             = [var.statement_ec2_sg_id]
  }

  user_data = base64encode(var.statement_user_data_template)

  tag_specifications {
    resource_type = "instance"
    tags = merge(var.project_tags, {
      Name    = "statement-instance"
      Service = "statement"
    })
  }
}

resource "aws_autoscaling_group" "statement" {
  name                      = "statement-asg"
  max_size                  = var.maximum_capacity
  min_size                  = var.minimum_capacity
  desired_capacity          = var.desired_capacity
  vpc_zone_identifier       = var.statement_private_subnet_ids
  launch_template {
    id      = aws_launch_template.statement.id
    version = "$Latest"
  }

  target_group_arns = [var.statement_alb_tg_arn]
  health_check_type = "ELB"
  health_check_grace_period = 300
  force_delete = true

  tag {
    key                 = "Name"
    value               = "statement-asg"
    propagate_at_launch = true
  }
}
