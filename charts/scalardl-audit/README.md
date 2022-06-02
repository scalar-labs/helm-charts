# scalardl-audit

Scalar DL is a tamper-evident and scalable distributed database. This chart adds an auditing capability to Ledger (scalardl chart).
Current chart version is `2.1.4`

## Requirements

| Repository | Name | Version |
|------------|------|---------|
| https://scalar-labs.github.io/helm-charts | envoy | ~2.0.1 |

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| auditor.affinity | object | `{}` | the affinity/anti-affinity feature, greatly expands the types of constraints you can express |
| auditor.existingSecret | string | `""` | Name of existing secret to use for storing database username and password |
| auditor.grafanaDashboard.enabled | bool | `false` | enable grafana dashboard |
| auditor.grafanaDashboard.namespace | string | `"monitoring"` | which namespace grafana dashboard is located. by default monitoring |
| auditor.image.pullPolicy | string | `"IfNotPresent"` | Specify a imagePullPolicy |
| auditor.image.repository | string | `"ghcr.io/scalar-labs/scalar-auditor"` | Docker image |
| auditor.image.version | string | `"3.3.4"` | Docker tag |
| auditor.imagePullSecrets | list | `[{"name":"reg-docker-secrets"}]` | Optionally specify an array of imagePullSecrets. Secrets must be manually created in the namespace. |
| auditor.nodeSelector | object | `{}` | nodeSelector is form of node selection constraint |
| auditor.podSecurityContext | object | `{}` | PodSecurityContext holds pod-level security attributes and common container settings |
| auditor.prometheusRule.enabled | bool | `false` | enable rules for prometheus |
| auditor.prometheusRule.namespace | string | `"monitoring"` | which namespace prometheus is located. by default monitoring |
| auditor.replicaCount | int | `3` | number of replicas to deploy |
| auditor.resources | object | `{}` | resources allowed to the pod |
| auditor.scalarAuditorConfiguration.auditorCertHolderId | string | `"auditor"` | The holder ID of an Auditor certificate |
| auditor.scalarAuditorConfiguration.auditorCertSecretKey | string | `"certificate"` | The secret key of an Auditor certificate |
| auditor.scalarAuditorConfiguration.auditorCertVersion | int | `1` | The version of an Auditor certificate |
| auditor.scalarAuditorConfiguration.auditorLedgerHost | string | `""` | The host name of Ledger. The service endpoint of Ledger-side envoy should be specified |
| auditor.scalarAuditorConfiguration.auditorLogLevel | string | `"INFO"` | The log level of Scalar auditor |
| auditor.scalarAuditorConfiguration.auditorPrivateKeySecretKey | string | `"private-key"` | The secret key of an Auditor private key |
| auditor.scalarAuditorConfiguration.auditorServerAdminPort | int | `50053` | The port number of Auditor Admin Server |
| auditor.scalarAuditorConfiguration.auditorServerPort | int | `50051` | The port number of Auditor Server |
| auditor.scalarAuditorConfiguration.auditorServerPrivilegedPort | int | `50052` | The port number of Auditor Privileged Server |
| auditor.scalarAuditorConfiguration.dbContactPoints | string | `"cassandra"` | The contact points of the database such as hostnames or URLs |
| auditor.scalarAuditorConfiguration.dbContactPort | int | `9042` | The port number of the contact points |
| auditor.scalarAuditorConfiguration.dbPassword | string | `"cassandra"` | The password of the database |
| auditor.scalarAuditorConfiguration.dbStorage | string | `"cassandra"` | The storage of the database: cassandra or cosmos |
| auditor.scalarAuditorConfiguration.dbUsername | string | `"cassandra"` | The username of the database |
| auditor.scalarAuditorConfiguration.secretName | string | `"auditor-keys"` | The name of an Auditor secret |
| auditor.securityContext | object | `{}` | Setting security context at the pod applies those settings to all containers in the pod |
| auditor.service.annotations | object | `{}` | Service annotations |
| auditor.service.ports.scalardl-auditor-admin.port | int | `50053` | scalardl-admin target port |
| auditor.service.ports.scalardl-auditor-admin.protocol | string | `"TCP"` | scalardl-admin protocol |
| auditor.service.ports.scalardl-auditor-admin.targetPort | int | `50053` | scalardl-admin k8s internal name |
| auditor.service.ports.scalardl-auditor-priv.port | int | `50052` | scalardl-priv target port |
| auditor.service.ports.scalardl-auditor-priv.protocol | string | `"TCP"` | scalardl-priv protocol |
| auditor.service.ports.scalardl-auditor-priv.targetPort | int | `50052` | scalardl-priv k8s internal name |
| auditor.service.ports.scalardl-auditor.port | int | `50051` | scalardl target port |
| auditor.service.ports.scalardl-auditor.protocol | string | `"TCP"` | scalardl protocol |
| auditor.service.ports.scalardl-auditor.targetPort | int | `50051` | scalardl k8s internal name |
| auditor.service.type | string | `"ClusterIP"` | service types in kubernetes |
| auditor.serviceMonitor.enabled | bool | `false` | enable metrics collect with prometheus |
| auditor.serviceMonitor.interval | string | `"15s"` | custom interval to retrieve the metrics |
| auditor.serviceMonitor.namespace | string | `"monitoring"` | which namespace prometheus is located. by default monitoring |
| auditor.strategy.rollingUpdate.maxSurge | string | `"25%"` | The number of pods that can be created above the desired amount of pods during an update |
| auditor.strategy.rollingUpdate.maxUnavailable | string | `"25%"` | The number of pods that can be unavailable during the update process |
| auditor.strategy.type | string | `"RollingUpdate"` | New pods are added gradually, and old pods are terminated gradually, e.g: Recreate or RollingUpdate |
| auditor.tolerations | list | `[]` | Tolerations are applied to pods, and allow (but do not require) the pods to schedule onto nodes with matching taints. |
| envoy.affinity | object | `{}` | the affinity/anti-affinity feature, greatly expands the types of constraints you can express |
| envoy.enabled | bool | `true` | enable envoy |
| envoy.envoyConfiguration.adminAccessLogPath | string | `"/dev/stdout"` | admin log path |
| envoy.envoyConfiguration.serviceListeners | string | `"scalardl-audit-service:50051,scalardl-audit-privileged:50052"` | list of service name and port |
| envoy.grafanaDashboard.enabled | bool | `false` | enable grafana dashboard |
| envoy.grafanaDashboard.namespace | string | `"monitoring"` | which namespace grafana dashboard is located. by default monitoring |
| envoy.image.pullPolicy | string | `"IfNotPresent"` | Specify a imagePullPolicy |
| envoy.image.repository | string | `"ghcr.io/scalar-labs/scalar-envoy"` | Docker image |
| envoy.image.version | string | `"1.2.0"` | Docker tag |
| envoy.imagePullSecrets | list | `[]` | Optionally specify an array of imagePullSecrets. Secrets must be manually created in the namespace. |
| envoy.nameOverride | string | `"scalardl-audit"` | String to partially override envoy.fullname template |
| envoy.nodeSelector | object | `{}` | nodeSelector is form of node selection constraint |
| envoy.podSecurityContext | object | `{}` | PodSecurityContext holds pod-level security attributes and common container settings |
| envoy.prometheusRule.enabled | bool | `false` | enable rules for prometheus |
| envoy.prometheusRule.namespace | string | `"monitoring"` | which namespace prometheus is located. by default monitoring |
| envoy.replicaCount | int | `3` | number of replicas to deploy |
| envoy.resources | object | `{}` | resources allowed to the pod |
| envoy.securityContext | object | `{}` | Setting security context at the pod applies those settings to all containers in the pod |
| envoy.service.annotations | object | `{}` | Service annotations, e.g: prometheus, etc. |
| envoy.service.ports.envoy-priv.port | int | `40052` | envoy public port |
| envoy.service.ports.envoy-priv.protocol | string | `"TCP"` | envoy protocol |
| envoy.service.ports.envoy-priv.targetPort | int | `50052` | envoy k8s internal name |
| envoy.service.ports.envoy.port | int | `40051` | envoy public port |
| envoy.service.ports.envoy.protocol | string | `"TCP"` | envoy protocol |
| envoy.service.ports.envoy.targetPort | int | `50051` | envoy k8s internal name |
| envoy.service.type | string | `"ClusterIP"` | service types in kubernetes |
| envoy.serviceMonitor.enabled | bool | `false` | enable metrics collect with prometheus |
| envoy.serviceMonitor.interval | string | `"15s"` | custom interval to retrieve the metrics |
| envoy.serviceMonitor.namespace | string | `"monitoring"` | which namespace prometheus is located. by default monitoring |
| envoy.strategy.rollingUpdate.maxSurge | string | `"25%"` | The number of pods that can be created above the desired amount of pods during an update |
| envoy.strategy.rollingUpdate.maxUnavailable | string | `"25%"` | The number of pods that can be unavailable during the update process |
| envoy.strategy.type | string | `"RollingUpdate"` | New pods are added gradually, and old pods are terminated gradually, e.g: Recreate or RollingUpdate |
| envoy.tolerations | list | `[]` | Tolerations are applied to pods, and allow (but do not require) the pods to schedule onto nodes with matching taints. |
| fullnameOverride | string | `""` | String to fully override scalardl-audit.fullname template |
| nameOverride | string | `""` | String to partially override scalardl-audit.fullname template (will maintain the release name) |
