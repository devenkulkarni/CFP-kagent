#!/bin/bash

# Kagent Deployment Script
# This script automates the deployment of kagent using Ansible

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to check prerequisites
check_prerequisites() {
    print_status "Checking prerequisites..."
    
    # Check if Ansible is installed
    if ! command_exists ansible; then
        print_error "Ansible is not installed. Please install it first."
        print_status "Install with: pip install ansible"
        exit 1
    fi
    
    # Check if Python is installed
    if ! command_exists python3; then
        print_error "Python 3 is not installed. Please install it first."
        exit 1
    fi
    
    # Check if inventory file exists
    if [ ! -f "inventory/hosts.yml" ]; then
        print_error "Inventory file not found. Please create inventory/hosts.yml"
        exit 1
    fi
    
    print_success "Prerequisites check passed"
}

# Function to install dependencies
install_dependencies() {
    print_status "Installing Ansible dependencies..."
    
    # Install Ansible collections
    if [ -f "requirements.yml" ]; then
        ansible-galaxy install -r requirements.yml
    fi
    
    # Install Python packages
    if [ -f "requirements.txt" ]; then
        pip install -r requirements.txt
    fi
    
    print_success "Dependencies installed"
}

# Function to validate inventory
validate_inventory() {
    print_status "Validating inventory..."
    
    # Test SSH connectivity
    ansible all -m ping --one-line
    
    if [ $? -eq 0 ]; then
        print_success "SSH connectivity verified"
    else
        print_error "SSH connectivity failed. Please check your inventory and SSH keys."
        exit 1
    fi
}

# Function to deploy infrastructure
deploy_infrastructure() {
    print_status "Deploying infrastructure..."
    
    # Deploy common setup
    print_status "Setting up common packages and configuration..."
    ansible-playbook playbook.yml --tags "common"
    
    # Deploy K3s
    print_status "Installing K3s cluster..."
    ansible-playbook playbook.yml --tags "k3s"
    
    # Deploy kubectl and Helm
    print_status "Installing kubectl and Helm..."
    ansible-playbook playbook.yml --tags "kubectl,helm"
    
    print_success "Infrastructure deployed"
}

# Function to deploy kagent
deploy_kagent() {
    print_status "Deploying kagent..."
    
    ansible-playbook playbook.yml --tags "kagent"
    
    print_success "Kagent deployed"
}

# Function to show access information
show_access_info() {
    print_status "Deployment completed! Access information:"
    echo ""
    
    # Get master IP from inventory
    MASTER_IP=$(grep -A 10 "k3s-master:" inventory/hosts.yml | grep "ansible_host:" | awk '{print $2}' | tr -d '"')
    
    if [ -n "$MASTER_IP" ]; then
        echo -e "${GREEN}Kagent Dashboard:${NC} http://kagent.${MASTER_IP}.nip.io"
        echo -e "${GREEN}Port Forward:${NC} kubectl port-forward -n kagent svc/kagent 8080:80"
        echo -e "${GREEN}Local Access:${NC} http://localhost:8080"
        echo ""
        echo -e "${GREEN}Kubeconfig:${NC} scp ubuntu@${MASTER_IP}:~/.kube/config ~/.kube/config"
        echo -e "${GREEN}Cluster Status:${NC} kubectl get nodes"
    else
        print_warning "Could not determine master IP. Check inventory/hosts.yml"
    fi
}

# Function to show help
show_help() {
    echo "Kagent Deployment Script"
    echo ""
    echo "Usage: $0 [OPTIONS]"
    echo ""
    echo "Options:"
    echo "  --infrastructure    Deploy only infrastructure (K3s, kubectl, Helm)"
    echo "  --kagent           Deploy only kagent"
    echo "  --full             Deploy everything (default)"
    echo "  --check            Check prerequisites only"
    echo "  --help             Show this help message"
    echo ""
    echo "Examples:"
    echo "  $0                 # Deploy everything"
    echo "  $0 --infrastructure # Deploy only infrastructure"
    echo "  $0 --kagent        # Deploy only kagent"
    echo "  $0 --check         # Check prerequisites"
}

# Main function
main() {
    # Parse command line arguments
    case "${1:-}" in
        --infrastructure)
            check_prerequisites
            install_dependencies
            validate_inventory
            deploy_infrastructure
            print_success "Infrastructure deployment completed"
            ;;
        --kagent)
            check_prerequisites
            install_dependencies
            validate_inventory
            deploy_kagent
            show_access_info
            ;;
        --full|"")
            check_prerequisites
            install_dependencies
            validate_inventory
            deploy_infrastructure
            deploy_kagent
            show_access_info
            ;;
        --check)
            check_prerequisites
            print_success "Prerequisites check completed"
            ;;
        --help)
            show_help
            ;;
        *)
            print_error "Unknown option: $1"
            show_help
            exit 1
            ;;
    esac
}

# Run main function with all arguments
main "$@"
