# AIOps and GitOps for Cloud-Native Infrastructure

## AIOps, ChatOps, and GitOps for Kubernetes

This repository houses proof-of-concept demonstrations for advanced operations (AIOps, GitOps, ChatOps) for cloud-native technologies using AI agents powered by Ollama or GPT API.

Idea is to have:

Kagent for prompting interface, working aiops model diagnostic agent with mcp tools argocd(gitops approach for ai suggested changes human in loop approvals), k8s, prometheus + other tools. The AI agent can use either Ollama (local LLM) or GPT API (OpenAI) for intelligent automation.

### WIP Topics

[1] **Kagent + AIOps + Custom k8s+git MCP server [GitOps] + ChatOps to manage Kubernetes cluster**
*Building an AI agent (Kagent) powered by Ollama or GPT API that interacts with Kubernetes via a custom Model Context Protocol (MCP) server. The server acts as a control plane for GitOps workflows, allowing the AI to manage infrastructure and applications through ChatOps.*

[2] **Kagent + AIOps + Custom k8s+git MCP server [GitOps] + ChatOps to handle alerts from Prometheus for Kubernetes cluster**
*Integration of Kagent (using Ollama or GPT API) and an MCP server with Prometheus. The AI agent processes alerts, correlates them, executes runbooks stored in a GitOps repository via the MCP server, and communicates the resolution steps back through ChatOps.*

***

### Proposed Architecture:

| Component          | Technology                        | Role                                                                                                                                 | MCP Server / Tool                                                 |
|--------------------|-----------------------------------|--------------------------------------------------------------------------------------------------------------------------------------|-------------------------------------------------------------------|
| AI Orchestrator    | Kagent Agent + Ollama/GPT API    | The main intelligence powered by Ollama (local LLM) or GPT API (OpenAI). Takes a natural language request, breaks it down, uses tools to execute, and manages the end-to-end workflow. | N/A (Runs the flow)                                               |
| Cluster Management | Kubernetes                        | Executes kubectl commands (e.g., to check cluster state before/after changes).                                                       | Kubernetes MCP Server (Comes with Kagent)                         |
| Git Management     | GitHub/Git                        | Creates the YAML manifest, commits it to a new branch, and opens a Pull Request for human review.                                    | Custom Git MCP Server (The key piece you need to build/configure) | 
| CD Automation      | ArgoCD                            | Applies the approved changes to the cluster once the PR is merged.                                                                   | ArgoCD MCP Server (Likely a custom tool or extension)             | 
| Human Interface    | ChatOps Tool (e.g., Slack, Teams) | Where the user makes the request, receives the PR link, and gets the final confirmation.                                             | ChatOps Tool MCP Server (For bidirectional communication)         | 



## 2. Prerequisites
- Kubernetes cluster and kubectl to interact with it.
- Helm
- Kagent
- Ollama (for local LLM) or OpenAI API key (for GPT API)

## 3. Create custom or modify existing MCP server/tools in kagent to handle k8s + gitops workflow.

## 4. Have human loop to review PRs / Actions to be performed by Kagent for accountability.
