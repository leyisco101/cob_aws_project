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



# VPC


resource "aws_vpc" "cob_vpc" {
  cidr_block = var.vpc_cidr

  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge(
    local.common_tags,
    {
      Name = "${local.project_name}-vpc"
    }
  )
}



# Internet Gateway


resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.cob_vpc.id

  tags = merge(
    local.common_tags,
    {
      Name = "${local.project_name}-igw"
    }
  )
}



# Public Subnets


resource "aws_subnet" "public_subnets" {
  count = length(var.public_subnet_cidrs)

  vpc_id                  = aws_vpc.cob_vpc.id
  cidr_block              = var.public_subnet_cidrs[count.index]
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = true

  tags = merge(
    local.common_tags,
    {
      Name = "${local.project_name}-public-${count.index + 1}"
      Tier = "public"
    }
  )
}



# Private Subnets


resource "aws_subnet" "private_subnets" {
  count = length(var.private_subnet_cidrs)

  vpc_id                  = aws_vpc.cob_vpc.id
  cidr_block              = var.private_subnet_cidrs[count.index]
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = false

  tags = merge(
    local.common_tags,
    {
      Name = "${local.project_name}-private-${count.index + 1}"
      Tier = "private"
    }
  )
}



# Public Route Table


resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.cob_vpc.id

  tags = merge(
    local.common_tags,
    {
      Name = "${local.project_name}-public-rt"
    }
  )
}



# Public Internet Route


resource "aws_route" "public_internet_route" {
  route_table_id         = aws_route_table.public_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.internet_gateway.id
}



# Public Route Table Associations


resource "aws_route_table_association" "public_route_associations" {
  count = length(aws_subnet.public_subnets)

  subnet_id      = aws_subnet.public_subnets[count.index].id
  route_table_id = aws_route_table.public_route_table.id
}



# Elastic IP For NAT Gateway


resource "aws_eip" "nat_eip" {
  domain = "vpc"

  tags = merge(
    local.common_tags,
    {
      Name = "${local.project_name}-nat-eip"
    }
  )
}



# NAT Gateway


resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_subnets[0].id

  depends_on = [
    aws_internet_gateway.internet_gateway
  ]

  tags = merge(
    local.common_tags,
    {
      Name = "${local.project_name}-nat"
    }
  )
}


# Private Route Table


resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.cob_vpc.id

  tags = merge(
    local.common_tags,
    {
      Name = "${local.project_name}-private-rt"
    }
  )
}



# Private Route Through NAT Gateway


resource "aws_route" "private_nat_route" {
  route_table_id         = aws_route_table.private_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_gateway.id
}


# Private Route Table Associations


resource "aws_route_table_association" "private_route_associations" {
  count = length(aws_subnet.private_subnets)

  subnet_id      = aws_subnet.private_subnets[count.index].id
  route_table_id = aws_route_table.private_route_table.id
}



# Base Security Group


resource "aws_security_group" "base_security_group" {
  name        = "${local.project_name}-base-sg"
  description = "Base security group managed by COB"
  vpc_id      = aws_vpc.cob_vpc.id

  tags = merge(
    local.common_tags,
    {
      Name = "${local.project_name}-base-sg"
    }
  )
}



# Allow Internal VPC Traffic


resource "aws_vpc_security_group_ingress_rule" "allow_internal_traffic" {
  security_group_id = aws_security_group.base_security_group.id

  cidr_ipv4   = var.vpc_cidr
  ip_protocol = "-1"

  description = "Allow internal traffic within the VPC"
}



# Allow Outbound Traffic


resource "aws_vpc_security_group_egress_rule" "allow_outbound_traffic" {
  security_group_id = aws_security_group.base_security_group.id

  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = "-1"

  description = "Allow outbound traffic"
}