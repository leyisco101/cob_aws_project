variable "project" {
  description = "Name of the project using the network"
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

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.20.0.0/16"
}

variable "availability_zones" {
  description = "Availability zones used by the VPC"
  type        = list(string)

  default = [
    "us-east-1a",
    "us-east-1b"
  ]
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for the public subnets"
  type        = list(string)


}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for the private subnets"
  type        = list(string)

  
}

variable "tags" {
  description = "Additional tags to apply to network resources"
  type        = map(string)
  default     = {}
}