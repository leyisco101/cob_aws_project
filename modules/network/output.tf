output "vpc_id" {
  description = "ID of the COB VPC"
  value       = aws_vpc.cob_vpc.id
}

output "vpc_cidr" {
  description = "CIDR block of the COB VPC"
  value       = aws_vpc.cob_vpc.cidr_block
}

output "public_subnet_ids" {
  description = "IDs of the public subnets"
  value       = aws_subnet.public_subnets[*].id
}

output "private_subnet_ids" {
  description = "IDs of the private subnets"
  value       = aws_subnet.private_subnets[*].id
}

output "public_route_table_id" {
  description = "ID of the public route table"
  value       = aws_route_table.public_route_table.id
}

output "private_route_table_id" {
  description = "ID of the private route table"
  value       = aws_route_table.private_route_table.id
}

output "internet_gateway_id" {
  description = "ID of the Internet Gateway"
  value       = aws_internet_gateway.internet_gateway.id
}

output "nat_gateway_id" {
  description = "ID of the NAT Gateway"
  value       = aws_nat_gateway.nat_gateway.id
}

output "base_security_group_id" {
  description = "ID of the COB base security group"
  value       = aws_security_group.base_security_group.id
}