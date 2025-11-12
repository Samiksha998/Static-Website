// Outputs removed — Terraform simplified

output "jenkins_url" {
  description = "Jenkins web UI URL"
  value       = "http://${aws_eip.jenkins_eip.public_ip}:8080"
}

output "ssh_command" {
  description = "SSH command to connect to Jenkins server"
  value       = "ssh -i /path/to/key.pem ec2-user@${aws_eip.jenkins_eip.public_ip}"
}

output "instance_id" {
  description = "EC2 instance ID of Jenkins server"
  value       = aws_instance.jenkins.id
}

output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.jenkins_vpc.id
}

output "security_group_id" {
  description = "Security Group ID"
  value       = aws_security_group.jenkins_sg.id
}

output "subnet_id" {
  description = "Subnet ID"
  value       = aws_subnet.jenkins_subnet.id
}
