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

# Find the latest Amazon Linux 2023 AMI
data "aws_ami" "amazon_linux" {
  most_recent = true

  owners = [
    "amazon"
  ]

  filter {
    name = "name"

    values = [
      "al2023-ami-2023.*-x86_64"
    ]
  }

  filter {
    name = "virtualization-type"

    values = [
      "hvm"
    ]
  }
}

# IAM trust policy allowing EC2 to assume the role
data "aws_iam_policy_document" "ec2_assume_role" {
  statement {
    effect = "Allow"

    actions = [
      "sts:AssumeRole"
    ]

    principals {
      type = "Service"

      identifiers = [
        "ec2.amazonaws.com"
      ]
    }
  }
}

# IAM role used by the EC2 instance
resource "aws_iam_role" "ec2_role" {
  name = "${local.project_name}-ec2-role"

  assume_role_policy = data.aws_iam_policy_document.ec2_assume_role.json

  tags = merge(
    local.common_tags,
    {
      Name = "${local.project_name}-ec2-role"
    }
  )
}

# Allow the instance to be managed through AWS Systems Manager
resource "aws_iam_role_policy_attachment" "ssm_access" {
  role = aws_iam_role.ec2_role.name

  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# Instance profile connects the IAM role to EC2
resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name = "${local.project_name}-ec2-instance-profile"

  role = aws_iam_role.ec2_role.name
}

# Dedicated EC2 security group
resource "aws_security_group" "ec2_security_group" {
  name        = "${local.project_name}-ec2-sg"
  description = "Security group for COB EC2 workloads"
  vpc_id      = var.vpc_id

  tags = merge(
    local.common_tags,
    {
      Name = "${local.project_name}-ec2-sg"
    }
  )
}

# Allow outbound traffic
resource "aws_vpc_security_group_egress_rule" "ec2_outbound" {
  security_group_id = aws_security_group.ec2_security_group.id

  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = "-1"

  description = "Allow EC2 outbound traffic"
}

# EC2 instance
resource "aws_instance" "ec2_instance" {
  ami = data.aws_ami.amazon_linux.id

  instance_type = var.instance_type

  subnet_id = var.private_subnet_ids[0]

  vpc_security_group_ids = [
    aws_security_group.ec2_security_group.id
  ]

  iam_instance_profile = aws_iam_instance_profile.ec2_instance_profile.name

  associate_public_ip_address = false

  root_block_device {
    volume_type = "gp3"
    volume_size = var.root_volume_size
    encrypted   = true
  }

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }

  tags = merge(
    local.common_tags,
    {
      Name = "${local.project_name}-ec2"
    }
  )
}