#!/bin/bash

infraup() {
    echo "Beginning standup sequence."
    az login
    az account set -s AZMVP
    az group create -n "RG-DEVOPS-ON-AZURE" -l EastUS
    createaks "AKS-DEVOPS-ON-AZURE" 
    az storage account create -n "sadevopsazurestg1" -g "RG-DEVOPS-ON-AZURE"
    az acr create -n ACRDEVOPSAZURE -g "RG-DEVOPS-ON-AZURE" --sku Standard
    echo "Standup sequence complete."
}

createaks() {
    echo "Creating AKS cluster $1..."
    az aks create -n "$1" -g "RG-DEVOPS-ON-AZURE" \
    --enable-addons http_application_routing,monitoring \
    --kubernetes-version 1.12.5 -s Standard_DS12_v2 \
    --aad-client-app-id "e2869a9b-4e1b-4c18-9fe3-24200448bcc9" \
    --aad-server-app-id "efe32d1a-a1a6-46c9-9547-f21c3810df52" \
    --aad-tenant-id "6af9b188-9fe3-4822-b428-d4a11f942bfc" \
    --aad-server-app-secret "eQEDWktlnjVb6veqjueRmM6kaW+aaKCMEVq8zdr7uSA="

    az aks get-credentials -n "$1" -g "RG-DEVOPS-ON-AZURE" --overwrite
    az aks get-credentials -n "$1" -g "RG-DEVOPS-ON-AZURE" --overwrite -a
    echo "Updating cluster RBAC..."
    kubectl apply -f ../crole.yaml
    kubectl apply -f ../dasher.yaml
    kubectl apply -f install/kubernetes/helm/helm-service-account.yaml
    helm init --service-account tiller --wait
    echo "Installing Istio via Helm..."
    helm install install/kubernetes/helm/istio --name istio --namespace istio-system \
    --set global.controlPlaneSecurityEnabled=true \
    --set grafana.enabled=true \
    --set tracing.enabled=true \
    --set kiali.enabled=true 

    echo "Validating results"
    kubectl get svc --namespace istio-system --output wide
    
    kubectl label namespace default istio-injection=enabled
}

infradown() {
    echo "Deleting AKS clusters..."
    az aks delete -n "AKS-DEVOPS-ON-AZURE" -g "RG-DEVOPS-ON-AZURE" -y
    echo "Removing all demo resources..."
    az group delete -n "RG-DEVOPS-ON-AZURE" -y
}
