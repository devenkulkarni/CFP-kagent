#!/bin/bash

# Kagent SUSE AI Stack Add-on Deployment Script
# This script deploys kagent on top of an existing SUSE AI Stack

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
    print_status "Checking prerequisites for kagent add-on..."
    
    # Check if Ansible is installed
    if ! command_exists ansible; then
        print_error "Ansible is not installed. Please install it first."
        print_status "Install with: pip install ansible"
        exit 1
    fi
    
    # Check if kubectl is installed
    if ! command_exists kubectl; then
        print_error "kubectl is not installed. Please install it first."
        exit 1
    fi
    
    # Check if SUSE AI Stack is running
    if ! kubectl get nodes >/dev/null 2>&1; then
        print_error "SUSE AI Stack cluster is not accessible."
        print_status "Please ensure SUSE AI Stack is deployed and kubectl is configured."
        exit 1
    fi
    
    # Check if Ollama is running
    if ! kubectl get pods -n ollama >/dev/null 2>&1; then
        print_warning "Ollama namespace not found. SUSE AI Stack may not be fully deployed."
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
    
    print_success "Dependencies installed"
}

# Function to validate configuration
validate_config() {
    print_status "Validating kagent configuration..."
    
    if [ ! -f "config/kagent-config.yml" ]; then
        print_error "Configuration file not found: config/kagent-config.yml"
        print_status "Please copy config/kagent-config.yml.example to config/kagent-config.yml and configure it."
        exit 1
    fi
    
    # Check if API keys are set
    if grep -q "your-openai-api-key-here" config/kagent-config.yml; then
        print_warning "OpenAI API key not configured. Kagent will use Ollama only."
    fi
    
    if grep -q "your-anthropic-api-key-here" config/kagent-config.yml; then
        print_warning "Anthropic API key not configured. Kagent will use Ollama only."
    fi
    
    print_success "Configuration validated"
}

# Function to deploy kagent add-on
deploy_kagent() {
    print_demo "Deploying kagent add-on to SUSE AI Stack..."
    
    # Load configuration
    export ANSIBLE_EXTRA_VARS="@config/kagent-config.yml"
    
    # Deploy kagent add-on
    ansible-playbook -i config/inventory/hosts.yml playbooks/deploy-kagent-addon.yml
    
    print_success "Kagent add-on deployed"
}

# Function to show access information
show_access_info() {
    print_demo "Kagent add-on deployment completed! Access information:"
    echo ""
    
    # Get cluster IP from config
    CLUSTER_IP=$(grep "cluster_ip:" config/kagent-config.yml | awk '{print $2}' | tr -d '"')
    
    if [ -n "$CLUSTER_IP" ]; then
        echo -e "${GREEN}🎯 Kagent Add-on Access:${NC}"
        echo -e "  • Kagent Dashboard: http://kagent.${CLUSTER_IP}.nip.io"
        echo -e "  • ArgoCD GitOps: http://argocd.${CLUSTER_IP}.nip.io"
        echo -e "  • Open WebUI: http://openwebui.${CLUSTER_IP}.nip.io (from SUSE AI Stack)"
        echo ""
        echo -e "${GREEN}🔧 Management Commands:${NC}"
        echo -e "  • Check kagent: kubectl get pods -n kagent"
        echo -e "  • Check ArgoCD: kubectl get pods -n argocd"
        echo -e "  • Port-forward kagent: kubectl port-forward -n kagent svc/kagent 8080:80"
        echo ""
        echo -e "${GREEN}🎪 Demo Scenarios:${NC}"
        echo -e "  • 'Show me all pods in the cluster'"
        echo -e "  • 'Scale the demo app to 3 replicas'"
        echo -e "  • 'Check the health of all services'"
        echo -e "  • 'Create a new namespace called production'"
    else
        print_warning "Could not determine cluster IP. Check config/kagent-config.yml"
    fi
}

# Function to show help
show_help() {
    echo "Kagent SUSE AI Stack Add-on Deployment Script"
    echo ""
    echo "Usage: $0 [OPTIONS]"
    echo ""
    echo "Options:"
    echo "  --check            Check prerequisites only"
    echo "  --deploy           Deploy kagent add-on"
    echo "  --help             Show this help message"
    echo ""
    echo "Prerequisites:"
    echo "  1. SUSE AI Stack must be deployed and running"
    echo "  2. kubectl must be configured to access the cluster"
    echo "  3. Copy config/kagent-config.yml.example to config/kagent-config.yml"
    echo "  4. Configure API keys in config/kagent-config.yml"
    echo ""
    echo "Examples:"
    echo "  $0 --check         # Check prerequisites"
    echo "  $0 --deploy        # Deploy kagent add-on"
}

# Main function
main() {
    # Parse command line arguments
    case "${1:-}" in
        --check)
            check_prerequisites
            validate_config
            print_success "Prerequisites check completed"
            ;;
        --deploy)
            check_prerequisites
            install_dependencies
            validate_config
            deploy_kagent
            show_access_info
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
