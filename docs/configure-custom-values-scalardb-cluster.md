# Configure a custom values file for ScalarDB Cluster

This document explains how to create your custom values file for the ScalarDB Cluster chart. For more details on the parameters, see [README](https://github.com/scalar-labs/helm-charts/blob/main/charts/scalardb-cluster/README.md) of the ScalarDB Cluster chart.

## Required configurations

### Image configurations

You must set `scalardbCluster.image.repository` and `scalardbCluster.image.tag`. Please specify the container repository information that you pull the ScalarDB Cluster container image.

```yaml
scalardbCluster:
  image:
    repository: <Container image of ScalarDB Cluster>
    tag: <Tag of image>
```

### Database configurations

You must set `scalardbCluster.scalardbClusterNodeProperties`. Please set your `scalardb-cluster-node.properties` to this parameter. For more details on the configurations of ScalarDB Cluster, see [ScalarDB Cluster document](https://github.com/scalar-labs/scalardb-cluster/blob/main/docs/index.md#configurations).

```yaml
scalardbCluster:
  scalardbClusterNodeProperties: |
    scalar.db.cluster.membership.type=KUBERNETES
    scalar.db.cluster.membership.kubernetes.endpoint.namespace_name=${env:SCALAR_DB_CLUSTER_MEMBERSHIP_KUBERNETES_ENDPOINT_NAMESPACE_NAME}
    scalar.db.cluster.membership.kubernetes.endpoint.name=${env:SCALAR_DB_CLUSTER_MEMBERSHIP_KUBERNETES_ENDPOINT_NAME}
    scalar.db.contact_points=localhost
    scalar.db.username=cassandra
    scalar.db.password=cassandra
    scalar.db.storage=cassandra
```

Note that you must always set the following three properties when you deploy ScalarDB Cluster on the Kubernetes environment using Scalar Helm Chart. These are the fixed value. They don't depend on each environment. So, you can set the same values by **copy and paste** in your `scalardbCluster.scalardbClusterNodeProperties`.

```yaml
scalardbCluster:
  scalardbClusterNodeProperties: |
    scalar.db.cluster.membership.type=KUBERNETES
    scalar.db.cluster.membership.kubernetes.endpoint.namespace_name=${env:SCALAR_DB_CLUSTER_MEMBERSHIP_KUBERNETES_ENDPOINT_NAMESPACE_NAME}
    scalar.db.cluster.membership.kubernetes.endpoint.name=${env:SCALAR_DB_CLUSTER_MEMBERSHIP_KUBERNETES_ENDPOINT_NAME}
```

## Optional configurations

### Resource configurations (Recommended in the production environment)

If you want to control pod resources using the requests and limits of Kubernetes, you can use `scalardbCluster.resources`.

Note that the resources for one pod of Scalar products are limited to 2vCPU / 4GB memory from the perspective of the commercial license. Also, when you get the pay-as-you-go containers provided from AWS Marketplace, you cannot run those containers with more than 2vCPU / 4GB memory configuration in the `resources.limits`. When you exceed this limitation, pods are automatically stopped.

You can configure them using the same syntax as the requests and limits of Kubernetes. For more details on the requests and limits of Kubernetes, see [Resource Management for Pods and Containers](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/).

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

### Secret configurations (Recommended in the production environment)

If you want to use environment variables to set some properties (e.g., credentials) in the `scalardbCluster.scalardbClusterNodeProperties`, you can use `scalardbCluster.secretName` to specify the Secret resource that includes some credentials.

For example, you can set credentials for a backend database (`scalar.db.username` and `scalar.db.password`) using environment variables, which makes your pods more secure.

For more details on how to use a Secret resource,see [How to use Secret resources to pass the credentials as the environment variables into the properties file](./use-secret-for-credentilas.md).

```yaml
scalardbCluster:
  secretName: "scalardb-cluster-credentials-secret"
```

### Affinity configurations (Recommended in the production environment)

If you want to control pod deployment using the affinity and anti-affinity of Kubernetes, you can use `scalardbCluster.affinity`.

You can configure them using the same syntax as the affinity of Kubernetes. For more details on the affinity configuration of Kubernetes, see [Assigning Pods to Nodes](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/).

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

### Taints/Tolerations configurations (Recommended in the production environment)

If you want to control pod deployment using the taints and tolerations of Kubernetes, you can use `scalardbCluster.tolerations`.

You can configure them using the same syntax as the tolerations of Kubernetes. For more details on the tolerations configuration of Kubernetes, see [Taints and Tolerations](https://kubernetes.io/docs/concepts/scheduling-eviction/taint-and-toleration/).

```yaml
scalardbCluster:
  tolerations:
    - effect: NoSchedule
      key: scalar-labs.com/dedicated-node
      operator: Equal
      value: scalardb-cluster
```

### Prometheus/Grafana configurations  (Recommended in the production environment)

If you want to monitor ScalarDB Cluster pods using [kube-prometheus-stack](https://github.com/prometheus-community/helm-charts/tree/main/charts/kube-prometheus-stack), you can deploy a ConfigMap, a ServiceMonitor, and a PrometheusRule resource for kube-prometheus-stack using `scalardbCluster.grafanaDashboard.enabled`, `scalardbCluster.serviceMonitor.enabled`, and `scalardbCluster.prometheusRule.enabled`.

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

### SecurityContext configurations (Default value is recommended)

If you want to set SecurityContext and PodSecurityContext for ScalarDB Cluster pods, you can use `scalardbCluster.securityContext` and `scalardbCluster.podSecurityContext`.

You can configure them using the same syntax as SecurityContext and PodSecurityContext of Kubernetes. For more details on the SecurityContext and PodSecurityContext configurations of Kubernetes, see [Configure a Security Context for a Pod or Container](https://kubernetes.io/docs/tasks/configure-pod-container/security-context/).

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

### Replica configurations (Optional based on your environment)

You can specify the number of replicas (pods) of ScalarDB Cluster using `scalardbCluster.replicaCount`.

```yaml
scalardbCluster:
  replicaCount: 3
```

### Logging configurations (Optional based on your environment)

If you want to change the log level of ScalarDB Cluster, you can use `scalardbCluster.logLevel`.

```yaml
scalardbCluster:
  logLevel: INFO
```

### GraphQL configurations (Optional based on your environment)

If you want to use the GraphQL feature of ScalarDB Cluster, you can set `true` to `scalardbCluster.graphql.enabled` to deploy some resources for the GraphQL feature. Note that you also need to set `scalar.db.graphql.enabled=true` in `scalardbCluster.scalardbClusterNodeProperties` when you use the GraphQL feature.

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

### SQL configurations (Optional based on your environment)

If you want to use the SQL feature of ScalarDB Cluster, there is no configuration for custom values files. You can use it by setting `scalar.db.sql.enabled=true` in `scalardbCluster.scalardbClusterNodeProperties`.

### Scalar Envoy configurations (Optional based on your environment)

If you want to use ScalarDB Cluster with `indirect` mode, you must enable Envoy as follows.

```yaml
envoy:
  enabled: true
```

Also, you must set the Scalar Envoy configurations in the custom values file for ScalarDB Cluster. This is because clients need to send requests to ScalarDB Cluster via Scalar Envoy as the load balancer of gRPC requests if you deploy ScalarDB Cluster on a Kubernetes environment with `indirect` mode.

For more details on the Scalar Envoy configurations, see [Configure a custom values file for Scalar Envoy](configure-custom-values-envoy.md).

```yaml
envoy:
  configurationsForScalarEnvoy: 
    ...

scalardbCluster:
  configurationsForScalarDbCluster: 
    ...
```
