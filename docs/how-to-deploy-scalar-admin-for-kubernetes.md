> [!CAUTION]
> 
> The contents of the `docs` folder have been moved to the [docs-internal-orchestration](https://github.com/scalar-labs/docs-internal-orchestration) repository. Please update this documentation in that repository instead.
> 
> To view the Helm Charts documentation, visit the documentation site for the product you are using:
> 
> - [ScalarDB Enterprise Documentation](https://scalardb.scalar-labs.com/docs/latest/helm-charts/getting-started-scalar-helm-charts/).
> - [ScalarDL Documentation](https://scalardl.scalar-labs.com/docs/latest/helm-charts/getting-started-scalar-helm-charts/).

# How to deploy Scalar Admin for Kubernetes

This document explains how to deploy Scalar Admin for Kubernetes by using Scalar Helm Charts. For details on the custom values file for Scalar Admin for Kubernetes, see [Configure a custom values file for Scalar Admin for Kubernetes](./configure-custom-values-scalar-admin-for-kubernetes.md).

## Deploy Scalar Admin for Kubernetes

To deploy Scalar Admin for Kubernetes, run the following command, replacing the contents in the angle brackets as described:

```console
helm install <RELEASE_NAME> scalar-labs/scalar-admin-for-kubernetes -n <NAMESPACE> -f /<PATH_TO_YOUR_CUSTOM_VALUES_FILE_FOR_SCALAR_ADMIN_FOR_KUBERNETES> --version <CHART_VERSION>
```

## Upgrade a Scalar Admin for Kubernetes job

To upgrade a Scalar Admin for Kubernetes job, run the following command, replacing the contents in the angle brackets as described:

```console
helm upgrade <RELEASE_NAME> scalar-labs/scalar-admin-for-kubernetes -n <NAMESPACE> -f /<PATH_TO_YOUR_CUSTOM_VALUES_FILE_FOR_SCALAR_ADMIN_FOR_KUBERNETES> --version <CHART_VERSION>
```

## Delete a Scalar Admin for Kubernetes job

To delete a Scalar Admin for Kubernetes job, run the following command, replacing the contents in the angle brackets as described:  

```console
helm uninstall <RELEASE_NAME> -n <NAMESPACE>
```
