# # !/bin/bash
# set -e

# echo "[robot-setup] Starting robot setup.."

# ##
# echo "[robot-setup] Waiting for K3s to be ready.."
# until kubectl get nodes &>/dev/null; do
#     echo -n "."
#     sleep 2
# done
# echo "[robot-setup] K3s is ready!"

##
# if kubectl get ns argocd >/dev/null 2>&1; then
#     echo "[robot-setup] Argo CD already installed."
# else
#     echo "[robot-setup] Installing Argo CD.."

#     kubectl create namespace argocd

#     # Installation
#     if [ -f "bootstrap/argo-install.yaml" ]; then
#         echo "[robot-setup] Using local Argo CD manifest.."
#         kubectl apply -n argocd -f bootstrap/argo-install.yaml
#     else
#         echo "[robot-setup] Downloading Argo CD manifest.."
#         kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
#     fi

#     echo "[robot-setup] Waiting for Argo CD server to be ready..."
#     kubectl rollout status deployment argocd-server -n argocd --timeout=300s
# fi

# echo "[robot-setup] Applying manifests (gitea, grafana, upgrade)..."
# kubectl apply -k manifests/

# if [ -f "argo-cd/app.yaml" ]; then
#     echo "[robot-setup] Registering robot Argo CD application..."
#     kubectl apply -f argo-cd/app.yaml
# fi

# echo "[robot-setup] Robot setup complete! Check pods with:"


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

log "Setup complete!