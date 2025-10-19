#!/bin/bash

# Single-Node K3s Demo Deployment Script
# This script deploys a minimal K3s cluster for demo purposes

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
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

print_demo() {
    echo -e "${PURPLE}[DEMO]${NC} $1"
}

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to check prerequisites
check_prerequisites() {
    print_status "Checking prerequisites for single-node demo..."
    
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
    if [ ! -f "inventory/single-node.yml" ]; then
        print_error "Single-node inventory file not found. Please create inventory/single-node.yml"
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
    print_status "Validating single-node inventory..."
    
    # Test SSH connectivity
    ansible all -i inventory/single-node.yml -m ping --one-line
    
    if [ $? -eq 0 ]; then
        print_success "SSH connectivity verified"
    else
        print_error "SSH connectivity failed. Please check your inventory and SSH keys."
        print_status "Make sure to update inventory/single-node.yml with your server details"
        exit 1
    fi
}

# Function to deploy demo infrastructure
deploy_demo_infrastructure() {
    print_demo "Deploying single-node K3s demo cluster..."
    
    # Deploy demo setup
    ansible-playbook -i inventory/single-node.yml demo-setup.yml
    
    print_success "Demo infrastructure deployed"
}

# Function to deploy kagent
deploy_kagent() {
    print_demo "Deploying kagent on demo cluster..."
    
    ansible-playbook -i inventory/single-node.yml kagent-demo.yml
    
    print_success "Kagent deployed on demo cluster"
}

# Function to show demo information
show_demo_info() {
    print_demo "Demo deployment completed! Here's what you can do:"
    echo ""
    
    # Get demo IP from inventory
    DEMO_IP=$(grep -A 5 "k3s-demo:" inventory/single-node.yml | grep "ansible_host:" | awk '{print $2}' | tr -d '"')
    
    if [ -n "$DEMO_IP" ]; then
        echo -e "${GREEN}🎯 Demo Cluster Access:${NC}"
        echo -e "  • K3s Master: ${DEMO_IP}"
        echo -e "  • Demo App: http://demo.${DEMO_IP}.nip.io"
        echo -e "  • Kagent Dashboard: http://kagent.${DEMO_IP}.nip.io"
        echo ""
        echo -e "${GREEN}🔧 Management Commands:${NC}"
        echo -e "  • Copy kubeconfig: scp ubuntu@${DEMO_IP}:./kubeconfig-demo ~/.kube/config"
        echo -e "  • Check cluster: kubectl get nodes"
        echo -e "  • Check demo app: kubectl get pods -n demo"
        echo -e "  • Check kagent: kubectl get pods -n kagent"
        echo ""
        echo -e "${GREEN}🎪 Demo Scenarios:${NC}"
        echo -e "  • 'Show me all pods in the cluster'"
        echo -e "  • 'Scale the demo-nginx deployment to 3 replicas'"
        echo -e "  • 'Check the health of all services'"
        echo -e "  • 'Create a new namespace called production'"
    else
        print_warning "Could not determine demo IP. Check inventory/single-node.yml"
    fi
}

# Function to show help
show_help() {
    echo "Single-Node K3s Demo Deployment Script"
    echo ""
    echo "Usage: $0 [OPTIONS]"
    echo ""
    echo "Options:"
    echo "  --infrastructure    Deploy only K3s + demo app (no kagent)"
    echo "  --kagent           Deploy kagent on existing cluster"
    echo "  --full             Deploy everything (default)"
    echo "  --check            Check prerequisites only"
    echo "  --help             Show this help message"
    echo ""
    echo "Examples:"
    echo "  $0                 # Deploy complete demo"
    echo "  $0 --infrastructure # Deploy only K3s + demo app"
    echo "  $0 --kagent        # Add kagent to existing cluster"
    echo "  $0 --check         # Check prerequisites"
    echo ""
    echo "Prerequisites:"
    echo "  1. Update inventory/single-node.yml with your server IP"
    echo "  2. Ensure SSH access to the server"
    echo "  3. Server should have at least 4GB RAM and 2 CPU cores"
}

# Main function
main() {
    # Parse command line arguments
    case "${1:-}" in
        --infrastructure)
            check_prerequisites
            install_dependencies
            validate_inventory
            deploy_demo_infrastructure
            print_success "Demo infrastructure deployment completed"
            ;;
        --kagent)
            check_prerequisites
            install_dependencies
            validate_inventory
            deploy_kagent
            show_demo_info
            ;;
        --full|"")
            check_prerequisites
            install_dependencies
            validate_inventory
            deploy_demo_infrastructure
            deploy_kagent
            show_demo_info
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
