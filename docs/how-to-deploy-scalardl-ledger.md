# How to deploy ScalarDL Ledger

This document explains how to deploy ScalarDL Ledger using Scalar Helm Charts. You must prepare your custom values file. Please refer to the following document for more details on the custom values file for ScalarDL Ledger and ScalarDL Schema Loader.

* [Configure a custom values file for ScalarDL Ledger](./configure-custom-values-scalardl-ledger.md)
* [Configure a custom values file for ScalarDL Schema Loader](./configure-custom-values-scalardl-schema-loader.md)

## Prepare a private key file (optional / it is necessary if you use ScalarDL Auditor)

If you use the [asset proofs](https://github.com/scalar-labs/scalardl/blob/master/docs/how-to-use-proof.md) of ScalarDL Ledger, you must create a Secrete resource to mount the private key file on the ScalarDL Ledger pods. If you use ScalarDL Auditor, asset proof is necessary.

Please refer to the following document for more details on how to mount the key/certificate files on the ScalarDL pods.

* [Mount key and certificate files on a pod in ScalarDL Helm Charts](./mount-files-or-volumes-on-scalar-pods.md#mount-key-and-certificate-files-on-a-pod-in-scalardl-helm-charts)

## Create schemas for ScalarDL Ledger (Deploy ScalarDL Schema Loader)

Before you deploy ScalarDL Ledger, you must create schemas for ScalarDL Ledger on the backend database.

```console
helm install <release name> scalar-labs/schema-loading -n <namespace> -f /path/to/<your custom values file for ScalarDL Schema Loader>
```

## Deploy ScalarDL Ledger

```console
helm install <release name> scalar-labs/scalardl -n <namespace> -f /path/to/<your custom values file for ScalarDL Ledger>
```

## Upgrade the deployment of ScalarDL Ledger

```console
helm upgrade <release name> scalar-labs/scalardl -n <namespace> -f /path/to/<your custom values file for ScalarDL Ledger>
```

## Delete the deployment of ScalarDL Ledger and ScalarDL Schema Loader

```console
helm uninstall <release name> -n <namespace>
```
