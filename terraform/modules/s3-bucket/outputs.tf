output "bucket_id" {
  value       = aws_s3_bucket.package_bucket.id
  description = "The ID of the package S3 bucket."
}

output "bucket_arn" {
  value       = aws_s3_bucket.package_bucket.arn
  description = "The ARN of the package S3 bucket."
}
