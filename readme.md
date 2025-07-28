robot_deployment
├── applications
│   ├── gitea-app.yaml
│   ├── grafana-app.yaml
│   └── kustomization.yaml
├── manifests
│   ├── base
│   │   ├── gitea
│   │   │   ├── deployment.yaml
│   │   │   ├── kustomization.yaml
│   │   │   └── service.yaml
│   │   └── grafana
│   │       ├── deployment.yaml
│   │       ├── kustomization.yaml
│   │       └── service.yaml
│   ├── kustomization.yaml
│   └── overlays
│       └── dev
│           ├── gitea
│           │   └── kustomization.yaml
│           └── grafana
│               └── kustomization.yaml
├── readme.md
├── setup.sh
└── versions.yaml   