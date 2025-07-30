#!/bin/bash
set -e

echo "Starting GitOps Setup..."

sudo kubectl apply -k manifests/

echo "Setup complete. Argo CD will now sync and deploy your apps."