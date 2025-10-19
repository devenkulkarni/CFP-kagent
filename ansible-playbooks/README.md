# Kagent Ansible Playbooks

This directory contains Ansible playbooks for deploying a complete kagent environment on a K3s cluster running on SUSE Linux Enterprise 16 (SLE16). The setup includes K3s, kubectl, Helm, and kagent with external LLM providers (OpenAI/Anthropic).

## 🏗️ Architecture

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   K3s Master    │    │  K3s Worker 1   │    │  K3s Worker 2   │
│                 │    │                 │    │                 │
│ • K3s API       │    │ • K3s Agent     │    │ • K3s Agent     │
│ • kubectl       │    │ • Common tools  │    │ • Common tools  │
│ • Helm          │    │                 │    │                 │
│ • Kagent        │    │                 │    │                 │
│ • Dashboard     │    │                 │    │                 │
└─────────────────┘    └─────────────────┘    └─────────────────┘
```

## 📋 Prerequisites

### Local Machine
- Ansible 2.9+ installed
- SSH access to target servers
- Python 3.6+ on target servers

### Target Servers
- SUSE Linux Enterprise 16 (SLE16)
- Minimum 4GB RAM per node
- Minimum 2 CPU cores per node
- 20GB+ disk space per node
- SSH access with sudo privileges

## 🚀 Quick Start

### 1. Clone and Setup

```bash
git clone https://github.com/Spectro34/CFP-kagent.git
cd CFP-kagent/ansible-playbooks
```

### 2. Install Dependencies

```bash
# Install Ansible collections
ansible-galaxy install -r requirements.yml

# Install Python dependencies
pip install -r requirements.txt
```

### 3. Configure Inventory

Edit `inventory/hosts.yml` with your server details:

```yaml
all:
  children:
    k3s_cluster:
      hosts:
        k3s-master:
          ansible_host: "192.168.1.100"  # Your master IP
          ansible_user: "suse"
          ansible_ssh_private_key_file: "~/.ssh/id_rsa"
        k3s-worker-1:
          ansible_host: "192.168.1.101"  # Your worker IP
          ansible_user: "suse"
          ansible_ssh_private_key_file: "~/.ssh/id_rsa"
```

### 4. Configure Variables

Edit `group_vars/all.yml` to customize your deployment:

```yaml
# Key configurations
k3s_master_ip: "192.168.1.100"
k3s_token: "your-secure-token-here"
ollama_model: "llama3.1:8b"
kagent_namespace: "kagent"
```

### 5. Deploy Infrastructure Only (Recommended First)

```bash
# Deploy only K3s + kubectl + Helm (no kagent or Ollama)
ansible-playbook infrastructure-only.yml

# Or deploy specific components
ansible-playbook playbook.yml --tags "k3s"
ansible-playbook playbook.yml --tags "kubectl,helm"
```

### 6. Deploy Kagent Later (Optional)

```bash
# First, configure API keys in group_vars/all.yml
# Set: kagent_enabled: true
# Set: openai_api_key: "your-openai-api-key"
# Set: anthropic_api_key: "your-anthropic-api-key"

# Then deploy kagent
ansible-playbook playbook.yml --tags "kagent"
```

### 7. Quick Demo Deployment (Single-Node)

```bash
# Use the demo script for easy single-node deployment
./demo-deploy.sh --infrastructure  # Deploy K3s + demo app
./demo-deploy.sh --kagent         # Add kagent (requires API keys)
./demo-deploy.sh --full           # Deploy everything at once
```

## 🔧 Configuration

### Environment Variables

Create a `.env` file for sensitive data:

```bash
# .env file
K3S_TOKEN=your-secure-token-here
OPENAI_API_KEY=your-openai-api-key-here
ANTHROPIC_API_KEY=your-anthropic-api-key-here
SSH_PRIVATE_KEY=~/.ssh/id_rsa
```

### Customization Options

| Variable | Default | Description |
|----------|---------|-------------|
| `k3s_version` | `v1.28.5+k3s1` | K3s version to install |
| `k3s_token` | `kagent-token-12345` | Cluster token |
| `kagent_enabled` | `false` | Enable kagent deployment |
| `openai_api_key` | `your-openai-api-key-here` | OpenAI API key for LLM |
| `anthropic_api_key` | `your-anthropic-api-key-here` | Anthropic API key for LLM |
| `kagent_namespace` | `kagent` | Kubernetes namespace |

## 📊 Accessing Services

### Kagent Dashboard

After deployment, access the kagent dashboard:

```bash
# Option 1: Direct access (if nip.io works)
http://kagent.192.168.1.100.nip.io

