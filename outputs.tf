output "bucket_name" {
  description = "The URL of the S3 static website"
  value = aws_s3_bucket.example.bucket
}

output "s3_website_url" {
  description = "The URL of the S3 static website"
  value       = aws_s3_bucket_website_configuration.example.website_endpoint
}