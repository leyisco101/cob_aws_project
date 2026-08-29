variable "project" {
  description = "Name of the project using the ECS capability"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string

  validation {
    condition     = contains(["dev", "prod"], var.environment)
    error_message = "Environment must be either dev or prod."
  }
}

variable "vpc_id" {
  description = "id of the VPC where ECS resources will run"
  type        = string
}

variable "private_subnet_ids" {
  description = "Private subnet IDs used by the ECS service"
  type        = list(string)
}

variable "task_role_arn" {
  description = "iam role ARN used by the application running inside ECS"
  type        = string
}

variable "container_image" {
  description = "Container image used by the ECS task"
  type        = string
  default     = "nginx:latest"
}

variable "container_port" {
  description = "Port exposed by the application container"
  type        = number
  default     = 80
}

variable "cpu" {
  description = "CPU units allocated to the Fargate task"
  type        = number
  default     = 256
}

variable "memory" {
  description = "Memory allocated to the Fargate task in MiB"
  type        = number
  default     = 512
}

variable "desired_count" {
  description = "Number of ECS tasks to run"
  type        = number
  default     = 1
}

variable "tags" {
  description = "Additional tags to apply to ECS resources"
  type        = map(string)
  default     = {}
}