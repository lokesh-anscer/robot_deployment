# #!/bin/bash
# set -e

# echo "Starting GitOps Setup..."

# sudo kubectl apply -f manifests/gitea/
# sudo kubectl apply -f manifests/grafana/

# echo "Setup complete. Argo CD will now sync and deploy your apps."


#!/bin/bash
set -e

echo "Creating Argo CD Applications..."

sudo kubectl apply -f argocd/gitea-app.yaml
sudo kubectl apply -f argocd/grafana-app.yaml

echo "Argo CD apps created. It will now sync and deploy them."
