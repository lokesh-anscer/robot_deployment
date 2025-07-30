#!/bin/bash
set -e

echo "Starting GitOps Setup.."

# # --- Ensure kairos is installed ---
# if ! command -v kairos > /dev/null 2>&1; then
#     echo "Installing kairos CLI..."
#     curl -s https://get.kairos.io | sudo bash
# else
#     echo "Kairos CLI already installed."
# fi

# --- Fix K3s kubeconfig permissions permanently ---
echo "Setting kubeconfig readable for non-root users.."
sudo mkdir -p /etc/systemd/system/k3s.service.d/
sudo tee /etc/systemd/system/k3s.service.d/override.conf > /dev/null <<EOF
[Service]
ExecStart=
ExecStart=/usr/local/bin/k3s server --write-kubeconfig-mode 644
EOF

echo "Reloading systemd and restarting k3s.."
sudo systemctl daemon-reexec
sudo systemctl daemon-reload
sudo systemctl restart k3s

# --- Remount root if read-only ---
if ! sudo touch /etc/rancher/k3s/.rwtest 2>/dev/null; then
    echo "Remounting root filesystem as read-write.."
    sudo mount -o remount,rw /
fi

# --- Configure containerd to trust insecure registry ---
echo "Setting up insecure registry access for K3s.."
sudo mkdir -p /etc/rancher/k3s
sudo tee /etc/rancher/k3s/registries.yaml > /dev/null <<EOF
mirrors:
  "192.168.31.85:5000":
    endpoint:
      - "http://192.168.31.85:5000"
EOF

echo "Restarting k3s to apply registry config.."
sudo systemctl restart k3s

# --- Apply GitOps manifests ---
echo "Applying Kubernetes manifests.."
if ! kubectl apply -k manifests/ --validate=false; then
    echo "Error applying manifests. Please check your configuration."
    exit 1
fi

echo "Setup complete. Argo CD will now sync and deploy your apps.