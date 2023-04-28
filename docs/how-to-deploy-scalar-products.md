# Deploy Scalar products using Scalar Helm Charts

This document explains how to deploy Scalar products using Scalar Helm Charts. If you want to test Scalar products on your local environment using a minikube cluster, please refer to the following getting started guide.

* [Getting Started with Scalar Helm Charts](./getting-started-scalar-helm-charts.md)

## Prerequisites

### Install the helm command

You must install the helm command to use Scalar Helm Charts. Please install the helm command according to the [Helm document](https://helm.sh/docs/intro/install/).

### Add the Scalar Helm Charts repository 

```console
helm repo add scalar-labs https://scalar-labs.github.io/helm-charts
```
```console
helm repo update scalar-labs
```

### Prepare a Kubernetes cluster

You must prepare a Kubernetes cluster for the deployment of Scalar products. If you use EKS (Amazon Elastic Kubernetes Service) or AKS (Azure Kubernetes Service) in the production environment. Please refer to the following document for more details.

* [scalar-labs/scalar-kubernetes](https://github.com/scalar-labs/scalar-kubernetes/blob/master/README.md)

### Prepare a database (ScalarDB, ScalarDL Ledger, ScalarDL Auditor)

You must prepare a database as a backend storage of ScalarDB/ScalarDL. You can see the supported databases by ScalarDB/ScalarDL in the following document.

* [ScalarDB Supported Databases](https://github.com/scalar-labs/scalardb/blob/master/docs/scalardb-supported-databases.md)

### Prepare a custom values file

You must prepare your custom values file based on your environment. Please refer to the following documents for more details on how to create a custom values file.

* [Configure a custom values file for Scalar Helm Charts](./configure-custom-values-file.md)

### Create a Secret resource for authentication of the container registry (Optional)

If you use a Kubernetes cluster other than EKS or AKS, you need to create a Secret resource that includes the credentials and set the Secret name to `imagePullSecrets[].name` in your custom values file. Please refer to the following documents for more details on creating the Secret resource and setting it in your custom values file.

* [Deploy containers on Kubernetes other than EKS from AWS Marketplace using Scalar Helm Charts](https://github.com/scalar-labs/scalar-kubernetes/blob/master/docs/AwsMarketplaceGuide.md#byol-deploy-containers-on-kubernetes-other-than-eks-from-aws-marketplace-using-scalar-helm-charts)
* [Deploy containers on Kubernetes other than AKS (Azure Kubernetes Service) from your private container registry using Scalar Helm Charts](https://github.com/scalar-labs/scalar-kubernetes/blob/master/docs/AzureMarketplaceGuide.md#deploy-containers-on-kubernetes-other-than-aks-azure-kubernetes-service-from-your-private-container-registry-using-scalar-helm-charts)

## Deploy Scalar products

Please refer to the following documents for more details on how to deploy each product.

* [ScalarDB Server](./how-to-deploy-scalardb.md)
* [ScalarDB GraphQL](./how-to-deploy-scalardb-graphql.md)
* [ScalarDB Cluster](./how-to-deploy-scalardb-cluster.md)
* [ScalarDL Ledger](./how-to-deploy-scalardl-ledger.md)
* [ScalarDL Auditor](./how-to-deploy-scalardl-auditor.md)
* [Scalar Manager](./how-to-deploy-scalar-manager.md)
