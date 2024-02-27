> [!CAUTION]
> 
> The contents of the `docs` folder have been moved to the [docs-internal-orchestration](https://github.com/scalar-labs/docs-internal-orchestration) repository. Please update this documentation in that repository instead.
> 
> To view the Helm Charts documentation, visit the documentation site for the product you are using:
> 
> - [ScalarDB Enterprise Documentation](https://scalardb.scalar-labs.com/docs/latest/helm-charts/getting-started-scalar-helm-charts/).
> - [ScalarDL Documentation](https://scalardl.scalar-labs.com/docs/latest/helm-charts/getting-started-scalar-helm-charts/).

# How to deploy ScalarDB Cluster

This document explains how to deploy ScalarDB Cluster by using Scalar Helm Charts. For details on the custom values file for ScalarDB Cluster, see [Configure a custom values file for ScalarDB Cluster](./configure-custom-values-scalardb-cluster.md).

## Deploy ScalarDB Cluster

```console
helm install <RELEASE_NAME> scalar-labs/scalardb-cluster -n <NAMESPACE> -f /<PATH_TO_YOUR_CUSTOM_VALUES_FILE_FOR_SCALARDB_CLUSTER> --version <CHART_VERSION>
```

## Upgrade a ScalarDB Cluster deployment

```console
helm upgrade <RELEASE_NAME> scalar-labs/scalardb-cluster -n <NAMESPACE> -f /<PATH_TO_YOUR_CUSTOM_VALUES_FILE_FOR_SCALARDB_CLUSTER> --version <CHART_VERSION>
```

## Delete a ScalarDB Cluster deployment

```console
helm uninstall <RELEASE_NAME> -n <NAMESPACE>
```

## Deploy your client application on Kubernetes with `direct-kubernetes` mode

If you use ScalarDB Cluster with `direct-kubernetes` mode, you must:

1. Deploy your application pods on the same Kubernetes cluster as ScalarDB Cluster.
2. Create three Kubernetes resources (`Role`, `RoleBinding`, and `ServiceAccount`).
3. Mount the `ServiceAccount` on your application pods.

This method is necessary because the ScalarDB Cluster client library with `direct-kubernetes` mode runs the Kubernetes API from inside of your application pods to get information about the ScalarDB Cluster pods.

* Role
  ```yaml
  apiVersion: rbac.authorization.k8s.io/v1
  kind: Role
  metadata:
    name: scalardb-cluster-client-role
    namespace: <your namespace>
  rules:
    - apiGroups: [""]
      resources: ["endpoints"]
      verbs: ["get", "watch", "list"]
  ```
* RoleBinding
  ```yaml
  apiVersion: rbac.authorization.k8s.io/v1
  kind: RoleBinding
  metadata:
    name: scalardb-cluster-client-rolebinding
    namespace: <your namespace>
  subjects:
    - kind: ServiceAccount
      name: scalardb-cluster-client-sa
  roleRef:
    kind: Role
    name: scalardb-cluster-role
    apiGroup: rbac.authorization.k8s.io
  ```
* ServiceAccount
  ```yaml
  apiVersion: v1
  kind: ServiceAccount
  metadata:
    name: scalardb-cluster-client-sa
    namespace: <your namespace>
  ```
