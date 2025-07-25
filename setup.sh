#!/bin/bash
set -e

log() {
  echo "[robot-setup] $1"
}

log "Deploying app manifests via kubectl..."
kubectl apply -k manifests/

log "Setup complete!