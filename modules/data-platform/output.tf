output "glue_database_name" {
  description = "Name of the Glue Data Catalog database"
  value       = aws_glue_catalog_database.data_catalog.name
}

output "glue_table_name" {
  description = "Name of the Glue Data Catalog table"
  value       = aws_glue_catalog_table.application_data.name
}

output "athena_workgroup_name" {
  description = "Name of the Athena workgroup"
  value       = aws_athena_workgroup.athena_workgroup.name
}

output "athena_results_bucket_name" {
  description = "Name of the S3 bucket storing Athena query results"
  value       = aws_s3_bucket.athena_results_bucket.bucket
}

output "athena_results_bucket_arn" {
  description = "ARN of the S3 bucket storing Athena query results"
  value       = aws_s3_bucket.athena_results_bucket.arn
}