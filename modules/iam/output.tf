output "workload_role_name" {
  description = "Name of the COB workload IAM role"
  value       = aws_iam_role.workload_role.name
}

output "workload_role_arn" {
  description = "ARN of the COB workload IAM role"
  value       = aws_iam_role.workload_role.arn
}

output "s3_access_policy_arn" {
  description = "ARN of the least-privilege S3 access policy"
  value       = aws_iam_policy.s3_access_policy.arn
}