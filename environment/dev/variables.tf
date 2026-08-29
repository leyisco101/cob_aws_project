variable "aws_region" {
  description = "AWS region for the dev environment"
  type        = string
  default     = "eu-east-1"
}

variable "project" {
  description = "Project name"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}


variable "database_password" {
  description = "Master password for the dev PostgreSQL database"
  type        = string
  sensitive   = true
}