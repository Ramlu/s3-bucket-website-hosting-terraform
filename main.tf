# resource "random_string" "bucket_suffix" {
#   length  = 6
#   upper   = false
#   special = false
# }

resource "aws_s3_bucket" "example" {
  bucket = "my-tf-bucket-demo-2025-test"
  force_destroy = true
  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}

resource "aws_s3_bucket_versioning" "versioning_example" {
  bucket = aws_s3_bucket.example.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_website_configuration" "example" {
  bucket = aws_s3_bucket.example.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}

resource "aws_s3_bucket_public_access_block" "example" {
  bucket = aws_s3_bucket.example.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "allow_access_from_another_account" {
  bucket = aws_s3_bucket.example.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action    = "s3:GetObject",
        Effect    = "Allow",
        Resource  = ["${aws_s3_bucket.example.arn}/*"],
        Principal = "*"
      },
    ]
  })

  depends_on = [aws_s3_bucket_public_access_block.example]
}

# resource "null_resource" "sync_site" {
#   provisioner "local-exec" {
#     command = "aws s3 sync ./oxer-html s3://${aws_s3_bucket.example.bucket}/ --delete --profile dem-profile"
#   }

#   triggers = {
#     bucket_name = aws_s3_bucket.example.bucket
#   }
# }
