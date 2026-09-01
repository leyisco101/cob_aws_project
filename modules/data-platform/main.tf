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

#
# Athena query results bucket


resource "aws_s3_bucket" "athena_results_bucket" {
  bucket = "${local.project_name}-athena-results"

  tags = merge(
    local.common_tags,
    {
      Name = "${local.project_name}-athena-results"
    }
  )
}

# Block all public access to Athena results
resource "aws_s3_bucket_public_access_block" "athena_results_public_access" {
  bucket = aws_s3_bucket.athena_results_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Encrypt Athena query results
resource "aws_s3_bucket_server_side_encryption_configuration" "athena_results_encryption" {
  bucket = aws_s3_bucket.athena_results_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Automatically remove old Athena query results
resource "aws_s3_bucket_lifecycle_configuration" "athena_results_lifecycle" {
  bucket = aws_s3_bucket.athena_results_bucket.id

  rule {
    id     = "expire-athena-results"
    status = "Enabled"

    filter {}

    expiration {
  days = var.athena_results_expiration_days
}
  }
}


# AWS Glue Data Catalog


resource "aws_glue_catalog_database" "data_catalog" {
  name = "${replace(local.project_name, "-", "_")}_database"

  description = "Glue Data Catalog database managed by COB"
}

# Example table representing CSV data stored in S3
resource "aws_glue_catalog_table" "application_data" {
  name          = "application_data"
  database_name = aws_glue_catalog_database.data_catalog.name

  table_type = "EXTERNAL_TABLE"

  parameters = {
    classification = "csv"
  }

  storage_descriptor {
    location      = "s3://${var.data_bucket_name}/${var.data_prefix}"
    input_format  = "org.apache.hadoop.mapred.TextInputFormat"
    output_format = "org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat"

    ser_de_info {
      name = "csv-serde"

      serialization_library = "org.apache.hadoop.hive.serde2.lazy.LazySimpleSerDe"

      parameters = {
        "field.delim" = ","
      }
    }

    columns {
      name = "id"
      type = "string"
    }

    columns {
      name = "name"
      type = "string"
    }

    columns {
      name = "value"
      type = "string"
    }
  }
}


# Amazon Athena


resource "aws_athena_workgroup" "athena_workgroup" {
  name = "${local.project_name}-workgroup"

  configuration {
    enforce_workgroup_configuration = true

    result_configuration {
      output_location = "s3://${aws_s3_bucket.athena_results_bucket.bucket}/"

      encryption_configuration {
        encryption_option = "SSE_S3"
      }
    }
  }

  tags = merge(
    local.common_tags,
    {
      Name = "${local.project_name}-athena-workgroup"
    }
  )
}