variable "project" {
  description = "Name of the project using the IAM capability"
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

variable "bucket_arn" {
  description = "ARN of the S3 bucket the workload is allowed to access"
  type        = string
}

variable "tags" {
  description = "Additional tags to apply to IAM resources"
  type        = map(string)
  default     = {}
}