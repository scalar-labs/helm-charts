# scalardb

Scalar DB server
Current chart version is `2.3.0`

## Requirements

| Repository | Name | Version |
|------------|------|---------|
| https://scalar-labs.github.io/helm-charts | envoy | ~2.1.0 |

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| envoy.enabled | bool | `true` | enable envoy |
| envoy.envoyConfiguration.serviceListeners | string | `"scalardb-service:60051"` | list of service name and port |
| envoy.image.version | string | `"1.3.0"` | Docker tag |
| envoy.nameOverride | string | `"scalardb"` | String to partially override envoy.fullname template |
| envoy.service.annotations | object | `{}` | Service annotations, e.g: prometheus, etc. |
| envoy.service.ports.envoy.port | int | `60051` | envoy public port |
| envoy.service.ports.envoy.protocol | string | `"TCP"` | envoy protocol |
| envoy.service.ports.envoy.targetPort | int | `60051` | envoy k8s internal name |
| envoy.service.type | string | `"ClusterIP"` | service types in kubernetes |
| fullnameOverride | string | `""` | String to fully override scalardb.fullname template |
| nameOverride | string | `""` | String to partially override scalardb.fullname template (will maintain the release name) |
| scalardb.affinity | object | `{}` | The affinity/anti-affinity feature, greatly expands the types of constraints you can express. |
| scalardb.databaseProperties | string | The minimum template of database.properties is set by default. | The database.properties is created based on the values of scalardb.storageConfiguration by default. If you want to customize database.properties, you can override this value with your database.properties. |
| scalardb.existingSecret | string | `""` | Name of existing secret to use for storing database username and password. |
| scalardb.grafanaDashboard.enabled | bool | `false` | Enable grafana dashboard. |
| scalardb.grafanaDashboard.namespace | string | `"monitoring"` | Which namespace grafana dashboard is located. by default monitoring. |
| scalardb.image.pullPolicy | string | `"IfNotPresent"` | Specify a image pulling policy. |
| scalardb.image.repository | string | `"ghcr.io/scalar-labs/scalardb-server"` | Docker image reposiory of Scalar DB server. |
| scalardb.image.tag | string | `"3.6.0"` | Docker tag of the image. |
| scalardb.imagePullSecrets | list | `[]` | Optionally specify an array of imagePullSecrets. Secrets must be manually created in the namespace. |
| scalardb.nodeSelector | object | `{}` | nodeSelector is form of node selection constraint. |
| scalardb.podAnnotations | object | `{}` | Pod annotations for the scalardb deployment |
| scalardb.podSecurityContext | object | `{"seccompProfile":{"type":"RuntimeDefault"}}` | PodSecurityContext holds pod-level security attributes and common container settings. |
| scalardb.podSecurityPolicy.enabled | bool | `false` | Enable pod security policy |
| scalardb.prometheusRule.enabled | bool | `false` | Enable rules for prometheus. |
| scalardb.prometheusRule.namespace | string | `"monitoring"` | Which namespace prometheus is located. by default monitoring. |
| scalardb.rbac.create | bool | `true` | If true, create and use RBAC resources |
| scalardb.rbac.serviceAccountAnnotations | object | `{}` | Annotations for the Service Account |
| scalardb.replicaCount | int | `3` | Default values for number of replicas. |
| scalardb.resources | object | `{}` | Resources allowed to the pod. |
| scalardb.secretName | string | `""` | Secret name that includes sensitive data such as credentials. Each secret key is passed to Pod as environment variables using envFrom. |
| scalardb.securityContext | object | `{"allowPrivilegeEscalation":false,"capabilities":{"drop":["ALL"]},"runAsNonRoot":true}` | Setting security context at the pod applies those settings to all containers in the pod. |
| scalardb.securityContext.allowPrivilegeEscalation | bool | `false` | AllowPrivilegeEscalation controls whether a process can gain more privileges than its parent process |
| scalardb.securityContext.capabilities | object | `{"drop":["ALL"]}` | Capabilities (specifically, Linux capabilities), are used for permission management in Linux. Some capabilities are enabled by default |
| scalardb.securityContext.runAsNonRoot | bool | `true` | Containers should be run as a non-root user with the minimum required permissions (principle of least privilege) |
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
| scalardb.strategy.rollingUpdate.maxSurge | string | `"25%"` | The number of pods that can be created above the desired amount of pods during an update |
| scalardb.strategy.rollingUpdate.maxUnavailable | string | `"25%"` | The number of pods that can be unavailable during the update process |
| scalardb.strategy.type | string | `"RollingUpdate"` | New pods are added gradually, and old pods are terminated gradually, e.g: Recreate or RollingUpdate |
| scalardb.tolerations | list | `[]` | Tolerations are applied to pods, and allow (but do not require) the pods to schedule onto nodes with matching taints. |
