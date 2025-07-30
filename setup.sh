#!/bin/bash
set -e

echo "Starting GitOps Setup..."

sudo kubectl apply -k manifests/ --validate=false
if [ $? -ne 0 ]; then
    echo "Error applying manifests. Please check your configuration."
    exit 1
fi

echo "Setup complete. Argo CD will now sync and deploy your apps."