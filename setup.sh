#!/bin/bash
set -e

echo "Starting deployment..."

VERSIONS_FILE="versions.yaml"
OVERLAY_DIR="manifests/overlays/dev"

command -v yq >/dev/null || { echo "yq not found. Install with: sudo apt install yq"; exit 1; }

GRAFANA_IMAGE=$(yq '.apps.grafana.image' "$VERSIONS_FILE")
GRAFANA_TAG=$(yq '.apps.grafana.tag' "$VERSIONS_FILE")
GITEA_IMAGE=$(yq '.apps.gitea.image' "$VERSIONS_FILE")
GITEA_TAG=$(yq '.apps.gitea.tag' "$VERSIONS_FILE")

echo "Updating dev overlay image tags..."

# Patch grafana image
yq e -i "
  (.images[] | select(.name == \"grafana-image-placeholder\")).newName = \"$GRAFANA_IMAGE\" |
  (.images[] | select(.name == \"grafana-image-placeholder\")).newTag = \"$GRAFANA_TAG\"
" $OVERLAY_DIR/grafana/kustomization.yaml

# Patch gitea image
yq e -i "
  (.images[] | select(.name == \"gitea-image-placeholder\")).newName = \"$GITEA_IMAGE\" |
  (.images[] | select(.name == \"gitea-image-placeholder\")).newTag = \"$GITEA_TAG\"
" $OVERLAY_DIR/gitea/kustomization.yaml

echo "Deploying Grafana..."
kustomize build $OVERLAY_DIR/grafana | kubectl apply -f -

echo "Deploying Gitea..."
kustomize build $OVERLAY_DIR/gitea | kubectl apply -f -

echo "Deployment complete!"