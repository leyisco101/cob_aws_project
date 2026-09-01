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

variable "data_bucket_name" {
  description = "Name of the S3 bucket containing the source data"
  type        = string
}

variable "data_prefix" {
  description = "S3 prefix containing data queried by Athena"
  type        = string
  default     = "data/"
}

variable "tags" {
  description = "Additional tags to apply to data platform resources"
  type        = map(string)
  default     = {}
}

variable "athena_results_expiration_days" {
  description = "Number of days before Athena query results expire"
  type        = number
  default     = 30

  validation {
    condition     = var.athena_results_expiration_days > 0
    error_message = "Athena results expiration days must be greater than 0."
  }
}