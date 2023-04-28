# How to deploy ScalarDB Cluster

This document explains how to deploy ScalarDB Cluster using Scalar Helm Charts. For more details on the custom values file for ScalarDB Cluster, see [Configure a custom values file for ScalarDB Cluster](./configure-custom-values-scalardb-cluster.md).

## Deploy ScalarDB Cluster

```console
helm install <release name> scalar-labs/scalardb-cluster -n <namespace> -f /path/to/<your custom values file for ScalarDB Cluster>
```

## Upgrade the deployment of ScalarDB Cluster

```console
helm upgrade <release name> scalar-labs/scalardb-cluster -n <namespace> -f /path/to/<your custom values file for ScalarDB Cluster>
```

## Delete the deployment of ScalarDB Cluster

```console
helm uninstall <release name> -n <namespace>
```

## Deploy your client application on Kubernetes with `direct-kubernetes` mode

If you use ScalarDB Cluster with `direct-kubernetes` mode, you have to:

* Deploy your application pods on the same Kubernetes cluster as ScalarDB Cluster.
* Create three Kubernetes resources (`Role`, `RoleBinding`, and `ServiceAccount`).
* Mount the `ServiceAccount` on your application pods.

This is because the ScalarDB Cluster client library with `direct-kubernetes` mode runs Kubernetes API from inside of your application pods to get the information of ScalarDB Cluster pods.

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
