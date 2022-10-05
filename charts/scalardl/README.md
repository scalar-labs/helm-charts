# scalardl

Scalar DL is a tamper-evident and scalable distributed database.
Current chart version is `4.4.0`

## Requirements

| Repository | Name | Version |
|------------|------|---------|
| https://scalar-labs.github.io/helm-charts | envoy | ~2.2.0 |

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| envoy.enabled | bool | `true` | enable envoy |
| envoy.envoyConfiguration.serviceListeners | string | `"scalardl-service:50051,scalardl-privileged:50052"` | list of service name and port |
| envoy.image.version | string | `"1.3.0"` | Docker tag |
| envoy.nameOverride | string | `"scalardl"` | String to partially override envoy.fullname template |
| envoy.service.annotations | object | `{}` | Service annotations, e.g: prometheus, etc. |
| envoy.service.ports.envoy-priv.port | int | `50052` | nvoy public port |
| envoy.service.ports.envoy-priv.protocol | string | `"TCP"` | envoy protocol |
| envoy.service.ports.envoy-priv.targetPort | int | `50052` | envoy k8s internal name |
| envoy.service.ports.envoy.port | int | `50051` | envoy public port |
| envoy.service.ports.envoy.protocol | string | `"TCP"` | envoy protocol |
| envoy.service.ports.envoy.targetPort | int | `50051` | envoy k8s internal name |
| envoy.service.type | string | `"ClusterIP"` | service types in kubernetes |
| fullnameOverride | string | `""` | String to fully override scalardl.fullname template |
| ledger.affinity | object | `{}` | the affinity/anti-affinity feature, greatly expands the types of constraints you can express |
| ledger.existingSecret | string | `""` | Name of existing secret to use for storing database username and password |
| ledger.extraVolumeMounts | list | `[]` | Defines additional volume mounts. |
| ledger.extraVolumes | list | `[]` | Defines additional volumes. |
| ledger.grafanaDashboard.enabled | bool | `false` | enable grafana dashboard |
| ledger.grafanaDashboard.namespace | string | `"monitoring"` | which namespace grafana dashboard is located. by default monitoring |
| ledger.image.pullPolicy | string | `"IfNotPresent"` | Specify a imagePullPolicy |
| ledger.image.repository | string | `"ghcr.io/scalar-labs/scalar-ledger"` | Docker image |
| ledger.image.version | string | `"3.6.0"` | Docker tag |
| ledger.imagePullSecrets | list | `[{"name":"reg-docker-secrets"}]` | Optionally specify an array of imagePullSecrets. Secrets must be manually created in the namespace. |
| ledger.ledgerProperties | string | The default minimum necessary values of ledger.properties are set. You can overwrite it with your own ledger.properties. | The ledger.properties is created based on the values of ledger.scalarLedgerConfiguration by default. If you want to customize ledger.properties, you can override this value with your ledger.properties. |
| ledger.nodeSelector | object | `{}` | nodeSelector is form of node selection constraint |
| ledger.podSecurityContext | object | `{"seccompProfile":{"type":"RuntimeDefault"}}` | PodSecurityContext holds pod-level security attributes and common container settings |
| ledger.prometheusRule.enabled | bool | `false` | enable rules for prometheus |
| ledger.prometheusRule.namespace | string | `"monitoring"` | which namespace prometheus is located. by default monitoring |
| ledger.replicaCount | int | `3` | number of replicas to deploy |
| ledger.resources | object | `{}` | resources allowed to the pod |
| ledger.scalarLedgerConfiguration.dbContactPoints | string | `"cassandra"` | The contact points of the database such as hostnames or URLs |
| ledger.scalarLedgerConfiguration.dbContactPort | int | `9042` | The port number of the contact points |
| ledger.scalarLedgerConfiguration.dbPassword | string | `"cassandra"` | The password of the database |
| ledger.scalarLedgerConfiguration.dbStorage | string | `"cassandra"` | The storage of the database: cassandra or cosmos |
| ledger.scalarLedgerConfiguration.dbUsername | string | `"cassandra"` | The username of the database |
| ledger.scalarLedgerConfiguration.ledgerAuditorEnabled | bool | `false` | Whether or not Auditor is enabled |
| ledger.scalarLedgerConfiguration.ledgerLogLevel | string | `"INFO"` | The log level of Scalar ledger |
| ledger.scalarLedgerConfiguration.ledgerPrivateKeySecretKey | string | `"private-key"` | The secret key of a Ledger private key |
| ledger.scalarLedgerConfiguration.ledgerProofEnabled | bool | `false` | Whether or not Asset Proof is enabled |
| ledger.scalarLedgerConfiguration.secretName | string | `"ledger-keys"` | The name of a Ledger secret |
| ledger.secretName | string | `""` | Secret name that includes sensitive data such as credentials. Each secret key is passed to Pod as environment variables using envFrom. |
| ledger.securityContext | object | `{"allowPrivilegeEscalation":false,"capabilities":{"drop":["ALL"]},"runAsNonRoot":true}` | Setting security context at the pod applies those settings to all containers in the pod |
| ledger.service.annotations | object | `{}` | Service annotations |
| ledger.service.ports.scalardl-admin.port | int | `50053` | scalardl-admin target port |
| ledger.service.ports.scalardl-admin.protocol | string | `"TCP"` | scalardl-admin protocol |
| ledger.service.ports.scalardl-admin.targetPort | int | `50053` | scalardl-admin k8s internal name |
| ledger.service.ports.scalardl-priv.port | int | `50052` | scalardl-priv target port |
| ledger.service.ports.scalardl-priv.protocol | string | `"TCP"` | scalardl-priv protocol |
| ledger.service.ports.scalardl-priv.targetPort | int | `50052` | scalardl-priv k8s internal name |
| ledger.service.ports.scalardl.port | int | `50051` | scalardl target port |
| ledger.service.ports.scalardl.protocol | string | `"TCP"` | scalardl protocol |
| ledger.service.ports.scalardl.targetPort | int | `50051` | scalardl k8s internal name |
| ledger.service.type | string | `"ClusterIP"` | service types in kubernetes |
| ledger.serviceMonitor.enabled | bool | `false` | enable metrics collect with prometheus |
| ledger.serviceMonitor.interval | string | `"15s"` | custom interval to retrieve the metrics |
| ledger.serviceMonitor.namespace | string | `"monitoring"` | which namespace prometheus is located. by default monitoring |
| ledger.strategy.rollingUpdate.maxSurge | string | `"25%"` | The number of pods that can be created above the desired amount of pods during an update |
| ledger.strategy.rollingUpdate.maxUnavailable | string | `"25%"` | The number of pods that can be unavailable during the update process |
| ledger.strategy.type | string | `"RollingUpdate"` | New pods are added gradually, and old pods are terminated gradually, e.g: Recreate or RollingUpdate |
| ledger.tolerations | list | `[]` | Tolerations are applied to pods, and allow (but do not require) the pods to schedule onto nodes with matching taints. |
| nameOverride | string | `""` | String to partially override scalardl.fullname template (will maintain the release name) |
