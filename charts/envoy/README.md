# envoy

![Version: 2.1.0](https://img.shields.io/badge/Version-2.1.0-informational?style=flat-square)  ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square)  ![AppVersion: 1.3.0](https://img.shields.io/badge/AppVersion-1.3.0-informational?style=flat-square)

Envoy Proxy for Scalar applications
Current chart version is `2.1.0`

**Homepage:** <https://scalar-labs.com/>

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| affinity | object | `{}` | the affinity/anti-affinity feature, greatly expands the types of constraints you can express |
| envoyConfiguration.adminAccessLogPath | string | `"/dev/stdout"` | admin log path |
| envoyConfiguration.serviceListeners | string | `"scalar-service:50051,scalar-privileged:50052"` | list of service name and port |
| grafanaDashboard.enabled | bool | `false` | enable grafana dashboard |
| grafanaDashboard.namespace | string | `"monitoring"` | which namespace grafana dashboard is located. by default monitoring |
| image.pullPolicy | string | `"IfNotPresent"` | Specify a imagePullPolicy |
| image.repository | string | `"ghcr.io/scalar-labs/scalar-envoy"` | Docker image |
| image.version | string | `"1.3.0"` |  |
| imagePullSecrets | list | `[]` | Optionally specify an array of imagePullSecrets. Secrets must be manually created in the namespace. |
| nodeSelector | object | `{}` | nodeSelector is form of node selection constraint |
| podAnnotations | object | `{}` | Pod annotations for the envoy Deployment |
| podSecurityContext | object | `{"seccompProfile":{"type":"RuntimeDefault"}}` | PodSecurityContext holds pod-level security attributes and common container settings |
| podSecurityPolicy.enabled | bool | `false` | enable pod security policy |
| prometheusRule.enabled | bool | `false` | enable rules for prometheus |
| prometheusRule.namespace | string | `"monitoring"` | which namespace prometheus is located. by default monitoring |
| rbac.create | bool | `true` | If true, create and use RBAC resources |
| rbac.serviceAccountAnnotations | object | `{}` | Annotations for the Service Account |
| replicaCount | int | `3` | number of replicas to deploy |
| resources | object | `{}` | resources allowed to the pod |
| securityContext | object | `{"allowPrivilegeEscalation":false,"capabilities":{"drop":["ALL"]},"runAsNonRoot":true}` | Setting security context at the pod applies those settings to all containers in the pod |
| securityContext.allowPrivilegeEscalation | bool | `false` | AllowPrivilegeEscalation controls whether a process can gain more privileges than its parent process |
| securityContext.capabilities | object | `{"drop":["ALL"]}` | Capabilities (specifically, Linux capabilities), are used for permission management in Linux. Some capabilities are enabled by default |
| securityContext.runAsNonRoot | bool | `true` | Containers should be run as a non-root user with the minimum required permissions (principle of least privilege) |
| service.annotations | object | `{}` | Service annotations, e.g: prometheus, etc. |
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
