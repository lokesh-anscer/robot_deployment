# Robot Deployment Kubernetes Manifests

This repository contains Kubernetes manifests and setup scripts for deploying Gitea and Grafana in a GitOps workflow using K3s. It is designed for rapid setup on a new device, including configuration for local container registry access and namespace management.

## Repository Structure

```
setup.sh
manifests/
  kustomization.yaml
  gitea/
    deployment.yaml
    kustomization.yaml
    service.yaml
  grafana/
    deployment.yaml
    kustomization.yaml
    service.yaml
  namespace/
    kustomization.yaml
    namespace.yaml
```

- **setup.sh**: Automates K3s configuration, registry setup, and applies all manifests.
- **manifests/**: Contains all Kubernetes resources organized by component and namespace.
  - **gitea/**: Manifests for Gitea deployment and service in the `git-tools` namespace.
  - **grafana/**: Manifests for Grafana deployment and service in the `monitoring` namespace.
  - **namespace/**: Namespace definitions and kustomization for `git-tools` and `monitoring`.
  - **kustomization.yaml**: Top-level Kustomize file to aggregate all resources.

## Setup Instructions

### Prerequisites

- Linux device with root access
- [K3s](https://k3s.io/) installed (or let the script handle it)
- [kubectl](https://kubernetes.io/docs/tasks/tools/) installed

### Steps

1. **Clone the repository**
   ```sh
   git clone <repo-url>
   cd robot_deployment
   ```

2. **Run the setup script**
   ```sh
   chmod +x setup.sh
   sudo ./setup.sh
   ```

   This script will:
   - Ensure K3s kubeconfig is readable for non-root users
   - Remount root filesystem if needed
   - Configure containerd to trust the local registry (`192.168.31.85:5000`)
   - Apply all Kubernetes manifests using Kustomize

3. **Verify deployment**
   - Check namespaces:
     ```sh
     kubectl get namespaces
     ```
   - Check pods:
     ```sh
     kubectl get pods -n git-tools
     kubectl get pods -n monitoring
     ```
   - Check services:
     ```sh
     kubectl get svc -n git-tools
     kubectl get svc -n monitoring
     ```

## File Overview

- **namespace.yaml**: Defines `git-tools` and `monitoring` namespaces with annotations.
- **manifests/gitea/**: Deploys Gitea in `git-tools` namespace.
- **manifests/grafana/**: Deploys Grafana in `monitoring` namespace.
- **kustomization.yaml**: Aggregates all resources for deployment.
- **setup.sh**: Handles system and Kubernetes setup, registry config, and applies manifests.

## Notes

- Images are pulled from a local registry at `192.168.31.85:5000`. Ensure this registry is accessible from your device.
- The script is idempotent and safe to run multiple times.
- Argo CD or other GitOps tools can be used to sync and manage these manifests after initial setup.

## Maintainer

- Lokesh (app.kubernetes.io/maintainer annotation)