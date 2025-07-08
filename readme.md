# robot-001-deployment repo structure and scripts

# =======================
# setup.sh
# =======================
#!/bin/bash
set -e

log() {
  echo "[robot-setup] $1"
}

log "Running preflight checks..."
./bootstrap/preflight-checks.sh || true

log "Deploying app manifests via kubectl..."
kubectl apply -k manifests/

log "Setup complete!"


# =======================
# manifests/app-a/deployment.yaml
# =======================
apiVersion: apps/v1
kind: Deployment
metadata:
  name: app-a
spec:
  replicas: 1
  selector:
    matchLabels:
      app: app-a
  template:
    metadata:
      labels:
        app: app-a
    spec:
      containers:
        - name: app-a
          image: my-registry.local/app-a:1.0
          ports:
            - containerPort: 8080


# =======================
# manifests/app-a/service.yaml
# =======================
apiVersion: v1
kind: Service
metadata:
  name: app-a-service
spec:
  selector:
    app: app-a
  ports:
    - port: 80
      targetPort: 8080


# =======================
# manifests/app-a/kustomization.yaml
# =======================
resources:
  - deployment.yaml
  - service.yaml


# =======================
# manifests/app-b/deployment.yaml
# =======================
apiVersion: apps/v1
kind: Deployment
metadata:
  name: app-b
spec:
  replicas: 1
  selector:
    matchLabels:
      app: app-b
  template:
    metadata:
      labels:
        app: app-b
    spec:
      containers:
        - name: app-b
          image: my-registry.local/app-b:1.0
          ports:
            - containerPort: 9090


# =======================
# manifests/app-b/service.yaml
# =======================
apiVersion: v1
kind: Service
metadata:
  name: app-b-service
spec:
  selector:
    app: app-b
  ports:
    - port: 80
      targetPort: 9090


# =======================
# manifests/app-b/kustomization.yaml
# =======================
resources:
  - deployment.yaml
  - service.yaml


# =======================
# manifests/kustomization.yaml (root)
# =======================
resources:
  - app-a/
  - app-b/


# =======================
# kairos/kairos.yaml (for building Kairos ISO or provisioning Kairos VM)
# =======================
hostname: robot-001

k3s:
  enabled: true

docker:
  enabled: true

registries:
  mirrors:
    "my-registry.local":
      endpoint:
        - "http://my-registry.local:5000"

stages:
  after-install:
    - name: clone-deployment-repo
      commands:
        - git clone http://git.local/robot-001-deployment.git /mnt/robot-001-deployment
        - cd /mnt/robot-001-deployment
        - chmod +x setup.sh
        - ./setup.sh
