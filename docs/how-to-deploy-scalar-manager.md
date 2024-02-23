> [!CAUTION]
> 
> The contents of the `docs` folder have been moved to the [docs-internal-orchestration](https://github.com/scalar-labs/docs-internal-orchestration) repository. Please update this documentation in that repository instead.
> 
> To view the Helm Charts documentation, visit the documentation site for the product you are using:
> 
> - [ScalarDB Enterprise Documentation](https://scalardb.scalar-labs.com/docs/latest/helm-charts/getting-started-scalar-helm-charts/).
> - [ScalarDL Documentation](https://scalardl.scalar-labs.com/docs/latest/helm-charts/getting-started-scalar-helm-charts/).

# How to deploy Scalar Manager

This document explains how to deploy Scalar Manager using Scalar Helm Charts. You must prepare your custom values file. Please refer to the following document for more details on the custom values file for Scalar Manager.

* [Configure a custom values file for Scalar Manager](./configure-custom-values-scalar-manager.md)

## Deploy kube-prometheus-stack and loki-stack

When you use Scalar Manager, you must deploy kube-prometheus-stack and loki-stack. Please refer to the following documents for more details on how to deploy them.

* [Getting Started with Helm Charts (Monitoring using Prometheus Operator)](https://github.com/scalar-labs/helm-charts/blob/main/docs/getting-started-monitoring.md)
* [Getting Started with Helm Charts (Logging using Loki Stack)](https://github.com/scalar-labs/helm-charts/blob/main/docs/getting-started-logging.md)

When you deploy kube-prometheus-stack, you must set the following configuration in the custom values file for kube-prometheus-stack.

```yaml
grafana:
  grafana-ini:
    security:
      allow_embedding: true
      cookie_samesite: disabled
```

If you already have a deployment of kube-prometheus-stack, please upgrade the configuration using the following command.

```console
helm upgrade <RELEASE_NAME> prometheus-community/kube-prometheus-stack -n <NAMESPACE> -f /<PATH_TO_YOUR_CUSTOM_VALUES_FILE_FOR_KUBE_PROMETHEUS_STACK> --version <CHART_VERSION>
```

## Deploy Scalar Manager

```console
helm install <RELEASE_NAME> scalar-labs/scalar-manager -n <NAMESPACE> -f /<PATH_TO_YOUR_CUSTOM_VALUES_FILE_FOR_SCALAR_MANAGER> --version <CHART_VERSION>
```

## Upgrade the deployment of Scalar Manager

```console
helm upgrade <RELEASE_NAME> scalar-labs/scalar-manager -n <NAMESPACE> -f /<PATH_TO_YOUR_CUSTOM_VALUES_FILE_FOR_SCALAR_MANAGER> --version <CHART_VERSION>
```

## Delete the deployment of Scalar Manager

```console
helm uninstall <RELEASE_NAME> -n <NAMESPACE>
```
