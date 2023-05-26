# Configure a custom values file for ScalarDB Server

This document explains how to create your custom values file for the ScalarDB Server chart. If you want to know the details of the parameters, please refer to the [README](https://github.com/scalar-labs/helm-charts/blob/main/charts/scalardb/README.md) of the ScalarDB Server chart.

## Required configurations

### Scalar Envoy configurations

You must set the Scalar Envoy configurations in the custom values file for ScalarDB Server. This is because client requests are sent to ScalarDB Server via Scalar Envoy as the load balancer of gRPC requests if you deploy ScalarDB Server on a Kubernetes environment.

Please refer to the document [Configure a custom values file for Scalar Envoy](configure-custom-values-envoy.md) for more details on the Scalar Envoy configurations.

```yaml
envoy:
  configurationsForScalarEnvoy: 
    ...

scalardb:
  configurationsForScalarDB: 
    ...
```

### Image configurations

You must set `scalardb.image.repository` and `scalardb.image.tag`. Please specify the container repository information that you pull the ScalarDB Server container image.

```yaml
scalardb:
  image:
    repository: <Container image of ScalarDB Server>
    tag: <Tag of image>
```

If you use AWS/Azure Marketplace, please refer to the following documents for more details.

* [How to install Scalar products through AWS Marketplace](https://github.com/scalar-labs/scalar-kubernetes/blob/master/docs/AwsMarketplaceGuide.md)
* [How to install Scalar products through Azure Marketplace](https://github.com/scalar-labs/scalar-kubernetes/blob/master/docs/AzureMarketplaceGuide.md)

### Database configurations

You must set `scalardb.databaseProperties`. Please set your `database.properties` to this parameter. Please refer to the [Configure ScalarDB Server](https://github.com/scalar-labs/scalardb/blob/master/docs/scalardb-server.md#configure-scalardb-server) for more details on the configuration of ScalarDB Server.

```yaml
scalardb:
  databaseProperties: |
    scalar.db.server.port=60051
    scalar.db.server.prometheus_exporter_port=8080
    scalar.db.server.grpc.max_inbound_message_size=
    scalar.db.server.grpc.max_inbound_metadata_size=
    scalar.db.contact_points=localhost
    scalar.db.username=cassandra
    scalar.db.password=cassandra
    scalar.db.storage=cassandra
    scalar.db.transaction_manager=consensus-commit
    scalar.db.consensus_commit.isolation_level=SNAPSHOT
    scalar.db.consensus_commit.serializable_strategy=
    scalar.db.consensus_commit.include_metadata.enabled=false
```

## Optional configurations

### Resource configurations (Recommended in the production environment)

If you want to control pod resources using the requests and limits of Kubernetes, you can use `scalardb.resources`.

Note that the resources for one pod of Scalar products are limited to 2vCPU / 4GB memory from the perspective of the commercial license. Also, when you get the pay-as-you-go containers provided from AWS Marketplace, you cannot run those containers with more than 2vCPU / 4GB memory configuration in the `resources.limits`. When you exceed this limitation, pods are automatically stopped.

You can configure them using the same syntax as the requests and limits of Kubernetes. So, please refer to the official document [Resource Management for Pods and Containers](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/) for more details on the requests and limits of Kubernetes.

```yaml
scalardb:
  resources:
    requests:
      cpu: 2000m
      memory: 4Gi
    limits:
      cpu: 2000m
      memory: 4Gi
```

### Secret configurations (Recommended in the production environment)

If you want to use environment variables to set some properties (e.g., credentials) in the `scalardb.databaseProperties`, you can use `scalardb.secretName` to specify the Secret resource that includes some credentials.

For example, you can set credentials for a backend database (`scalar.db.username` and `scalar.db.password`) using environment variables, which makes your pods more secure.

Please refer to the document [How to use Secret resources to pass the credentials as the environment variables into the properties file](./use-secret-for-credentials.md) for more details on how to use a Secret resource.

```yaml
scalardb:
  secretName: "scalardb-credentials-secret"
```

### Affinity configurations (Recommended in the production environment)

If you want to control pod deployment using the affinity and anti-affinity of Kubernetes, you can use `scalardb.affinity`.

You can configure them using the same syntax as the affinity of Kubernetes. So, please refer to the official document [Assigning Pods to Nodes](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/) for more details on the affinity configuration of Kubernetes.

```yaml
scalardb:
  affinity:
    nodeAffinity:
      requiredDuringSchedulingIgnoredDuringExecution:
        nodeSelectorTerms:
          - matchExpressions:
              - key: scalar-labs.com/dedicated-node
                operator: In
                values:
                  - scalardb
    podAntiAffinity:
      requiredDuringSchedulingIgnoredDuringExecution:
        - labelSelector:
            matchExpressions:
              - key: app.kubernetes.io/name
                operator: In
                values:
                  - scalardb
              - key: app.kubernetes.io/app
                operator: In
                values:
                  - scalardb
          topologyKey: kubernetes.io/hostname
```

### Taints/Tolerations configurations (Recommended in the production environment)

If you want to control pod deployment using the taints and tolerations of Kubernetes, you can use `scalardb.tolerations`.

You can configure them using the same syntax as the tolerations of Kubernetes. So, please refer to the official document [Taints and Tolerations](https://kubernetes.io/docs/concepts/scheduling-eviction/taint-and-toleration/) for more details on the tolerations configuration of Kubernetes.

```yaml
scalardb:
  tolerations:
    - effect: NoSchedule
      key: scalar-labs.com/dedicated-node
      operator: Equal
      value: scalardb
```

### Prometheus/Grafana configurations  (Recommended in the production environment)

If you want to monitor ScalarDB Server pods using [kube-prometheus-stack](https://github.com/prometheus-community/helm-charts/tree/main/charts/kube-prometheus-stack), you can deploy a ConfigMap, a ServiceMonitor, and a PrometheusRule resource for kube-prometheus-stack using `scalardb.grafanaDashboard.enabled`, `scalardb.serviceMonitor.enabled`, and `scalardb.prometheusRule.enabled`.

```yaml
scalardb:
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

If you want to set SecurityContext and PodSecurityContext for ScalarDB Server pods, you can use `scalardb.securityContext` and `scalardb.podSecurityContext`.

You can configure them using the same syntax as SecurityContext and PodSecurityContext of Kubernetes. So, please refer to the official document [Configure a Security Context for a Pod or Container](https://kubernetes.io/docs/tasks/configure-pod-container/security-context/) for more details on the SecurityContext and PodSecurityContext configurations of Kubernetes.

```yaml
scalardb:
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

You can specify the number of replicas (pods) of ScalarDB Server using `scalardb.replicaCount`.

```yaml
scalardb:
  replicaCount: 3
```

### Logging configurations (Optional based on your environment)

If you want to change the log level of ScalarDB Server, you can use `scalardb.storageConfiguration.dbLogLevel`.

```yaml
scalardb:
  storageConfiguration:
    dbLogLevel: INFO
```
