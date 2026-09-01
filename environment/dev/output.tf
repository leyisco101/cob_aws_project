output "vpc_id" {
  description = "Dev VPC ID"
  value       = module.network.vpc_id
}

output "public_subnet_ids" {
  description = "Dev public subnet IDs"
  value       = module.network.public_subnet_ids
}

output "private_subnet_ids" {
  description = "Dev private subnet IDs"
  value       = module.network.private_subnet_ids
}

output "base_security_group_id" {
  description = "Dev base security group ID"
  value       = module.network.base_security_group_id
}

output "nat_gateway_id" {
  description = "Dev NAT Gateway ID"
  value       = module.network.nat_gateway_id
}



# Storage Outputs


output "storage_bucket_id" {
  description = "ID of the dev S3 storage bucket"
  value       = module.storage.bucket_id
}

output "storage_bucket_name" {
  description = "Name of the dev S3 storage bucket"
  value       = module.storage.bucket_name
}

output "storage_bucket_arn" {
  description = "ARN of the dev S3 storage bucket"
  value       = module.storage.bucket_arn
}

output "storage_bucket_domain_name" {
  description = "Domain name of the dev S3 storage bucket"
  value       = module.storage.bucket_domain_name
}


# IAM Outputs


output "workload_role_name" {
  description = "Name of the dev workload IAM role"
  value       = module.iam.workload_role_name
}

output "workload_role_arn" {
  description = "ARN of the dev workload IAM role"
  value       = module.iam.workload_role_arn
}

output "s3_access_policy_arn" {
  description = "ARN of the dev S3 access policy"
  value       = module.iam.s3_access_policy_arn
}



# ECS Outputs


output "ecs_cluster_name" {
  description = "Name of the dev ECS cluster"
  value       = module.ecs.cluster_name
}

output "ecs_service_name" {
  description = "Name of the dev ECS service"
  value       = module.ecs.service_name
}

output "ecs_task_definition_arn" {
  description = "ARN of the dev ECS task definition"
  value       = module.ecs.task_definition_arn
}

output "ecs_security_group_id" {
  description = "Security group ID used by the dev ECS service"
  value       = module.ecs.ecs_security_group_id
}


output "database_endpoint" {
  description = "Endpoint of the dev PostgreSQL database"
  value       = module.database.database_endpoint
}

output "database_port" {
  description = "Port used by the dev PostgreSQL database"
  value       = module.database.database_port
}

output "database_name" {
  description = "Name of the dev PostgreSQL database"
  value       = module.database.database_name
}

output "database_security_group_id" {
  description = "Security group ID used by the dev database"
  value       = module.database.database_security_group_id

}

output "ec2_instance_id" {
  description = "ID of the dev EC2 instance"
  value       = module.ec2.instance_id
}

output "ec2_private_ip" {
  description = "Private IP address of the dev EC2 instance"
  value       = module.ec2.private_ip
}

output "ec2_security_group_id" {
  description = "Security group ID used by the dev EC2 instance"
  value       = module.ec2.security_group_id
}

output "ec2_iam_role_arn" {
  description = "IAM role ARN used by the dev EC2 instance"
  value       = module.ec2.iam_role_arn
}


output "glue_database_name" {
  description = "Name of the dev Glue database"
  value       = module.data_platform.glue_database_name
}

output "glue_table_name" {
  description = "Name of the dev Glue table"
  value       = module.data_platform.glue_table_name
}

output "athena_workgroup_name" {
  description = "Name of the dev Athena workgroup"
  value       = module.data_platform.athena_workgroup_name
}

output "athena_results_bucket_name" {
  description = "Name of the dev Athena results bucket"
  value       = module.data_platform.athena_results_bucket_name
}
