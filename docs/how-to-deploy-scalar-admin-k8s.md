# How to deploy Scalar Admin k8s

This document explains how to deploy Scalar Admin k8s by using Scalar Helm Charts. For details on the custom values file for Scalar Admin k8s, see [Configure a custom values file for Scalar Admin k8s](./configure-custom-values-scalar-admin-k8s.md).

## Deploy Scalar Admin k8s

To deploy Scalar Admin k8s, run the following command, replacing the contents in the angle brackets as described:

```console
helm install <RELEASE_NAME> scalar-labs/scalar-admin-k8s -n <NAMESPACE> -f /<PATH_TO_YOUR_CUSTOM_VALUES_FILE_FOR_SCALAR_ADMIN_K8S> --version <CHART_VERSION>
```

## Upgrade a Scalar Admin k8s job

To upgrade a Scalar Admin k8s job, run the following command, replacing the contents in the angle brackets as described:

```console
helm upgrade <RELEASE_NAME> scalar-labs/scalar-admin-k8s -n <NAMESPACE> -f /<PATH_TO_YOUR_CUSTOM_VALUES_FILE_FOR_SCALAR_ADMIN_K8S> --version <CHART_VERSION>
```

## Delete a Scalar Admin k8s job

To delete a Scalar Admin k8s job, run the following command, replacing the contents in the angle brackets as described:  

```console
helm uninstall <RELEASE_NAME> -n <NAMESPACE>
```
