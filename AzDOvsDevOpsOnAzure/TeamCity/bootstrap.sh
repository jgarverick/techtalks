#!/bin/bash

rm -rf *.tgz
helm local-chart-version bump -c ./teamcity-agent -s minor
helm local-chart-version bump -c ./teamcity-server -s minor

if [ "$1" == "" ]; then
kubectl config use-context AKS-DEVOPS-ON-AZURE-admin
else
kubectl config use-context $1
fi
kubectl delete namespace teamcity

helm del --purge teamcity-agent
helm del --purge teamcity-server

kubectl create namespace teamcity
kubectl label namespace teamcity istio-injection=enabled

helm package teamcity-agent
helm package teamcity-server

az acr helm repo add -n ACRDEVOPSAZURE
az acr helm push --name ACRDEVOPSAZURE teamcity-agent*.tgz
az acr helm push --name ACRDEVOPSAZURE teamcity-server*.tgz

helm repo update
helm install ACRDEVOPSAZURE/teamcity-server --name teamcity-server --namespace teamcity
helm install ACRDEVOPSAZURE/teamcity-agent --name teamcity-agent --namespace teamcity