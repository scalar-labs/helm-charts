# envoy

![Version: 1.0.0](https://img.shields.io/badge/Version-1.0.0-informational?style=flat-square)  ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square)  ![AppVersion: 1.1.0](https://img.shields.io/badge/AppVersion-1.1.0-informational?style=flat-square)

Envoy Proxy for Scalar applications
Current chart version is `1.0.0`

**Homepage:** <https://scalar-labs.com/>

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| affinity | object | `{}` | the affinity/anti-affinity feature, greatly expands the types of constraints you can express |
| envoyConfiguration.adminAccessLogPath | string | `"/dev/stdout"` | admin log path |
| envoyConfiguration.upstreamAddress | string | `"envoy-headless"` | upstream address e.g: envoy-headless etc |
| grafanaDashboard.enabled | bool | `false` | enable grafana dashboard |
| grafanaDashboard.namespace | string | `"monitoring"` | which namespace grafana dashboard is located. by default monitoring |
| grafanaDashboard.title | string | `"Envoy Proxy / Overview"` | grafana dashboard title by default Envoy Proxy / Overview |
| grafanaDashboard.uid | string | `"envoy-proxy-001"` | grafana dashboard unique id by default envoy-proxy-001 |
| image.pullPolicy | string | `"IfNotPresent"` | Specify a imagePullPolicy |
| image.repository | string | `"ghcr.io/scalar-labs/scalar-envoy"` | Docker image |
| image.version | string | `"1.1.0"` |  |
| imagePullSecrets | list | `[]` | Optionally specify an array of imagePullSecrets. Secrets must be manually created in the namespace. |
| nodeSelector | object | `{}` | nodeSelector is form of node selection constraint |
| podSecurityContext | object | `{}` | PodSecurityContext holds pod-level security attributes and common container settings |
| prometheusRule.enabled | bool | `false` | enable rules for prometheus |
| prometheusRule.namespace | string | `"monitoring"` | which namespace prometheus is located. by default monitoring |
| replicaCount | int | `3` | number of replicas to deploy |
| resources | object | `{}` | resources allowed to the pod |
| securityContext | object | `{}` | Setting security context at the pod applies those settings to all containers in the pod |
| service.annotations | object | `{}` | Service annotations, e.g: prometheus, etc. |
| service.ports.envoy-priv.port | int | `50052` | nvoy public port |
| service.ports.envoy-priv.protocol | string | `"TCP"` | envoy protocol |
| service.ports.envoy-priv.targetPort | int | `50052` | envoy k8s internal name |
| service.ports.envoy.port | int | `50051` | envoy public port |
| service.ports.envoy.protocol | string | `"TCP"` | envoy protocol |
| service.ports.envoy.targetPort | int | `50051` | envoy k8s internal name |
| service.type | string | `"ClusterIP"` | service types in kubernetes |
| serviceMonitor.enabled | bool | `false` | enable metrics collect with prometheus |
| serviceMonitor.interval | string | `"15s"` | custom interval to retrieve the metrics |
| serviceMonitor.namespace | string | `"monitoring"` | which namespace prometheus is located. by default monitoring |
| strategy.rollingUpdate | object | `{"maxSurge":"25%","maxUnavailable":"25%"}` | The number of pods that can be unavailable during the update process |
| strategy.type | string | `"RollingUpdate"` | New pods are added gradually, and old pods are terminated gradually, e.g: Recreate or RollingUpdate |
| tolerations | list | `[]` | Tolerations are applied to pods, and allow (but do not require) the pods to schedule onto nodes with matching taints. |
