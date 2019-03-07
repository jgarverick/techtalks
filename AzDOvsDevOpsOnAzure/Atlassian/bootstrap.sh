#!/bin/bash

rm -rf *.tgz
helm local-chart-version bump -c ./bamboo-agent -s minor
helm local-chart-version bump -c ./bamboo-server -s minor
helm local-chart-version bump -c ./bitbucket-server -s minor

helm del --purge bamboo-agent
helm del --purge bamboo-server
helm del --purge bitbucket-server

kubectl config use-context AKS-DEVOPS-ON-AZURE-admin

kubectl label namespace default istio-injection=enabled
kubectl create namespace atlassian
kubectl label namespace atlassian istio-injection=enabled

helm package bamboo-agent
helm package bamboo-server
helm package bitbucket-server

az acr helm repo add -n ACRDEVOPSAZURE
az acr helm push -n ACRDEVOPSAZURE bamboo-agent*.tgz
az acr helm push -n ACRDEVOPSAZURE bamboo-server*.tgz
az acr helm push -n ACRDEVOPSAZURE bitbucket-server*.tgz
helm repo update

AKS_DNS=$(az aks show -n AKS-DEVOPS-ON-AZURE -g RG-DEVOPS-ON-AZURE --query "addonProfiles.httpApplicationRouting.config.HTTPApplicationRoutingZoneName" -o tsv)

helm install ACRDEVOPSAZURE/bamboo-agent --name bamboo-agent --namespace atlassian
helm install ACRDEVOPSAZURE/bamboo-server --name bamboo-server --namespace atlassian --set ingress.hosts={"bamboo-server.$AKS_DNS"}
helm install ACRDEVOPSAZURE/bitbucket-server --name bitbucket-server --namespace atlassian --set ingress.hosts={"bitbucket-server.$AKS_DNS"}