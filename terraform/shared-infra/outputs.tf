output "ecr_name" {
  description = "ECR name"
  value       = aws_ecr_repository.ecr.repository_url
}

output "bucket_name" {
  description = "TF State S3 bucket name"
  value       = aws_s3_bucket.bucket.bucket
}