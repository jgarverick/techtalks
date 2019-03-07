#!/bin/bash

# Install Helm charts for Concourse, Spinnaker, GitLab
kubectl config use-context AKS-DEVOPS-ON-AZURE-admin

kubectl label namespace default istio-injection=enabled
kubectl create namespace concourse
kubectl label namespace concourse istio-injection=enabled

helm repo update
helm install stable/concourse --name concourse --namespace concourse
helm install stable/spinnaker --name spinnaker --namespace concourse
helm install stable/gitlab-ce --name gitlab --namespace concourse