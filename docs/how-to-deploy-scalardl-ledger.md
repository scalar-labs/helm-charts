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
helm install <RELEASE_NAME> scalar-labs/schema-loading -n <NAMESPACE> -f /<PATH_TO_YOUR_CUSTOM_VALUES_FILE_FOR_SCALARDL_SCHEMA_LOADER> --version <CHART_VERSION>
```

## Deploy ScalarDL Ledger

```console
helm install <RELEASE_NAME> scalar-labs/scalardl -n <NAMESPACE> -f /<PATH_TO_YOUR_CUSTOM_VALUES_FILE_FOR_SCALARDL_LEDGER> --version <CHART_VERSION>
```

## Upgrade the deployment of ScalarDL Ledger

```console
helm upgrade <RELEASE_NAME> scalar-labs/scalardl -n <NAMESPACE> -f /<PATH_TO_YOUR_CUSTOM_VALUES_FILE_FOR_SCALARDL_LEDGER> --version <CHART_VERSION>
```

## Delete the deployment of ScalarDL Ledger and ScalarDL Schema Loader

```console
helm uninstall <RELEASE_NAME> -n <NAMESPACE>
```
