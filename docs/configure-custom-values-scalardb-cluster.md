# Configure a custom values file for ScalarDB Cluster

This document explains how to create your custom values file for the ScalarDB Cluster chart. For details on the parameters, see the [README](https://github.com/scalar-labs/helm-charts/blob/main/charts/scalardb-cluster/README.md) of the ScalarDB Cluster chart.

## Required configurations

### Image configurations

You must set `scalardbCluster.image.repository` and `scalardbCluster.image.tag`. Please specify the container repository information that you will pull the ScalarDB Cluster container image from.

```yaml
scalardbCluster:
  image:
    repository: <SCALARDB_CLUSTER_CONTAINER_IMAGE>
    tag: <IMAGE_TAG>
```

### Database configurations

You must set `scalardbCluster.scalardbClusterNodeProperties`. Please set `scalardb-cluster-node.properties` to this parameter. For more details on the configurations of ScalarDB Cluster, see [ScalarDB Cluster Configurations](https://github.com/scalar-labs/scalardb-cluster/blob/main/docs/scalardb-cluster-configurations.md).

```yaml
scalardbCluster:
  scalardbClusterNodeProperties: |
    scalar.db.cluster.membership.type=KUBERNETES
    scalar.db.cluster.membership.kubernetes.endpoint.namespace_name=${env:SCALAR_DB_CLUSTER_MEMBERSHIP_KUBERNETES_ENDPOINT_NAMESPACE_NAME}
    scalar.db.cluster.membership.kubernetes.endpoint.name=${env:SCALAR_DB_CLUSTER_MEMBERSHIP_KUBERNETES_ENDPOINT_NAME}
    scalar.db.contact_points=localhost
    scalar.db.username=${env:SCALAR_DB_USERNAME}
    scalar.db.password=${env:SCALAR_DB_PASSWORD}
    scalar.db.storage=cassandra
```

Note that you must always set the following three properties if you deploy ScalarDB Cluster in a Kubernetes environment by using Scalar Helm Chart. These properties are fixed values. Since the properties don't depend on individual environments, you can set the same values by copying the following values and pasting them in `scalardbCluster.scalardbClusterNodeProperties`.

```yaml
scalardbCluster:
  scalardbClusterNodeProperties: |
    scalar.db.cluster.membership.type=KUBERNETES
    scalar.db.cluster.membership.kubernetes.endpoint.namespace_name=${env:SCALAR_DB_CLUSTER_MEMBERSHIP_KUBERNETES_ENDPOINT_NAMESPACE_NAME}
    scalar.db.cluster.membership.kubernetes.endpoint.name=${env:SCALAR_DB_CLUSTER_MEMBERSHIP_KUBERNETES_ENDPOINT_NAME}
```

## Optional configurations

### Resource configurations (recommended in production environments)

To control pod resources by using requests and limits in Kubernetes, you can use `scalardbCluster.resources`.

Note that, for commercial licenses, the resources for each pod of Scalar products are limited to 2vCPU / 4GB memory. Also, if you use the pay-as-you-go containers that the AWS Marketplace provides, you will not be able to run any containers that exceed the 2vCPU / 4GB memory configuration in `resources.limits`. If you exceed this resource limitation, the pods will automatically stop.

You can configure requests and limits by using the same syntax as requests and limits in Kubernetes. For more details on requests and limits in Kubernetes, see [Resource Management for Pods and Containers](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/).

```yaml
scalardbCluster:
  resources:
    requests:
      cpu: 2000m
      memory: 4Gi
    limits:
      cpu: 2000m
      memory: 4Gi
```

### Secret configurations (recommended in production environments)

To use environment variables to set some properties (e.g., credentials) in `scalardbCluster.scalardbClusterNodeProperties`, you can use `scalardbCluster.secretName` to specify the Secret resource that includes some credentials.

For example, you can set credentials for a backend database (`scalar.db.username` and `scalar.db.password`) by using environment variables, which makes your pods more secure.

For more details on how to use a Secret resource, see [How to use Secret resources to pass the credentials as the environment variables into the properties file](./use-secret-for-credentials.md).

```yaml
scalardbCluster:
  secretName: "scalardb-cluster-credentials-secret"
```

### Affinity configurations (recommended in production environments)

To control pod deployment by using affinity and anti-affinity in Kubernetes, you can use `scalardbCluster.affinity`.

You can configure affinity and anti-affinity by using the same syntax for affinity and anti-affinity in Kubernetes. For more details on configuring affinity in Kubernetes, see [Assigning Pods to Nodes](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/).

```yaml
scalardbCluster:
  affinity:
    nodeAffinity:
      requiredDuringSchedulingIgnoredDuringExecution:
        nodeSelectorTerms:
          - matchExpressions:
              - key: scalar-labs.com/dedicated-node
                operator: In
                values:
                  - scalardb-cluster
    podAntiAffinity:
      requiredDuringSchedulingIgnoredDuringExecution:
        - labelSelector:
            matchExpressions:
              - key: app.kubernetes.io/name
                operator: In
                values:
                  - scalardb-cluster
              - key: app.kubernetes.io/app
                operator: In
                values:
                  - scalardb-cluster
          topologyKey: kubernetes.io/hostname
```

### Taints and tolerations configurations (recommended in production environments)

To control pod deployment by using taints and tolerations in Kubernetes, you can use `scalardbCluster.tolerations`.

You can configure taints and tolerations by using the same syntax as taints and tolerations in Kubernetes. For more details on the taints and tolerations configuration in Kubernetes, see [Taints and Tolerations](https://kubernetes.io/docs/concepts/scheduling-eviction/taint-and-toleration/).

```yaml
scalardbCluster:
  tolerations:
    - effect: NoSchedule
      key: scalar-labs.com/dedicated-node
      operator: Equal
      value: scalardb-cluster
```

### Prometheus and Grafana configurations  (recommended in production environments)

To monitor ScalarDB Cluster pods by using [kube-prometheus-stack](https://github.com/prometheus-community/helm-charts/tree/main/charts/kube-prometheus-stack), you can set `scalardbCluster.grafanaDashboard.enabled`, `scalardbCluster.serviceMonitor.enabled`, and `scalardbCluster.prometheusRule.enabled` to `true`. When you set these configurations to `true`, the chart deploys the necessary resources and kube-prometheus-stack starts monitoring automatically.

```yaml
scalardbCluster:
  grafanaDashboard:
    enabled: true
    namespace: monitoring
  serviceMonitor:
    enabled: true
    namespace: monitoring
    interval: 15s
  prometheusRule:
    enabled: true
    namespace: monitoring
```

### SecurityContext configurations (default value is recommended)

To set SecurityContext and PodSecurityContext for ScalarDB Cluster pods, you can use `scalardbCluster.securityContext` and `scalardbCluster.podSecurityContext`.

You can configure SecurityContext and PodSecurityContext by using the same syntax as SecurityContext and PodSecurityContext in Kubernetes. For more details on the SecurityContext and PodSecurityContext configurations in Kubernetes, see [Configure a Security Context for a Pod or Container](https://kubernetes.io/docs/tasks/configure-pod-container/security-context/).

```yaml
scalardbCluster:
  podSecurityContext:
    seccompProfile:
      type: RuntimeDefault
  securityContext:
    capabilities:
      drop:
        - ALL
    runAsNonRoot: true
    allowPrivilegeEscalation: false
```

### Replica configurations (optional based on your environment)

You can specify the number of ScalarDB Cluster replicas (pods) by using `scalardbCluster.replicaCount`.

```yaml
scalardbCluster:
  replicaCount: 3
```

### Logging configurations (optional based on your environment)

To change the ScalarDB Cluster log level, you can use `scalardbCluster.logLevel`.

```yaml
scalardbCluster:
  logLevel: INFO
```

### GraphQL configurations (optional based on your environment)

To use the GraphQL feature in ScalarDB Cluster, you can set `scalardbCluster.graphql.enabled` to `true` to deploy some resources for the GraphQL feature. Note that you also need to set `scalar.db.graphql.enabled=true` in `scalardbCluster.scalardbClusterNodeProperties` when using the GraphQL feature.

```yaml
scalardbCluster:
  graphql:
    enabled: true
```

Also, you can configure the `Service` resource that accepts GraphQL requests from clients.

```yaml
scalardbCluster:
  graphql:
    service:
      type: ClusterIP
      annotations: {}
      ports:
        graphql:
          port: 8080
          targetPort: 8080
          protocol: TCP
```

### SQL configurations (optional based on your environment)

To use the SQL feature in ScalarDB Cluster, there is no configuration necessary for custom values files. You can use the feature by setting `scalar.db.sql.enabled=true` in `scalardbCluster.scalardbClusterNodeProperties`.

### Scalar Envoy configurations (optional based on your environment)

To use ScalarDB Cluster with `indirect` mode, you must enable Envoy as follows.

```yaml
envoy:
  enabled: true
```

Also, you must set the Scalar Envoy configurations in the custom values file for ScalarDB Cluster. This is because clients need to send requests to ScalarDB Cluster via Scalar Envoy as the load balancer of gRPC requests if you deploy ScalarDB Cluster in a Kubernetes environment with `indirect` mode.

For more details on Scalar Envoy configurations, see [Configure a custom values file for Scalar Envoy](configure-custom-values-envoy.md).

```yaml
envoy:
  configurationsForScalarEnvoy: 
    ...

scalardbCluster:
  configurationsForScalarDbCluster: 
    ...
```
