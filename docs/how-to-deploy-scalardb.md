# How to deploy ScalarDB Server

This document explains how to deploy ScalarDB Server using Scalar Helm Charts. You must prepare your custom values file. Please refer to the following document for more details on the custom values file for ScalarDB Server.

* [Configure a custom values file for ScalarDB Server](./configure-custom-values-scalardb.md)

## Deploy ScalarDB Server

```console
helm install <release name> scalar-labs/scalardb -n <namespace> -f /path/to/<your custom values file for ScalarDB Server>
```

## Upgrade the deployment of ScalarDB Server

```console
helm upgrade <release name> scalar-labs/scalardb -n <namespace> -f /path/to/<your custom values file for ScalarDB Server>
```

## Delete the deployment of ScalarDB Server

```console
helm uninstall <release name> -n <namespace>
```
