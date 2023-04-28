# Configure a custom values file for Scalar Envoy

This document explains how to create your custom values file for the Scalar Envoy chart. If you want to know the details of the parameters, please refer to the [README](https://github.com/scalar-labs/helm-charts/blob/main/charts/envoy/README.md) of the Scalar Envoy chart.

## Configure custom values for Scalar Envoy chart

The Scalar Envoy chart is used via other charts (scalardb, scalardl, and scalardl-audit). So, you don't need to create a custom values file for the Scalar Envoy chart. If you want to configure Scalar Envoy, you need to add configuration `envoy.*` to other charts.

For example, if you want to configure the Scalar Envoy for ScalarDB Server, you can configure some Scalar Envoy configurations in the custom values file of ScalarDB as follows.

* Example (scalardb-custom-values.yaml)
  ```yaml
  envoy:
    configurationsForScalarEnvoy: 
      ...
  
  scalardb:
    configurationsForScalarDB: 
       ...
  ```

## Required configurations

### Image configurations

You must set `envoy.image.repository` and `envoy.image.version`. Please specify the container repository information that you pull the Scalar Envoy container image.

```yaml
envoy:
  image:
    repository: <Container image of Scalar Envoy>
    version:  <Tag of image>
```

If you use AWS/Azure Marketplace, please refer to the following documents for more details.

* [How to install Scalar products through AWS Marketplace](https://github.com/scalar-labs/scalar-kubernetes/blob/master/docs/AwsMarketplaceGuide.md)
* [How to install Scalar products through Azure Marketplace](https://github.com/scalar-labs/scalar-kubernetes/blob/master/docs/AzureMarketplaceGuide.md)

### Service configurations

You must set `envoy.service.type` to specify the Service resource type of Kubernetes. If you want to use a load balancer provided by could providers, you need to set `envoy.service.type` to `LoadBalancer`.

```yaml
envoy:
  service:
    type: LoadBalancer
```

If you want to configure the load balancer via annotations, you can also set annotations to `envoy.service.annotations`.

```yaml
envoy:
  service:
    type: LoadBalancer
    annotations:
      service.beta.kubernetes.io/aws-load-balancer-internal: "true"
      service.beta.kubernetes.io/aws-load-balancer-type: "nlb"
```

## Optional configurations

### Resource configurations (Recommended in the production environment)

If you want to control pod resources using the requests and limits of Kubernetes, you can use `envoy.resources`.

You can configure them using the same syntax as the requests and limits of Kubernetes. So, please refer to the official document [Resource Management for Pods and Containers](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/) for more details on the requests and limits of Kubernetes.

```yaml
envoy:
  resources:
    requests:
      cpu: 200m
      memory: 256Mi
    limits:
      cpu: 300m
      memory: 328Mi
```

### Affinity configurations (Recommended in the production environment)

If you want to control pod deployment using the affinity and anti-affinity of Kubernetes, you can use `envoy.affinity`.

You can configure them using the same syntax as the affinity of Kubernetes. So, please refer to the official document [Assigning Pods to Nodes](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/) for more details on the affinity configuration of Kubernetes.

```yaml
envoy:
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
                  - envoy
          topologyKey: kubernetes.io/hostname
```

### Taints/Tolerations configurations (Recommended in the production environment)

If you want to control pod deployment using the taints and tolerations of Kubernetes, you can use `envoy.tolerations`.

You can configure them using the same syntax as the tolerations of Kubernetes. So, please refer to the official document [Taints and Tolerations](https://kubernetes.io/docs/concepts/scheduling-eviction/taint-and-toleration/) for more details on the tolerations configuration of Kubernetes.

```yaml
envoy:
  tolerations:
    - effect: NoSchedule
      key: scalar-labs.com/dedicated-node
      operator: Equal
      value: scalardb
```

### Prometheus/Grafana configurations (Recommended in the production environment)

If you want to monitor Scalar Envoy pods using [kube-prometheus-stack](https://github.com/prometheus-community/helm-charts/tree/main/charts/kube-prometheus-stack), you can deploy a ConfigMap, a ServiceMonitor, and a PrometheusRule resource for kube-prometheus-stack using `envoy.grafanaDashboard.enabled`, `envoy.serviceMonitor.enabled`, and `envoy.prometheusRule.enabled`.

```yaml
envoy:
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

If you want to set SecurityContext and PodSecurityContext for Scalar Envoy pods, you can use `envoy.securityContext` and `envoy.podSecurityContext`.

You can configure them using the same syntax as SecurityContext and PodSecurityContext of Kubernetes. So, please refer to the official document [Configure a Security Context for a Pod or Container](https://kubernetes.io/docs/tasks/configure-pod-container/security-context/) for more details on the SecurityContext and PodSecurityContext configurations of Kubernetes.

```yaml
envoy:
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

You can specify the number of replicas (pods) of Scalar Envoy using `envoy.replicaCount`.

```yaml
envoy:
  replicaCount: 3
```
