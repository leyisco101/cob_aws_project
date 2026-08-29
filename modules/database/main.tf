locals {
  project_name = "${var.project}-${var.environment}"

  common_tags = merge(
    {
      Project     = var.project
      Environment = var.environment
      ManagedBy   = "COB"
    },
    var.tags
  )
}


# RDS Subnet Group


resource "aws_db_subnet_group" "database_subnet_group" {
  name = "${local.project_name}-db-subnet-group"

  subnet_ids = var.private_subnet_ids

  tags = merge(
    local.common_tags,
    {
      Name = "${local.project_name}-db-subnet-group"
    }
  )
}


# Database Security Group


resource "aws_security_group" "database_security_group" {
  name        = "${local.project_name}-db-sg"
  description = "Security group for COB RDS database"
  vpc_id      = var.vpc_id

  tags = merge(
    local.common_tags,
    {
      Name = "${local.project_name}-db-sg"
    }
  )
}


# Allow PostgreSQL Traffic From ECS


resource "aws_vpc_security_group_ingress_rule" "allow_postgres_from_ecs" {
  security_group_id = aws_security_group.database_security_group.id

  referenced_security_group_id = var.allowed_security_group_id

  from_port   = 5432
  to_port     = 5432
  ip_protocol = "tcp"

  description = "Allow PostgreSQL access from ECS workloads"
}


# Database Outbound Traffic


resource "aws_vpc_security_group_egress_rule" "database_outbound" {
  security_group_id = aws_security_group.database_security_group.id

  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = "-1"

  description = "Allow database outbound traffic"
}


# PostgreSQL RDS Instance


resource "aws_db_instance" "postgres_database" {
  identifier = "${local.project_name}-postgres"

  engine = "postgres"

  instance_class = var.instance_class

  allocated_storage = var.allocated_storage
  storage_type      = "gp3"
  storage_encrypted = true

  db_name  = var.database_name
  username = var.database_username
  password = var.database_password

  port = 5432

  db_subnet_group_name = aws_db_subnet_group.database_subnet_group.name

  vpc_security_group_ids = [
    aws_security_group.database_security_group.id
  ]

  publicly_accessible = false

  backup_retention_period = var.backup_retention_days

  multi_az = false

  deletion_protection = false

  skip_final_snapshot = true

  auto_minor_version_upgrade = true

  tags = merge(
    local.common_tags,
    {
      Name = "${local.project_name}-postgres"
    }
  )
}

