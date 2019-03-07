# Azure DevOps vs. DevOps on Azure
## Synopsis
The sample code herein contains a Kubernetes cluster setup script that will initialize a new cluster for you and install the Istio suite into that cluster.  Each folder listed below has a `bootstrap.sh` script in it which will install platform components by those vendors.

- [Atlassian](/Atlassian)
- [Concourse](/Concourse)
- [Jenkins](/Jenkins)
- [TeamCity](/TeamCity)

The intent is to be able to integrate non-Microsoft toolchains with Azure DevOps as well as deploy to the Azure cloud.

## Prerequisites

You must run this script using the `bash` shell wit Linux or Mac OS, or the Windows Subsystem for Linux if using Windows 10.  The following will need to be installed on your machine to run the scripts:

- [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli?view=azure-cli-latest)
- Kubernetes toolset (`kubectl`, `helm`)

Installing the kubernetes tools can be performed from the Azure CLI:
`az aks install-cli`

## Getting Started

To get started, run the `doaz` script included in this directory.  It will download [istio](https://istio.io) for you, prepare it for deployment, create the AKS cluster using the Azure CLI, and then install `istio` into the cluster.

For running the utilities related to `istio`, you can enter the command `run-istio` after the cluster has finished provisioning.  To stop the processes running the `istio` utilities, you may enter `kill-istio` at the command line, which will kill the process IDs associated to those utilities.

## Under the Hood

The `infra.sh` script contains commands that will stand up and tear down the related infrastructure for this example.  The `istioconf.sh` script contains the magic methods that will open up each of the utilities in the `istio` stack, namely:

- Prometheus
- Grafana
- Kiali
- Jaeger

Each of these utilities has nuances and sites dedicated to training.  Should you be interested in exploring those further, please do so.  The `istio` website also gives a great overview into not only the platform, but each utility as well.

In most cases, the tools that are out there from the four major vendors listed above do not have `helm` charts available, so I built those based on the `docker` images available in the public registry.  The scripts utilize `az acr` to push these custom charts into the Azure Container Registry instance that is created during infrastructure initialization.