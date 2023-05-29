# Configure a custom values file for ScalarDL Ledger

This document explains how to create your custom values file for the ScalarDL Ledger chart. If you want to know the details of the parameters, please refer to the [README](https://github.com/scalar-labs/helm-charts/blob/main/charts/scalardl/README.md) of the ScalarDL Ledger chart.

## Required configurations

### Scalar Envoy configurations

You must set the Scalar Envoy configurations in the custom values file for ScalarDL Ledger. This is because client requests are sent to ScalarDL Ledger via Scalar Envoy as the load balancer of gRPC requests if you deploy ScalarDL Ledger on a Kubernetes environment.

Please refer to the document [Configure a custom values file for Scalar Envoy](configure-custom-values-envoy.md) for more details on the Scalar Envoy configurations.

```yaml
envoy:
  configurationsForScalarEnvoy: 
    ...

ledger:
  configurationsForScalarDLLedger: 
    ...
```

### Image configurations

You must set `ledger.image.repository` and `ledger.image.version`. Please specify the container repository information that you pull the ScalarDL Ledger container image.

```yaml
ledger:
  image:
    repository: <Container image of ScalarDL Ledger>
    version: <Tag of image>
```

If you use AWS/Azure Marketplace, please refer to the following documents for more details.

* [How to install Scalar products through AWS Marketplace](https://github.com/scalar-labs/scalar-kubernetes/blob/master/docs/AwsMarketplaceGuide.md)
* [How to install Scalar products through Azure Marketplace](https://github.com/scalar-labs/scalar-kubernetes/blob/master/docs/AzureMarketplaceGuide.md)

### Ledger/Database configurations

You must set `ledger.ledgerProperties`. Please set your `ledger.properties` to this parameter. Please refer to the [ledger.properties](https://github.com/scalar-labs/scalar/blob/master/ledger/conf/ledger.properties) for more details on the configuration of ScalarDL Ledger.

```yaml
ledger:
  ledgerProperties: |
    scalar.db.contact_points=localhost
    scalar.db.username=cassandra
    scalar.db.password=cassandra
    scalar.db.storage=cassandra
    scalar.dl.ledger.proof.enabled=true
    scalar.dl.ledger.auditor.enabled=true
    scalar.dl.ledger.proof.private_key_path=/keys/ledger-key-file
```

### Key/Certificate configurations

If you set `scalar.dl.ledger.proof.enabled` to `true` (this configuration is required if you use ScalarDL Auditor), you must set a private key file to `scalar.dl.ledger.proof.private_key_path`.

In this case, you must mount the private key file on the ScalarDL Ledger pod.

For more details on how to mount the private key file, refer to [Mount key and certificate files on a pod in ScalarDL Helm Charts](./mount-files-or-volumes-on-scalar-pods.md#mount-key-and-certificate-files-on-a-pod-in-scalardl-helm-charts).

## Optional configurations

### Resource configurations (Recommended in the production environment)

If you want to control pod resources using the requests and limits of Kubernetes, you can use `ledger.resources`.

Note that the resources for one pod of Scalar products are limited to 2vCPU / 4GB memory from the perspective of the commercial license. Also, when you get the pay-as-you-go containers provided from AWS Marketplace, you cannot run those containers with more than 2vCPU / 4GB memory configuration in the `resources.limits`. When you exceed this limitation, pods are automatically stopped.

You can configure them using the same syntax as the requests and limits of Kubernetes. So, please refer to the official document [Resource Management for Pods and Containers](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/) for more details on the requests and limits of Kubernetes.

```yaml
ledger:
  resources:
    requests:
      cpu: 2000m
      memory: 4Gi
    limits:
      cpu: 2000m
      memory: 4Gi
```

### Secret configurations (Recommended in the production environment)

If you want to use environment variables to set some properties (e.g., credentials) in the `ledger.ledgerProperties`, you can use `ledger.secretName` to specify the Secret resource that includes some credentials.

For example, you can set credentials for a backend database (`scalar.db.username` and `scalar.db.password`) using environment variables, which makes your pods more secure.

Please refer to the document [How to use Secret resources to pass the credentials as the environment variables into the properties file](./use-secret-for-credentials.md) for more details on how to use a Secret resource.

```yaml
ledger:
  secretName: "ledger-credentials-secret"
```

### Affinity configurations (Recommended in the production environment)

If you want to control pod deployment using the affinity and anti-affinity of Kubernetes, you can use `ledger.affinity`.

You can configure them using the same syntax as the affinity of Kubernetes. So, please refer to the official document [Assigning Pods to Nodes](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/) for more details on the affinity configuration of Kubernetes.

```yaml
ledger:
  affinity:
    nodeAffinity:
      requiredDuringSchedulingIgnoredDuringExecution:
        nodeSelectorTerms:
          - matchExpressions:
              - key: scalar-labs.com/dedicated-node
                operator: In
                values:
                  - scalardl-ledger
    podAntiAffinity:
      requiredDuringSchedulingIgnoredDuringExecution:
        - labelSelector:
            matchExpressions:
              - key: app.kubernetes.io/name
                operator: In
                values:
                  - scalardl
              - key: app.kubernetes.io/app
                operator: In
                values:
                  - ledger
          topologyKey: kubernetes.io/hostname
```

### Taints/Tolerations configurations (Recommended in the production environment)

If you want to control pod deployment using the taints and tolerations of Kubernetes, you can use `ledger.tolerations`.

You can configure them using the same syntax as the tolerations of Kubernetes. So, please refer to the official document [Taints and Tolerations](https://kubernetes.io/docs/concepts/scheduling-eviction/taint-and-toleration/) for more details on the tolerations configuration of Kubernetes.

```yaml
ledger:
  tolerations:
    - effect: NoSchedule
      key: scalar-labs.com/dedicated-node
      operator: Equal
      value: scalardl-ledger
```

### Prometheus/Grafana configurations (Recommended in the production environment)

If you want to monitor ScalarDL Ledger pods using [kube-prometheus-stack](https://github.com/prometheus-community/helm-charts/tree/main/charts/kube-prometheus-stack), you can deploy a ConfigMap, a ServiceMonitor, and a PrometheusRule resource for kube-prometheus-stack using `ledger.grafanaDashboard.enabled`, `ledger.serviceMonitor.enabled`, and `ledger.prometheusRule.enabled`.

```yaml
ledger:
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

If you want to set SecurityContext and PodSecurityContext for ScalarDL Ledger pods, you can use `ledger.securityContext` and `ledger.podSecurityContext`.

You can configure them using the same syntax as SecurityContext and PodSecurityContext of Kubernetes. So, please refer to the official document [Configure a Security Context for a Pod or Container](https://kubernetes.io/docs/tasks/configure-pod-container/security-context/) for more details on the SecurityContext and PodSecurityContext configurations of Kubernetes.

```yaml
ledger:
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

You can specify the number of replicas (pods) of ScalarDL Ledger using `ledger.replicaCount`.

```yaml
ledger:
  replicaCount: 3
```

### Logging configurations (Optional based on your environment)

If you want to change the log level of ScalarDL Ledger, you can use `ledger.scalarLedgerConfiguration.ledgerLogLevel`.

```yaml
ledger:
  scalarLedgerConfiguration:
    ledgerLogLevel: INFO
```
