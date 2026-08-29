output "cluster_id" {
  description = "ID of the ECS cluster"
  value       = aws_ecs_cluster.ecs_cluster.id
}

output "cluster_name" {
  description = "Name of the ECS cluster"
  value       = aws_ecs_cluster.ecs_cluster.name
}

output "service_name" {
  description = "Name of the ECS service"
  value       = aws_ecs_service.ecs_service.name
}

output "task_definition_arn" {
  description = "ARN of the ECS task definition"
  value       = aws_ecs_task_definition.ecs_task.arn
}

output "ecs_security_group_id" {
  description = "Security group ID used by ECS workloads"
  value       = aws_security_group.ecs_security_group.id
}

output "execution_role_arn" {
  description = "ARN of the ECS task execution role"
  value       = aws_iam_role.ecs_execution_role.arn
}