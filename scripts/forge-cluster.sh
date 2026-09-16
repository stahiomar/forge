#!/bin/bash

set -e

echo "Creating Kind cluster..."

cd ~/forge/kind

kind create cluster \
  --name forge \
  --config kind-config.yaml

echo "Kind cluster created."

echo "Installing NGINX Ingress Controller..."

kubectl apply \
  -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/kind/deploy.yaml

echo "NGINX Ingress Controller installed."

echo "Applying Kubernetes manifests..."

cd ~/forge/k8s

kubectl apply -R -f .

echo "Kubernetes resources created."

echo
echo "Cluster:"
kubectl get nodes

echo
echo "Pods:"
kubectl get pods -A