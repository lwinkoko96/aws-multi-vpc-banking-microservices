resource "aws_s3_bucket" "package_bucket" {
  bucket = var.bucket_name

  tags = merge(var.project_tags, {
    Name = "package-bucket"
  })
}

resource "aws_s3_bucket_policy" "package_policy" {
  count = var.manage_existing_bucket_policy ? 0 : 1

  bucket = aws_s3_bucket.package_bucket.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      merge(
        {
          Sid = "AllowEC2RoleReadFakeService"
          Effect = "Allow"
          Principal = {
            AWS = var.role_arn
          }
          Action = "s3:GetObject"
          Resource = "arn:aws:s3:::${aws_s3_bucket.package_bucket.bucket}/${var.object_key}"
        },
        var.restrict_s3_to_vpc_endpoints ? {
          Condition = {
            StringEquals = {
              "aws:sourceVpce" = var.source_vpce_ids
            }
          }
        } : {}
      )
    ]
  })
}

resource "aws_s3_object" "fake_service_binary" {
  count = var.source_file_path != "" ? 1 : 0

  bucket = aws_s3_bucket.package_bucket.id
  key    = var.object_key
  source = var.source_file_path

  etag = filemd5(var.source_file_path)

  tags = merge(var.project_tags, {
    Name = "fake-service-binary"
  })
}
