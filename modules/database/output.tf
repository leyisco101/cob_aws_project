output "database_id" {
  description = "ID of the PostgreSQL RDS instance"
  value       = aws_db_instance.postgres_database.id
}

output "database_endpoint" {
  description = "Endpoint of the PostgreSQL RDS instance"
  value       = aws_db_instance.postgres_database.address
}

output "database_port" {
  description = "Port used by the PostgreSQL database"
  value       = aws_db_instance.postgres_database.port
}

output "database_name" {
  description = "Name of the PostgreSQL database"
  value       = aws_db_instance.postgres_database.db_name
}

output "database_security_group_id" {
  description = "Security group ID used by the database"
  value       = aws_security_group.database_security_group.id
}