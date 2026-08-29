locals {
  project_name = "${var.project}-${var.environment}"

  common_tags = merge(
    {
      Project     = var.project
      Environment = var.environment
      ManagedBy   = "COB"
    },
    var.tags
  )
}



# S3 Bucket


resource "aws_s3_bucket" "storage_bucket" {
  bucket = "${local.project_name}-${var.bucket_purpose}"

  tags = merge(
    local.common_tags,
    {
      Name = "${local.project_name}-${var.bucket_purpose}"
    }
  )
}



# Block Public Access

resource "aws_s3_bucket_public_access_block" "public_access_block" {
  bucket = aws_s3_bucket.storage_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}



# Bucket Versioning


resource "aws_s3_bucket_versioning" "bucket_versioning" {
  bucket = aws_s3_bucket.storage_bucket.id

  versioning_configuration {
    status = var.enable_versioning ? "Enabled" : "Suspended"
  }
}



# Server-Side Encryption


resource "aws_s3_bucket_server_side_encryption_configuration" "bucket_encryption" {
  bucket = aws_s3_bucket.storage_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}



# Lifecycle Management


resource "aws_s3_bucket_lifecycle_configuration" "bucket_lifecycle" {
  bucket = aws_s3_bucket.storage_bucket.id

  depends_on = [
    aws_s3_bucket_versioning.bucket_versioning
  ]

  rule {
    id     = "expire-old-objects"
    status = "Enabled"

    filter {}

    expiration {
      days = var.lifecycle_expiration_days
    }

    noncurrent_version_expiration {
      noncurrent_days = var.lifecycle_expiration_days
    }
  }
}