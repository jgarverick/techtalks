#!/bin/bash

# Install Helm charts for Bamboo, Bitbucket

kubectl config use-context AKS-DEVOPS-ON-AZURE-admin

kubectl label namespace default istio-injection=enabled
kubectl create namespace jenkins
kubectl label namespace jenkins istio-injection=enabled

helm install stable/jenkins --name jenkins --namespace jenkins