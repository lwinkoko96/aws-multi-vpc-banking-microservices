output "launch_template_ids" {
  value = [
    aws_launch_template.customer_profile.id,
    aws_launch_template.account.id,
    aws_launch_template.statement.id,
  ]
}

output "asg_names" {
  value = [
    aws_autoscaling_group.customer_profile.name,
    aws_autoscaling_group.account.name,
    aws_autoscaling_group.statement.name,
  ]
}
