#!/bin/bash
set -e

# Update and install required packages
yum update -y
amazon-linux-extras install java-openjdk11 -y

# Add Jenkins repository and install Jenkins
wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key
yum install jenkins -y

# Enable and start Jenkins service
systemctl enable jenkins
systemctl start jenkins
