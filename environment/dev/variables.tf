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

variable "ec2_instance_type" {
  description = "EC2 instance type for the dev environment"
  type        = string
  default     = "t3.micro"
}

variable "ec2_root_volume_size" {
  description = "EC2 root volume size for the dev environment"
  type        = number
  default     = 8
}

variable "data_prefix" {
  description = "S3 prefix containing data queried by Athena in dev"
  type        = string
  default     = "data/"
}

variable "athena_results_expiration_days" {
  description = "Number of days to retain Athena query results in dev"
  type        = number
  default     = 30
}