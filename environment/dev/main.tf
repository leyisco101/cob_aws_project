terraform {
  required_version = ">= 1.6.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

module "network" {
  source = "../../modules/network"

  project     = var.project
  environment = var.environment

  vpc_cidr = "10.20.0.0/16"

  availability_zones = [
    "us-east-1a",
    "us-east-1b"
  ]

  public_subnet_cidrs = [
    "10.20.1.0/24",
    "10.20.2.0/24"
  ]

  private_subnet_cidrs = [
    "10.20.11.0/24",
    "10.20.12.0/24"
  ]

  tags = {
    Owner = "Platform-Engineering"
  }
}


# COB Storage Module


module "storage" {
  source = "../../modules/storage"

  project     = var.project
  environment = var.environment

  bucket_purpose = "application-data"

  enable_versioning         = true
  lifecycle_expiration_days = 90

  tags = {
    Owner = "Platform-Engineering"
  }
}

# ---------------------------------------------------------
# COB IAM Module
# ---------------------------------------------------------

module "iam" {
  source = "../../modules/iam"

  project     = var.project
  environment = var.environment

  bucket_arn = module.storage.bucket_arn

  tags = {
    Owner = "Platform-Engineering"
  }
}