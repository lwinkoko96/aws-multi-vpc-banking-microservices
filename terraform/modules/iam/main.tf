resource "aws_iam_role" "ec2_ssm" {
  count = var.manage_existing_role ? 0 : 1

  name = "ssm-role-for-ec2"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = merge(var.project_tags, {
    Name = "ssm-role-for-ec2"
  })
}

resource "aws_iam_policy" "s3_read_package" {
  count       = var.manage_existing_role ? 0 : 1
  name        = "S3_Read_Package_Policy"
  description = "Least-privilege policy that allows EC2 to read only the fake-service package from the package bucket."

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid = "ReadFakeServiceBinary"
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:GetObjectVersion"
        ]
        Resource = "arn:aws:s3:::${var.package_bucket_name}/${var.fake_service_object_key}"
      }
    ]
  })

  tags = merge(var.project_tags, {
    Name = "S3_Read_Package_Policy"
  })
}

resource "aws_iam_role_policy_attachment" "ssm_managed_instance_core" {
  count      = var.manage_existing_role ? 0 : 1
  role       = aws_iam_role.ec2_ssm[0].name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy_attachment" "s3_read_package" {
  count      = var.manage_existing_role ? 0 : 1
  role       = aws_iam_role.ec2_ssm[0].name
  policy_arn = aws_iam_policy.s3_read_package[0].arn
}

resource "aws_iam_instance_profile" "ec2_profile" {
  count = var.manage_existing_role ? 0 : 1

  name = "ssm-role-for-ec2-instance-profile"
  role = aws_iam_role.ec2_ssm[0].name

  tags = merge(var.project_tags, {
    Name = "ssm-role-for-ec2-instance-profile"
  })
}
