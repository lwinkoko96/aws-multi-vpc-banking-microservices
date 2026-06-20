output "ec2_role_name" {
  value = var.manage_existing_role ? split("/", var.existing_role_arn)[length(split("/", var.existing_role_arn)) - 1] : aws_iam_role.ec2_ssm[0].name
}

output "role_name" {
  value = var.manage_existing_role ? split("/", var.existing_role_arn)[length(split("/", var.existing_role_arn)) - 1] : aws_iam_role.ec2_ssm[0].name
}

output "role_arn" {
  value = var.manage_existing_role ? var.existing_role_arn : aws_iam_role.ec2_ssm[0].arn
}

output "instance_profile_name" {
  value = var.manage_existing_role ? "ssm-role-for-ec2-instance-profile" : aws_iam_instance_profile.ec2_profile[0].name
}
