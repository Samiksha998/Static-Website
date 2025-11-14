variable "instance_type" {
  description = "EC2 instance type for Jenkins"
  type        = string
  default     = "t2.medium"
}

variable "key_name" {
  description = "Existing AWS key pair name for SSH access"
  type        = string
}

variable "subnet_id" {
  description = "Subnet ID for Jenkins server"
  type        = string
}
