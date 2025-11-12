# Jenkins + Docker + Kubernetes on AWS Terraform

This Terraform configuration sets up a production-ready Jenkins server on AWS with Docker and Kubernetes tools integrated, optimized for running container and container orchestration pipelines.

## What Gets Created

- **VPC** with public subnet and internet gateway
- **Security Group** with ports open for:
  - SSH (22) - restricted to your IP
  - Jenkins Web UI (8080)
  - Jenkins Agents (50000)
  - Docker daemon (2375)
  - Kubernetes API (6443)
- **EC2 Instance** (t3.medium) running Amazon Linux 2 with:
  - Java 11 (required for Jenkins)
  - Jenkins (latest)
  - Docker (latest) with docker-compose
  - kubectl (for Kubernetes operations)
- **Elastic IP** for stable public IP address
- **Encrypted EBS Volume** (50 GB) for artifacts and Docker layers

## Prerequisites

1. **AWS Account** with appropriate IAM permissions
2. **Terraform CLI** version 1.0.0 or later
3. **AWS CLI** configured with credentials
4. **Existing EC2 Key Pair** in your target AWS region

## Quick Start

### 1. Initialize Terraform

```bash
cd terraform
terraform init
```

This downloads the required AWS provider.

### 2. Review Configuration

Update `terraform.tfvars` with your values:

```terraform
aws_region       = "us-east-1"          # Your AWS region
vpc_cidr         = "10.0.0.0/16"         # VPC CIDR block
subnet_cidr      = "10.0.1.0/24"         # Subnet CIDR block
instance_type    = "t3.medium"           # EC2 instance type
root_volume_size = 50                    # EBS volume size (GB)
key_name         = "Test_Key"            # Your existing EC2 key pair name
allowed_ip       = "203.0.113.45/32"     # Your IP (for SSH access)
jenkins_version  = "latest"              # Jenkins version
docker_version   = "latest"              # Docker version
environment      = "devops"              # Environment name
```

**IMPORTANT:** Change `allowed_ip` from `0.0.0.0/0` to your specific IP (e.g., `203.0.113.45/32`) for better security!

### 3. Validate Configuration

```bash
terraform validate
```

### 4. Plan Deployment

```bash
terraform plan -var-file=terraform.tfvars
```

Review the resources that will be created.

### 5. Apply Configuration

```bash
terraform apply -var-file=terraform.tfvars
```

Type `yes` when prompted. Deployment takes 3-5 minutes.

## Outputs

After successful deployment, Terraform displays:

- **jenkins_public_ip**: Dynamic public IP
- **jenkins_elastic_ip**: Stable Elastic IP (recommended to use)
- **jenkins_url**: Full Jenkins URL
- **ssh_command**: SSH command to connect to the instance
- **instance_id**: EC2 instance ID
- **vpc_id**: VPC ID
- **security_group_id**: Security Group ID
- **subnet_id**: Subnet ID

## Accessing Jenkins

After deployment completes:

1. **Wait 2-3 minutes** for Jenkins to fully initialize
2. **Access Jenkins**:
   ```
   http://<elastic_ip>:8080
   ```

3. **Get Initial Admin Password**:
   ```bash
   ssh -i /path/to/your/key.pem ec2-user@<elastic_ip>
   sudo cat /var/lib/jenkins/secrets/initialAdminPassword
   ```

4. **Complete Jenkins Setup**:
   - Copy the admin password from above
   - Install suggested plugins or select custom plugins
   - Create first admin user
   - Configure Jenkins URL (use the Elastic IP)

## Jenkins Configuration for Docker & Kubernetes Pipelines

The instance comes with:

- **Docker**: Ready to build and push container images
- **docker-compose**: For multi-container applications
- **kubectl**: For Kubernetes deployments
- **Jenkins Docker Plugin**: Pre-install via "Manage Plugins" for containerized builds

### Example Jenkins Docker Pipeline

```groovy
pipeline {
    agent {
        docker {
            image 'python:3.9'
            args '-v /var/run/docker.sock:/var/run/docker.sock'
        }
    }
    stages {
        stage('Build') {
            steps {
                sh 'python -m pip install -r requirements.txt'
            }
        }
    }
}
```

## Security Recommendations

1. **Change allowed_ip**: Replace `0.0.0.0/0` with your specific IP in `terraform.tfvars`
2. **Secure Jenkins**:
   - Enable authentication and authorization
   - Use HTTPS with a proper certificate
   - Restrict plugin installations
3. **Manage Secrets**:
   - Use AWS Secrets Manager for credentials
   - Never hardcode secrets in Jenkinsfiles
4. **Network**:
   - Consider adding a private subnet for databases
   - Use VPN for Jenkins access

## Scaling & Customization

### Increase Disk Space

Modify in `terraform.tfvars`:
```terraform
root_volume_size = 100  # 100 GB instead of 50 GB
```

### Change Instance Type

For higher workloads (Docker builds, Kubernetes):
```terraform
instance_type = "t3.large"  # or t3.xlarge, m5.large, etc.
```

### Add Additional Security Group Rules

Edit `main.tf` to add more ingress rules for your tools.

## Cleanup

To destroy all resources and stop incurring charges:

```bash
terraform destroy -var-file=terraform.tfvars
```

Type `yes` when prompted. The Elastic IP and encrypted volumes will also be deleted.

## Troubleshooting

### Jenkins Not Accessible

1. Check security group allows port 8080:
   ```bash
   aws ec2 describe-security-groups --group-ids <group_id>
   ```

2. SSH into instance and check Jenkins status:
   ```bash
   sudo systemctl status jenkins
   ```

3. View Jenkins logs:
   ```bash
   sudo tail -f /var/log/jenkins/jenkins.log
   ```

### EC2 Instance Not Launching

- Verify key pair exists in your region:
  ```bash
  aws ec2 describe-key-pairs --region us-east-1
  ```

- Check AWS account limits for EC2 instances

- Review Terraform error messages in the console

### Docker Commands Failing

The jenkins user is added to the docker group. Restart Jenkins if needed:
```bash
sudo systemctl restart jenkins
```

## Files

- `main.tf` - VPC, EC2, Security Group resources
- `variables.tf` - Variable definitions with validation
- `outputs.tf` - Output values after deployment
- `terraform.tfvars` - Variable values (update this!)
- `user_data/jenkins_user_data.sh` - EC2 initialization script

## References

- [Jenkins Official Documentation](https://www.jenkins.io/doc/)
- [Docker Documentation](https://docs.docker.com/)
- [Kubernetes Documentation](https://kubernetes.io/docs/)
- [Terraform AWS Provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)

## Support

For issues:
1. Check Terraform error messages
2. Review AWS CloudTrail logs
3. SSH into instance and check system logs
4. Review user_data script execution: `/var/log/cloud-init-output.log`

---

**Last Updated**: November 2025  
**Terraform Version**: >= 1.0.0  
**AWS Provider**: ~> 4.0
