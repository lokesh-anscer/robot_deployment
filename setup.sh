#!/bin/bash
set -e

echo "Starting GitOps Setup..."

# Location of files
VERSIONS_FILE="versions.yaml"
OVERLAY_DIR="manifests/overlays/dev"

# Extract versions from versions.yaml
echo "Extracting image versions..."
GRAFANA_IMAGE=$(yq '.apps.grafana.image' "$VERSIONS_FILE")
GRAFANA_TAG=$(yq '.apps.grafana.tag' "$VERSIONS_FILE")
GITEA_IMAGE=$(yq '.apps.gitea.image' "$VERSIONS_FILE")
GITEA_TAG=$(yq '.apps.gitea.tag' "$VERSIONS_FILE")

# Patch the overlays with correct image names/tags
echo "Patching overlay image versions..."

yq e -i "
  (.images[] | select(.name == \"grafana-image-placeholder\")).newName = \"$GRAFANA_IMAGE\" |
  (.images[] | select(.name == \"grafana-image-placeholder\")).newTag = \"$GRAFANA_TAG\"
" "$OVERLAY_DIR/grafana/kustomization.yaml"

yq e -i "
  (.images[] | select(.name == \"gitea-image-placeholder\")).newName = \"$GITEA_IMAGE\" |
  (.images[] | select(.name == \"gitea-image-placeholder\")).newTag = \"$GITEA_TAG\"
" "$OVERLAY_DIR/gitea/kustomization.yaml"

# Deploy Argo CD Applications (not the app itself, just monitored apps)
echo "Applying Argo CD Application YAMLs..."
kubectl apply -f applications/

echo "Setup complete. Argo CD will now sync and deploy your apps."
