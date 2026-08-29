variable "project" {
  description = "Name of the project"
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
  description = "ID of the VPC where the database will run"
  type        = string
}

variable "private_subnet_ids" {
  description = "Private subnet id used by the database"
  type        = list(string)
}

variable "allowed_security_group_id" {
  description = "Security group allowed to connect to the database"
  type        = string
}

variable "database_name" {
  description = "Name of the PostgreSQL database"
  type        = string
  default     = "appdb"
}

variable "database_username" {
  description = "Master username for the database"
  type        = string
  default     = "cobadmin"
}

variable "database_password" {
  description = "Master password for the database"
  type        = string
  sensitive   = true
}

variable "instance_class" {
  description = "RDS instance class"
  type        = string
  default     = "db.t3.micro"
}

variable "allocated_storage" {
  description = "Allocated storage in GB"
  type        = number
  default     = 20
}

variable "backup_retention_days" {
  description = "Number of days to retain database backups"
  type        = number
  default     = 1
}

variable "tags" {
  description = "Additional tags to apply to database resources"
  type        = map(string)
  default     = {}
}