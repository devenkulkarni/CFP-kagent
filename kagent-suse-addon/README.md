# Kagent Add-on

This directory contains the kagent add-on providing AIOps, GitOps, and ChatOps capabilities using Ollama (local LLM) or GPT API (OpenAI) for intelligent automation.

## 🏗️ Architecture

```
Base Infrastructure Layer
├── Kubernetes Cluster ✅
├── Ollama LLM (optional) ✅
├── Prometheus Monitoring ✅
└── Kagent Add-on (This Layer)
    ├── Kagent AI Agent (Ollama or GPT API)
    ├── MCP Tools (K8s + Git + Prometheus)
    ├── GitOps with ArgoCD
    └── ChatOps Dashboard
```

## 🚀 Quick Start

### Prerequisites

1. **Kubernetes cluster** - Ensure you have a running Kubernetes cluster with kubectl configured

2. **LLM Provider** - Choose one of the following:
   - **Ollama** (local LLM): Deploy Ollama in your cluster or use an external Ollama instance
   - **OpenAI GPT API**: Configure an API key for GPT-4 or other OpenAI models

3. **Configure kagent add-on:**
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
kagent-addon/
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
│       └── hosts.yml              # Inventory for Kubernetes cluster
└── docs/
    ├── integration-guide.md       # Integration documentation
    └── demo-scenarios.md          # Demo scenarios
```

## 🎯 Features

- **AIOps**: Intelligent diagnostics and automation
- **GitOps**: AI-suggested changes through Git workflow
- **ChatOps**: Natural language interface for operations
- **MCP Integration**: Kubernetes, Git, and Prometheus tools
- **Flexible LLM Integration**: Uses Ollama (local) or GPT API (OpenAI) for AI operations

## 🔧 Configuration

Edit `config/kagent-config.yml` to configure:

- API keys for external LLM providers
- Git repository settings for GitOps
- Prometheus endpoints for monitoring
- Kagent resource requirements

## 📊 Access

After deployment:
- **Kagent Dashboard**: `http://kagent.<cluster-ip>.nip.io`
- **ArgoCD GitOps**: `http://argocd.<cluster-ip>.nip.io`
- **Prometheus Monitoring**: Access via your monitoring stack

## 🎪 Demo Scenarios

See `docs/demo-scenarios.md` for presentation-ready demos including:
- Infrastructure management via ChatOps
- AI-powered troubleshooting using Ollama or GPT API
- GitOps workflow demonstrations
- Integration with Kubernetes and monitoring components
