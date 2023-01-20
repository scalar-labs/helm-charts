# How to deploy ScalarDL Auditor

This document explains how to deploy ScalarDL Auditor using Scalar Helm Charts. You must prepare your custom values file. Please refer to the following document for more details on the custom values file for ScalarDL Auditor and ScalarDL Schema Loader.

* [Configure a custom values file for ScalarDL Auditor](./configure-custom-values-scalardl-auditor.md)
* [Configure a custom values file for ScalarDL Schema Loader](./configure-custom-values-scalardl-schema-loader.md)

## Prepare a private key file and a certificate file

When you deploy ScalarDL Auditor, you must create a Secrete resource to mount the private key file and the certificate file on the ScalarDL Auditor pods.

Please refer to the following document for more details on how to mount the key/certificate files on the ScalarDL pods.

* [Mount key/certificate files to the pod in ScalarDL Helm Charts](./mount-key-and-cert-for-scalardl.md)

## Create schemas for ScalarDL Auditor (Deploy ScalarDL Schema Loader)

Before you deploy ScalarDL Auditor, you must create schemas for ScalarDL Auditor on the backend database.

```console
helm install <release name> scalar-labs/schema-loading -n <namespace> -f /path/to/<your custom values file for ScalarDL Schema Loader>
```

## Deploy ScalarDL Auditor

```console
helm install <release name> scalar-labs/scalardl-audit -n <namespace> -f /path/to/<your custom values file for ScalarDL Auditor>
```

## Upgrade the deployment of ScalarDL Auditor

```console
helm upgrade <release name> scalar-labs/scalardl-audit -n <namespace> -f /path/to/<your custom values file for ScalarDL Auditor>
```

## Delete the deployment of ScalarDL Auditor and ScalarDL Schema Loader

```console
helm uninstall <release name> -n <namespace>
```
