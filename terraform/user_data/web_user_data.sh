#!/bin/bash
set -e

echo "=== Starting Web Server Setup ==="

# Update system packages
echo "Updating system packages..."
yum update -y

# Install nginx
echo "Installing nginx..."
amazon-linux-extras install -y nginx1

# Create nginx configuration directory if it doesn't exist
mkdir -p /etc/nginx/conf.d

# Configure nginx to listen on port 8080
echo "Configuring nginx for port 8080..."
cat > /etc/nginx/conf.d/custom.conf <<'EOF'
server {
    listen       8080 default_server;
    listen       [::]:8080 default_server;
    server_name  _;
    root /usr/share/nginx/html;
    index index.html index.htm;

    location / {
        try_files $uri $uri/ =404;
    }

    # Enable gzip compression
    gzip on;
    gzip_types text/plain text/css text/javascript application/json;
}
EOF

# Create Nginx web root
mkdir -p /usr/share/nginx/html

# Copy pre-existing static website files if available
# (Assumes Terraform or scp has uploaded your website to /home/ec2-user/website)
if [ -d "/home/ec2-user/website" ]; then
    echo "Copying website files to Nginx directory..."
    cp -r /home/ec2-user/website/* /usr/share/nginx/html/
else
    echo "⚠️ No website directory found in /home/ec2-user/website — skipping file copy."
fi

# Set correct permissions
chmod -R 755 /usr/share/nginx/html

# Enable and start nginx
echo "Starting nginx..."
systemctl daemon-reload
systemctl enable nginx
systemctl start nginx

# Wait a moment for nginx to fully start
sleep 3

# Check nginx status
echo "Checking nginx status..."
systemctl status nginx --no-pager || true

# Verify nginx is listening on port 8080
echo "Verifying port 8080 is listening..."
netstat -tlnp | grep 8080 || echo "Port 8080 check (may not be available in all environments)"

echo "=== Web Server Setup Complete ==="
