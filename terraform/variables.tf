// Variables removed — Terraform simplified

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "subnet_cidr" {
  description = "CIDR block for public subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "instance_type" {
  description = "EC2 instance type for Jenkins server"
  type        = string
  default     = "t3.medium"

  validation {
    condition     = can(regex("^t3\\.", var.instance_type)) || can(regex("^t4g\\.", var.instance_type)) || can(regex("^m5\\.", var.instance_type)) || can(regex("^m6\\.", var.instance_type))
    error_message = "Instance type must be t3.*, t4g.*, m5.*, or m6.* (recommended for Jenkins with Docker)."
  }
}

variable "root_volume_size" {
  description = "Root volume size in GB (Jenkins needs sufficient space for artifacts and Docker layers)"
  type        = number
  default     = 50

  validation {
    condition     = var.root_volume_size >= 30
    error_message = "Root volume size must be at least 30 GB for Jenkins and Docker."
  }
}

variable "key_name" {
  description = "Name of the existing EC2 key pair for SSH access"
  type        = string

  validation {
    condition     = length(var.key_name) > 0
    error_message = "You must provide an existing EC2 key pair name for SSH access."
  }
}

variable "allowed_ip" {
  description = "CIDR block allowed for SSH access (e.g., your IP/32 or CIDR range)"
  type        = string
  default     = "0.0.0.0/0"

  validation {
    condition     = length(var.allowed_ip) > 0
    error_message = "allowed_ip must be a non-empty CIDR notation (e.g., '203.0.113.45/32' or '10.0.0.0/8')."
  }
}

variable "jenkins_version" {
  description = "Jenkins version to install (latest by default)"
  type        = string
  default     = "latest"
}

variable "docker_version" {
  description = "Docker version to install (latest by default)"
  type        = string
  default     = "latest"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "devops"
}
