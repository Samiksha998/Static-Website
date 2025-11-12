#!/bin/bash

# Kubernetes Deployment Script for Static Website Application
# This script deploys the application and demonstrates self-healing

set -e

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}Kubernetes Deployment Script${NC}"
echo -e "${BLUE}Static Website Application${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""

# Check kubectl
echo -e "${YELLOW}Checking kubectl...${NC}"
if ! command -v kubectl &> /dev/null; then
    echo -e "${RED}kubectl not found. Please install kubectl first.${NC}"
    exit 1
fi
kubectl version --client
echo -e "${GREEN}✓ kubectl is installed${NC}"
echo ""

# Check cluster connectivity
#!/usr/bin/env bash
echo "deploy.sh removed — this repo is now a minimal static site."
    echo -e "${RED}Cannot connect to Kubernetes cluster. Please configure kubeconfig.${NC}"
