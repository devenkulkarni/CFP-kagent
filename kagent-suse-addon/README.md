# Kagent SUSE AI Stack Add-on

This directory contains the kagent add-on for the SUSE AI Stack, providing AIOps, GitOps, and ChatOps capabilities on top of the existing SUSE AI infrastructure.

## 🏗️ Architecture

```
SUSE AI Stack (Base Layer)
├── RKE2 Kubernetes ✅
├── Ollama LLM ✅
├── Open WebUI ✅
├── Milvus Vector DB ✅
├── SUSE Observability ✅
└── Kagent Add-on (This Layer)
    ├── Kagent AI Agent
    ├── MCP Tools (K8s + Git + Prometheus)
    ├── GitOps with ArgoCD
    └── ChatOps Dashboard
```

## 🚀 Quick Start

### Prerequisites

1. **Deploy SUSE AI Stack first:**
   ```bash
   cd suse-ai-stack
   ./setup_private_ai_stack.sh
   ```

2. **Configure kagent add-on:**
   ```bash
   cp config/kagent-config.yml.example config/kagent-config.yml
   # Edit kagent-config.yml with your settings
   ```

3. **Deploy kagent add-on:**
   ```bash
   ansible-playbook -i inventory/hosts.yml playbooks/deploy-kagent-addon.yml
   ```

## 📁 Structure

```
kagent-suse-addon/
├── playbooks/
│   ├── deploy-kagent-addon.yml    # Main deployment playbook
│   └── configure-gitops.yml       # GitOps configuration
├── roles/
│   ├── kagent-deployment/         # Kagent deployment role
│   ├── mcp-tools/                 # MCP tools configuration
│   └── gitops-setup/              # GitOps setup role
├── config/
│   ├── kagent-config.yml.example  # Configuration template
│   └── inventory/
│       └── hosts.yml              # Inventory for SUSE AI Stack
└── docs/
    ├── integration-guide.md       # Integration documentation
    └── demo-scenarios.md          # Demo scenarios
```

## 🎯 Features

- **AIOps**: Intelligent diagnostics and automation
- **GitOps**: AI-suggested changes through Git workflow
- **ChatOps**: Natural language interface for operations
- **MCP Integration**: Kubernetes, Git, and Prometheus tools
- **SUSE AI Stack Integration**: Leverages existing Ollama and observability

## 🔧 Configuration

Edit `config/kagent-config.yml` to configure:

- API keys for external LLM providers
- Git repository settings for GitOps
- Prometheus endpoints for monitoring
- Kagent resource requirements

## 📊 Access

After deployment:
- **Kagent Dashboard**: `http://kagent.<cluster-ip>.nip.io`
- **Open WebUI**: `http://openwebui.<cluster-ip>.nip.io` (from SUSE AI Stack)
- **SUSE Observability**: Access via Rancher Prime

## 🎪 Demo Scenarios

See `docs/demo-scenarios.md` for presentation-ready demos including:
- Infrastructure management via ChatOps
- AI-powered troubleshooting
- GitOps workflow demonstrations
- Integration with SUSE AI Stack components
