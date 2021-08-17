# scalardb

Scalar DB server
Current chart version is `1.0.0`

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| fullnameOverride | string | `""` | String to fully override scalardb.fullname template |
| nameOverride | string | `""` | String to partially override scalardb.fullname template (will maintain the release name) |
| scalardb.affinity | object | `{}` | The affinity/anti-affinity feature, greatly expands the types of constraints you can express. |
| scalardb.existingSecret | string | `nil` | Name of existing secret to use for storing database username and password. |
| scalardb.grafanaDashboard.enabled | bool | `false` | Enable grafana dashboard. |
| scalardb.grafanaDashboard.namespace | string | `"monitoring"` | Which namespace grafana dashboard is located. by default monitoring. |
| scalardb.image.pullPolicy | string | `"IfNotPresent"` |  |
| scalardb.image.repository | string | `"ghcr.io/scalar-labs/scalardb-server"` | Docker image reposiory of Scalar DB server. |
| scalardb.image.tag | string | `"3.1.0"` | Docker tag of the image. |
| scalardb.imagePullSecrets | list | `[]` | Optionally specify an array of imagePullSecrets. Secrets must be manually created in the namespace. |
| scalardb.nodeSelector | object | `{}` | nodeSelector is form of node selection constraint. |
| scalardb.podSecurityContext | object | `{}` | PodSecurityContext holds pod-level security attributes and common container settings. |
| scalardb.prometheusRule.enabled | bool | `false` | Enable rules for prometheus. |
| scalardb.prometheusRule.namespace | string | `"monitoring"` | Which namespace prometheus is located. by default monitoring. |
| scalardb.replicaCount | int | `3` | Default values for number of replicas. |
| scalardb.resources | object | `{}` | Resources allowed to the pod. |
| scalardb.securityContext | object | `{}` | Setting security context at the pod applies those settings to all containers in the pod. |
| scalardb.service.ports.scalardb.port | int | `60051` | Scalar DB server port. |
| scalardb.service.ports.scalardb.protocol | string | `"TCP"` | Scalar DB server protocol. |
| scalardb.service.ports.scalardb.targetPort | int | `60051` | Scalar DB server target port. |
| scalardb.service.type | string | `"ClusterIP"` | service types in kubernetes. |
| scalardb.serviceMonitor.enabled | bool | `false` | Enable metrics collect with prometheus. |
| scalardb.serviceMonitor.interval | string | `"15s"` | Custom interval to retrieve the metrics. |
| scalardb.serviceMonitor.namespace | string | `"monitoring"` | Which namespace prometheus is located. by default monitoring. |
| scalardb.storageConfiguration.contactPoints | string | `"cassandra"` | The database contanct point such as a hostname of Cassandra or a URL of Cosmos DB account. |
| scalardb.storageConfiguration.contactPort | int | `9042` | The database port number. |
| scalardb.storageConfiguration.dbLogLevel | string | `"INFO"` | The log level of Scalar DB |
| scalardb.storageConfiguration.password | string | `"cassandra"` | The password of the database. For Cosmos DB, Dynamo DB please specify a secret key here. |
| scalardb.storageConfiguration.storage | string | `"cassandra"` | Storage implementation. Either cassandra or cosmos or dynamo or jdbc can be set. |
| scalardb.storageConfiguration.username | string | `"cassandra"` | The username of the database. For Cosmos DB please leave blank. For Dynamo DB please specify key id here. |
| scalardb.strategy.rollingUpdate | object | `{"maxSurge":"25%","maxUnavailable":"25%"}` | The number of pods that can be unavailable during the update process |
| scalardb.strategy.type | string | `"RollingUpdate"` | New pods are added gradually, and old pods are terminated gradually, e.g: Recreate or RollingUpdate |
| scalardb.tolerations | list | `[]` | Tolerations are applied to pods, and allow (but do not require) the pods to schedule onto nodes with matching taints. |
