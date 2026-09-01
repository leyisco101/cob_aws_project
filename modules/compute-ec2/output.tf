output "instance_id" {
  description = "ID of the COB EC2 instance"
  value       = aws_instance.ec2_instance.id
}

output "private_ip" {
  description = "Private IP address of the COB EC2 instance"
  value       = aws_instance.ec2_instance.private_ip
}

output "security_group_id" {
  description = "Security group ID used by the EC2 instance"
  value       = aws_security_group.ec2_security_group.id
}

output "iam_role_arn" {
  description = "ARN of the EC2 IAM role"
  value       = aws_iam_role.ec2_role.arn
}

output "ami_id" {
  description = "AMI used by the EC2 instance"
  value       = data.aws_ami.amazon_linux.id
}