# Option 2: Port forward
kubectl port-forward -n kagent svc/kagent 8080:80
# Then access: http://localhost:8080
```

### K3s Cluster

```bash
# Copy kubeconfig to local machine
scp ubuntu@192.168.1.100:~/.kube/config ~/.kube/config

# Verify cluster
kubectl get nodes
kubectl get pods -n kagent
```

## 🛠️ Playbook Structure

```
ansible-playbooks/
├── ansible.cfg              # Ansible configuration
├── playbook.yml             # Main playbook (multi-node)
├── demo-setup.yml           # Single-node demo setup
├── kagent-demo.yml          # Kagent demo deployment
├── infrastructure-only.yml  # Infrastructure only
├── demo-deploy.sh           # Demo deployment script
├── requirements.yml         # Dependencies
├── inventory/
│   ├── hosts.yml           # Multi-node inventory
│   └── single-node.yml     # Single-node inventory
├── group_vars/
│   └── all.yml             # Global variables
└── roles/
    ├── common/             # Common system setup (SLE16)
    ├── k3s/               # K3s installation
    ├── kubectl-helm/      # kubectl and Helm setup
    └── kagent/            # Kagent deployment (external LLM)
```

## 🎯 Use Cases

### 1. Single-Node Demo Setup

```bash
# Deploy basic K3s cluster for demos
ansible-playbook -i inventory/single-node.yml demo-setup.yml

# Add kagent with external LLM
ansible-playbook -i inventory/single-node.yml kagent-demo.yml
```

### 2. Infrastructure Management

```bash
# Access kagent dashboard and ask:
"Scale my app to 5 replicas"
"Create a new namespace called 'production'"
"Show me all pods with high memory usage"
```

### 3. Alert Management

```bash
# Kagent will automatically:
# - Monitor Prometheus alerts
# - Analyze metrics and logs
# - Execute runbooks
# - Report resolution steps
```

## 🔍 Troubleshooting

### Common Issues

1. **SSH Connection Failed**
   ```bash
   # Test SSH connection
   ansible all -m ping
   
   # Check SSH key permissions
   chmod 600 ~/.ssh/id_rsa
   ```

2. **K3s Installation Failed**
   ```bash
   # Check system requirements
   ansible k3s_cluster -m setup -a "filter=ansible_memtotal_mb"
   
   # Verify firewall settings
   ansible k3s_cluster -m firewalld -a "state=enabled"
   ```

3. **Kagent Not Starting**
   ```bash
   # Check pod logs
   kubectl logs -n kagent deployment/kagent
   
   # Verify API keys are set
   kubectl get secret -n kagent kagent-secrets
   
   # Check kagent pods
   kubectl get pods -n kagent
   ```

### Logs and Debugging

```bash
# Check K3s logs
sudo journalctl -u k3s -f

# Check kagent logs
kubectl logs -n kagent deployment/kagent -f

# Check kagent configuration
kubectl get configmap -n kagent kagent-config -o yaml
```

## 🔄 Maintenance

### Updating Kagent

```bash
# Update kagent version in group_vars/all.yml
kagent_version: "latest"

# Re-run playbook
ansible-playbook playbook.yml --tags "kagent"
```

### Updating API Keys

```bash
# Edit group_vars/all.yml
openai_api_key: "new-openai-api-key"
anthropic_api_key: "new-anthropic-api-key"

# Apply changes
ansible-playbook playbook.yml --tags "kagent"
```

## 📚 Additional Resources

- [Kagent Documentation](https://kagent.dev)
- [K3s Documentation](https://k3s.io)
- [SUSE Linux Enterprise Documentation](https://documentation.suse.com/sle/16/)
- [Ansible Documentation](https://docs.ansible.com)

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test with your environment
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🆘 Support

For issues and questions:
- Create an issue in this repository
- Check the troubleshooting section above
- Review the kagent documentation
