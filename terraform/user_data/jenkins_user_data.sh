#!/bin/bash#!/bin/bash

set -eset -e



echo "=== Starting Jenkins + Docker + Kubernetes Setup ==="echo "=== Starting Jenkins Setup ==="

date

# Ensure script is run as root

# ============================================================================if [ "$EUID" -ne 0 ]; then

# SYSTEM UPDATES  echo "Please run this script as root (use sudo)."

# ============================================================================  exit 1

echo "Step 1: Updating system packages..."fi

yum update -y

yum install -y wget curl git# Update system packages

echo "Updating system packages..."

# ============================================================================yum update -y

# JAVA INSTALLATION (Required for Jenkins)

# ============================================================================# Install required utilities

echo "Step 2: Installing Java 11..."echo "Installing wget and Java 11..."

yum install -y java-11-amazon-correttoyum install -y wget java-11-amazon-corretto



echo "Java installed:"# Add Jenkins repository (updated key)

java -versionecho "Adding Jenkins repository..."

wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo

# ============================================================================rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key

# JENKINS INSTALLATION

# ============================================================================# Install Jenkins

echo "Step 3: Installing Jenkins..."echo "Installing Jenkins..."

wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repoyum install -y jenkins

rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key

yum install -y jenkins# Enable and start Jenkins

echo "Starting Jenkins..."

# ============================================================================systemctl daemon-reload

# DOCKER INSTALLATIONsystemctl enable jenkins

# ============================================================================systemctl start jenkins

echo "Step 4: Installing Docker..."

yum install -y docker# Install Docker for Jenkins builds

echo "Installing Docker..."

# ============================================================================yum install -y docker

# DOCKER COMPOSE INSTALLATION

# ============================================================================# Enable and start Docker

echo "Step 5: Installing Docker Compose..."echo "Starting Docker..."

curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-composesystemctl daemon-reload

chmod +x /usr/local/bin/docker-composesystemctl enable docker

docker-compose --versionsystemctl start docker



# ============================================================================# Add Jenkins user to Docker group

# KUBECTL INSTALLATION (for Kubernetes)echo "Adding Jenkins user to Docker group..."

# ============================================================================usermod -aG docker jenkins

echo "Step 6: Installing kubectl..."

curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"# Wait for services to fully start

install -o root -g root -m 0755 kubectl /usr/local/bin/kubectlsleep 5

kubectl version --client

# Display service statuses

# ============================================================================echo "Checking service statuses..."

# CONFIGURE SYSTEMDsystemctl status jenkins --no-pager

# ============================================================================systemctl status docker --no-pager

echo "Step 7: Configuring systemd services..."

systemctl daemon-reloadecho "=== Jenkins Setup Complete ==="

echo "Access Jenkins at: http://<your-ec2-public-ip>:8080"

# ============================================================================echo "Use this command to get the initial admin password:"

# START DOCKERecho "  sudo cat /var/lib/jenkins/secrets/initialAdminPassword"

# ============================================================================
echo "Step 8: Starting Docker service..."
systemctl enable docker
systemctl start docker

# Add jenkins user to docker group (allows Jenkins to use Docker without sudo)
usermod -a -G docker jenkins

# Verify docker is running
systemctl status docker --no-pager

# ============================================================================
# START JENKINS
# ============================================================================
echo "Step 9: Starting Jenkins service..."
systemctl enable jenkins
systemctl start jenkins

# Wait for Jenkins to fully initialize
echo "Step 10: Waiting for Jenkins to initialize (this may take 1-2 minutes)..."
sleep 15

# Attempt to retrieve initial admin password
JENKINS_INIT_PASSWORD_FILE="/var/lib/jenkins/secrets/initialAdminPassword"
if [ -f "$JENKINS_INIT_PASSWORD_FILE" ]; then
    echo "=== Jenkins Initial Admin Password ==="
    cat "$JENKINS_INIT_PASSWORD_FILE"
    echo "=== End of Password ==="
else
    echo "Password file will be available shortly at: $JENKINS_INIT_PASSWORD_FILE"
fi

# ============================================================================
# VERIFY INSTALLATIONS
# ============================================================================
echo "Step 11: Verifying installations..."

echo "Java version:"
java -version

echo "Docker version:"
docker --version

echo "Docker Compose version:"
docker-compose --version

echo "kubectl version:"
kubectl version --client

echo "Jenkins status:"
systemctl status jenkins --no-pager

echo "Docker status:"
systemctl status docker --no-pager

# ============================================================================
# VERIFY PORT LISTENING
# ============================================================================
echo "Step 12: Verifying ports are listening..."
netstat -tlnp | grep LISTEN || echo "netstat not fully available in all environments"

# ============================================================================
# DISPLAY ENDPOINTS
# ============================================================================
echo ""
echo "==================================="
echo "SETUP COMPLETE!"
echo "==================================="
echo "Jenkins URL: http://$(hostname -I | awk '{print $1}'):8080"
echo "Docker: Ready"
echo "Docker Compose: Ready"
echo "kubectl: Ready for Kubernetes operations"
echo ""
echo "Jenkins will be fully ready in ~1-2 minutes."
echo "Initial admin password is stored in: $JENKINS_INIT_PASSWORD_FILE"
echo "==================================="
