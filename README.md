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

## 2. Prerequisites
- Kubernetes cluster and kubectl to interact with it.
- Helm
- Kagent

## 3. Create custom or modify existing MCP server/tools in kagent to handle k8s + gitops workflow.

## 4. Have human loop to review PRs / Actions to be performed by Kagent for accountability.
