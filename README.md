# ☸️ Monefy — Kubernetes Manifests

Kubernetes configuration for [Monefy](https://github.com/josef-issa/monefy-app) budget app.

## 📁 Structure
```
├── backend.yaml    # Deployment + Service for Node.js API
├── frontend.yaml   # Deployment + Service for React + nginx
├── ingress.yaml    # Ingress for monefy.local
├── pvc.yaml        # PersistentVolumeClaim for SQLite database
└── deploy.sh       # Automated deploy script
```

## 🚀 Deploy on Minikube
```bash
# 1. Start minikube
minikube start

# 2. Point Docker to minikube
eval $(minikube docker-env)

# 3. Enable addons
minikube addons enable ingress
minikube addons enable storage-provisioner

# 4. Deploy
kubectl apply -f pvc.yaml
kubectl apply -f backend.yaml
kubectl apply -f frontend.yaml
kubectl apply -f ingress.yaml

# 5. Open app
minikube service monefy-frontend
```

## 🌐 Via monefy.local (Mac)
```bash
# Add to /etc/hosts
echo "127.0.0.1 monefy.local" | sudo tee -a /etc/hosts

# Run tunnel in separate terminal
minikube tunnel

# Open in browser
open http://monefy.local
```

## 🔧 Useful Commands
```bash
# Check pod status
kubectl get pods

# View logs
kubectl logs -l app=monefy-backend -f
kubectl logs -l app=monefy-frontend -f

# Troubleshoot
kubectl describe pod <name>

# Restart deployments
kubectl rollout restart deployment/monefy-backend
kubectl rollout restart deployment/monefy-frontend

# Delete everything
kubectl delete -f .

# Stop minikube
minikube stop
```

## 🐳 Docker Hub Images

- `josef-issa/monefy-app-backend:v2`
- `josef-issa/monefy-app-frontend:v4`

## 🔗 Related

- [monefy-app](https://github.com/josef-issa/monefy-app) — Source code
EOF
