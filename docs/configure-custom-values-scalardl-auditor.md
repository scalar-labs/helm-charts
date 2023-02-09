# Configure a custom values file for ScalarDL Auditor

This document explains how to create your custom values file for the ScalarDL Auditor chart. If you want to know the details of the parameters, please refer to the [README](https://github.com/scalar-labs/helm-charts/blob/main/charts/scalardl-audit/README.md) of the ScalarDL Auditor chart.

## Required configurations

### Scalar Envoy configurations

You must set the Scalar Envoy configurations in the custom values file for ScalarDL Auditor. This is because client requests are sent to ScalarDL Auditor via Scalar Envoy as the load balancer of gRPC requests if you deploy ScalarDL Auditor on a Kubernetes environment.

Please refer to the document [Configure a custom values file for Scalar Envoy](configure-custom-values-envoy.md) for more details on the Scalar Envoy configurations.

```yaml
envoy:
  configurationsForScalarEnvoy: 
    ...

auditor:
  configurationsForScalarDLAuditor: 
    ...
```

### Image configurations

You must set `auditor.image.repository` and `auditor.image.version`. Please specify the container repository information that you pull the ScalarDL Auditor container image.

```yaml
auditor:
  image:
    repository: <Container image of ScalarDL Auditor>
    version: <Tag of image>
```

If you use AWS/Azure Marketplace, please refer to the following documents for more details.

* [How to install Scalar products through AWS Marketplace](https://github.com/scalar-labs/scalar-kubernetes/blob/master/docs/AwsMarketplaceGuide.md)
* [How to install Scalar products through Azure Marketplace](https://github.com/scalar-labs/scalar-kubernetes/blob/master/docs/AzureMarketplaceGuide.md)

### Auditor/Database configurations

You must set `auditor.auditorProperties`. Please set your `auditor.properties` to this parameter. Please refer to the [auditor.properties](https://github.com/scalar-labs/scalar/blob/master/auditor/conf/auditor.properties) for more details on the configuration of ScalarDL Auditor.

```yaml
auditor:
  auditorProperties: |
    scalar.db.contact_points=localhost
    scalar.db.username=cassandra
    scalar.db.password=cassandra
    scalar.db.storage=cassandra
    scalar.dl.auditor.ledger.host=<Host name to access ScalarDL Ledger pods>
    scalar.dl.auditor.private_key_path=/keys/auditor-key-file
    scalar.dl.auditor.cert_path=/keys/auditor-cert-file
```

### Key/Certificate configurations

You must set a private key file to `scalar.dl.auditor.private_key_path` and a certificate file to `scalar.dl.auditor.cert_path`.

You must also mount the private key file and the certificate file on the ScalarDL Auditor pod.

Please refer to the document [Mount key/certificate files to the pod in ScalarDL Helm Charts](mount-key-and-cert-for-scalardl.md) for more details on how to mount the private key file and the certificate file.

## Optional configurations

### Resource configurations (Recommended in the production environment)

If you want to control pod resources using the requests and limits of Kubernetes, you can use `auditor.resources`.

Note that the resources for one pod of Scalar products are limited to 2vCPU / 4GB memory from the perspective of the commercial license. Also, when you get the pay-as-you-go containers provided from AWS Marketplace, you cannot run those containers with more than 2vCPU / 4GB memory configuration in the `resources.limits`. When you exceed this limitation, pods are automatically stopped.

You can configure them using the same syntax as the requests and limits of Kubernetes. So, please refer to the official document [Resource Management for Pods and Containers](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/) for more details on the requests and limits of Kubernetes.

```yaml
auditor:
  resources:
    requests:
      cpu: 2000m
      memory: 4Gi
    limits:
      cpu: 2000m
      memory: 4Gi
```

### Secret configurations

If you want to use environment variables to set some properties (e.g., credentials) in the `auditor.auditorProperties`, you can use `auditor.secretName` to specify the Secret resource that includes some credentials.

For example, you can set credentials for a backend database (`scalar.db.username` and `scalar.db.password`) using environment variables, which makes your pods more secure.

Please refer to the document [How to use Secret resources to pass the credentials as the environment variables into the properties file](./use-secret-for-credentilas.md) for more details on how to use a Secret resource.

```yaml
auditor:
  secretName: "auditor-credentials-secret"
```

### Affinity configurations (Recommended in the production environment)

If you want to control pod deployment using the affinity and anti-affinity of Kubernetes, you can use `auditor.affinity`.

You can configure them using the same syntax as the affinity of Kubernetes. So, please refer to the official document [Assigning Pods to Nodes](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/) for more details on the affinity configuration of Kubernetes.

```yaml
auditor:
  affinity:
    nodeAffinity:
      requiredDuringSchedulingIgnoredDuringExecution:
        nodeSelectorTerms:
          - matchExpressions:
              - key: scalar-labs.com/dedicated-node
                operator: In
                values:
                  - scalardl-auditor
    podAntiAffinity:
      requiredDuringSchedulingIgnoredDuringExecution:
        - labelSelector:
            matchExpressions:
              - key: app.kubernetes.io/name
                operator: In
                values:
                  - scalardl-audit
              - key: app.kubernetes.io/app
                operator: In
                values:
                  - auditor
          topologyKey: kubernetes.io/hostname
```

### Taints/Tolerations configurations (Recommended in the production environment)

If you want to control pod deployment using the taints and tolerations of Kubernetes, you can use `auditor.tolerations`.

You can configure them using the same syntax as the tolerations of Kubernetes. So, please refer to the official document [Taints and Tolerations](https://kubernetes.io/docs/concepts/scheduling-eviction/taint-and-toleration/) for more details on the tolerations configuration of Kubernetes.

```yaml
auditor:
  tolerations:
    - effect: NoSchedule
      key: scalar-labs.com/dedicated-node
      operator: Equal
      value: scalardl-auditor
```

### Prometheus/Grafana configurations (Recommended in the production environment)

If you want to monitor ScalarDL Auditor pods using [kube-prometheus-stack](https://github.com/prometheus-community/helm-charts/tree/main/charts/kube-prometheus-stack), you can deploy a ConfigMap, a ServiceMonitor, and a PrometheusRule resource for kube-prometheus-stack using `auditor.grafanaDashboard.enabled`, `auditor.serviceMonitor.enabled`, and `auditor.prometheusRule.enabled`.

```yaml
auditor:
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

If you want to set SecurityContext and PodSecurityContext for ScalarDL Auditor pods, you can use `auditor.securityContext` and `auditor.podSecurityContext`.

You can configure them using the same syntax as SecurityContext and PodSecurityContext of Kubernetes. So, please refer to the official document [Configure a Security Context for a Pod or Container](https://kubernetes.io/docs/tasks/configure-pod-container/security-context/) for more details on the SecurityContext and PodSecurityContext configurations of Kubernetes.

```yaml
auditor:
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

You can specify the number of replicas (pods) of ScalarDL Auditor using `auditor.replicaCount`.

```yaml
auditor:
  replicaCount: 3
```

### Logging configurations (Optional based on your environment)

If you want to change the log level of ScalarDL Auditor, you can use `auditor.scalarAuditorConfiguration.auditorLogLevel`.

```yaml
auditor:
  scalarAuditorConfiguration:
    auditorLogLevel: INFO
```
