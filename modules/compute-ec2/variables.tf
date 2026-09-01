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
  description = "id of the VPC"
  type        = string
}

variable "private_subnet_ids" {
  description = "Private subnet ids available to the EC2 instance"
  type        = list(string)
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "root_volume_size" {
  description = "Size of the encrypted root volume in GB"
  type        = number
  default     = 8
}

variable "tags" {
  description = "Additional tags to apply to EC2 resources"
  type        = map(string)
  default     = {}
}