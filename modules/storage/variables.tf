variable "project" {
  description = "Name of the project using the storage capability"
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

variable "bucket_purpose" {
  description = "Purpose of the S3 bucket"
  type        = string
}

variable "enable_versioning" {
  description = "Enable S3 bucket versioning"
  type        = bool
  default     = true
}

variable "lifecycle_expiration_days" {
  description = "Number of days before objects and old versions expire"
  type        = number
  default     = 90
}

variable "tags" {
  description = "Additional tags to apply to storage resources"
  type        = map(string)
  default     = {}
}