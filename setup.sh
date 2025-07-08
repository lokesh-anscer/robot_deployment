#!/bin/bash
set -e

log() {
  echo "[robot-setup] $1"
}

log "Waiting for Kubernetes API to become available..."
until kubectl get nodes &>/dev/null; do
  echo "[robot-setup] Waiting for K3s to be ready..."
  sleep 3
done

log "Deploying app manifests via kubectl..."
kubectl apply -k manifest/

log "Setup complete!"