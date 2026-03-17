#!/bin/bash
set -e

echo "🚀 Deploying Monefy to Minikube..."

# Check minikube is running
if ! minikube status | grep -q "Running"; then
  echo "▶️  Starting minikube..."
  minikube start
fi

# Point Docker to minikube's Docker daemon
echo "🐳 Configuring Docker to use minikube's registry..."
eval $(minikube docker-env)

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
APP_DIR="$(dirname "$SCRIPT_DIR")"

# Build backend image
echo "🔨 Building backend image..."
docker build -t monefy-backend:latest "$APP_DIR/backend"

# Build frontend image (set API URL for nginx proxy)
echo "🔨 Building frontend image..."
docker build -t monefy-frontend:latest "$APP_DIR/frontend"

# Apply Kubernetes manifests
echo "📦 Applying Kubernetes manifests..."
kubectl apply -f "$SCRIPT_DIR/pvc.yaml"
kubectl apply -f "$SCRIPT_DIR/backend.yaml"
kubectl apply -f "$SCRIPT_DIR/frontend.yaml"

# Wait for deployments
echo "⏳ Waiting for pods to be ready..."
kubectl rollout status deployment/monefy-backend --timeout=120s
kubectl rollout status deployment/monefy-frontend --timeout=120s

# Get URL
MINIKUBE_IP=$(minikube ip)
echo ""
echo "✅ Monefy deployed successfully!"
echo ""
echo "🌐 Open your browser at:"
echo "   http://${MINIKUBE_IP}:30080"
echo ""
echo "📋 Useful commands:"
echo "   kubectl get pods                    # Check pod status"
echo "   kubectl logs -l app=monefy-backend  # Backend logs"
echo "   kubectl logs -l app=monefy-frontend # Frontend logs"
echo "   minikube service monefy-frontend    # Auto-open browser"
echo ""
