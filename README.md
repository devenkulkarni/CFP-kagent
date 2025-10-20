# SUSECON2026 - AIOps and GitOps for Cloud-Native Infrastructure

## CFP WIP: AIOps, ChatOps, and GitOps for Kubernetes and Harvester

This repository houses proof-of-concept demonstrations and materials for a proposed session at SUSECON 2026, focusing on advanced operations (AIOps, GitOps, ChatOps) for SUSE's cloud-native technologies.

Idea is to have:

Kagent for prompting interface, working aiops model diagnostic agent with mcp tools argocd(gitops approach for ai suggested changes human in loop approvals), k8s, prometheus + other tools

### WIP Topics

[1] **Kagent + AIOps + Custom k8s+git MCP server [GitOps] + ChatOps to manage RKE2 k8s cluster And/Or Harvester cluster**
*A talk on building an AI agent (Kagent) that interacts with Kubernetes (RKE2) and/or Harvester via a custom Model Context Protocol (MCP) server. The server acts as a control plane for GitOps workflows, allowing the AI to manage infrastructure and applications through ChatOps.*

[2] **Kagent + AIOps + Custom k8s+git MCP server [GitOps] + ChatOps to handle alerts from Prometheus for RKE2 cluster**
*A session detailing the integration of Kagent and an MCP server with Prometheus. The AI agent processes alerts, correlates them, executes runbooks stored in a GitOps repository via the MCP server, and communicates the resolution steps back through ChatOps.*

***

### Proposed Architecture:

| Component          | Technology                        | Role                                                                                                                                 | MCP Server / Tool                                                 |
|--------------------|-----------------------------------|--------------------------------------------------------------------------------------------------------------------------------------|-------------------------------------------------------------------|
| AI Orchestrator    | Kagent Agent                      | The main intelligence. Takes a natural language request, breaks it down, uses tools to execute, and manages the end-to-end workflow. | N/A (Runs the flow)                                               |
| Cluster Management | RKE2/Kubernetes                   | Executes kubectl commands (e.g., to check cluster state before/after changes).                                                       | Kubernetes MCP Server (Comes with Kagent)                         |
| Git Management     | GitHub/Git                        | Creates the YAML manifest, commits it to a new branch, and opens a Pull Request for human review.                                    | Custom Git MCP Server (The key piece you need to build/configure) | 
| CD Automation      | ArgoCD                            | Applies the approved changes to the cluster once the PR is merged.                                                                   | ArgoCD MCP Server (Likely a custom tool or extension)             | 
| Human Interface    | ChatOps Tool (e.g., Slack, Teams) | Where the user makes the request, receives the PR link, and gets the final confirmation.                                             | ChatOps Tool MCP Server (For bidirectional communication)         | 



## 2. Prerequisites
- Kubernetes cluster and kubectl to interact with it.
- Helm
- Kagent

## 3. Create custom or modify existing MCP server/tools in kagent to handle k8s + gitops workflow.

## 4. Have human loop to review PRs / Actions to be performed by Kagent for accountability.
