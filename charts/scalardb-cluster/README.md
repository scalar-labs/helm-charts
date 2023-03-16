# scalardb-cluster

ScalarDB Cluster
Current chart version is `1.0.0-SNAPSHOT`

## Requirements

| Repository | Name | Version |
|------------|------|---------|
| https://scalar-labs.github.io/helm-charts | envoy | ~2.2.0 |

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| envoy.enabled | bool | `true` | enable envoy |
| envoy.envoyConfiguration.serviceListeners | string | `"scalardb-cluster-service:60053"` | list of service name and port |
| envoy.image.version | string | `"1.3.0"` | Docker tag |
| envoy.nameOverride | string | `"scalardb-cluster"` | String to partially override envoy.fullname template |
| envoy.service.annotations | object | `{}` | Service annotations, e.g: prometheus, etc. |
| envoy.service.ports.envoy.port | int | `60053` | envoy public port |
| envoy.service.ports.envoy.protocol | string | `"TCP"` | envoy protocol |
| envoy.service.ports.envoy.targetPort | int | `60053` | envoy k8s internal name |
| envoy.service.type | string | `"ClusterIP"` | service types in kubernetes |
| fullnameOverride | string | `""` | String to fully override scalardb-cluster.fullname template |
| nameOverride | string | `""` | String to partially override scalardb-cluster.fullname template (will maintain the release name) |
| scalardbCluster.affinity | object | `{}` | The affinity/anti-affinity feature, greatly expands the types of constraints you can express. |
| scalardbCluster.existingSecret | string | `""` | Name of existing secret to use for storing database username and password. |
| scalardbCluster.extraVolumeMounts | list | `[]` | Defines additional volume mounts. If you want to get a heap dump of the ScalarDB Cluster node, you need to mount a volume to make the dump file persistent. |
| scalardbCluster.extraVolumes | list | `[]` | Defines additional volumes. If you want to get a heap dump of the ScalarDB Cluster node, you need to mount a volume to make the dump file persistent. |
| scalardbCluster.grafanaDashboard.enabled | bool | `false` | Enable grafana dashboard. |
| scalardbCluster.grafanaDashboard.namespace | string | `"monitoring"` | Which namespace grafana dashboard is located. by default monitoring. |
| scalardbCluster.image.pullPolicy | string | `"IfNotPresent"` | Specify a image pulling policy. |
| scalardbCluster.image.repository | string | `"ghcr.io/scalar-labs/scalardb-cluster-node"` | Docker image reposiory of ScalarDB Cluster. |
| scalardbCluster.image.tag | string | `""` | Override the image tag whose default is the chart appVersion |
| scalardbCluster.imagePullSecrets | list | `[]` | Optionally specify an array of imagePullSecrets. Secrets must be manually created in the namespace. |
| scalardbCluster.nodeSelector | object | `{}` | nodeSelector is form of node selection constraint. |
| scalardbCluster.podAnnotations | object | `{}` | Pod annotations for the scalardb-cluster deployment |
| scalardbCluster.podSecurityContext | object | `{"seccompProfile":{"type":"RuntimeDefault"}}` | PodSecurityContext holds pod-level security attributes and common container settings. |
| scalardbCluster.podSecurityPolicy.enabled | bool | `false` | Enable pod security policy |
| scalardbCluster.prometheusRule.enabled | bool | `false` | Enable rules for prometheus. |
| scalardbCluster.prometheusRule.namespace | string | `"monitoring"` | Which namespace prometheus is located. by default monitoring. |
| scalardbCluster.replicaCount | int | `3` | Default values for number of replicas. |
| scalardbCluster.resources | object | `{}` | Resources allowed to the pod. |
| scalardbCluster.scalardbClusterNodeProperties | string | The minimum template of database.properties is set by default. | The database.properties is created based on the values of scalardb-cluster.storageConfiguration by default. If you want to customize database.properties, you can override this value with your database.properties. |
| scalardbCluster.secretName | string | `""` | Secret name that includes sensitive data such as credentials. Each secret key is passed to Pod as environment variables using envFrom. |
| scalardbCluster.securityContext | object | `{"allowPrivilegeEscalation":false,"capabilities":{"drop":["ALL"]},"runAsNonRoot":true}` | Setting security context at the pod applies those settings to all containers in the pod. |
| scalardbCluster.securityContext.allowPrivilegeEscalation | bool | `false` | AllowPrivilegeEscalation controls whether a process can gain more privileges than its parent process |
| scalardbCluster.securityContext.capabilities | object | `{"drop":["ALL"]}` | Capabilities (specifically, Linux capabilities), are used for permission management in Linux. Some capabilities are enabled by default |
| scalardbCluster.securityContext.runAsNonRoot | bool | `true` | Containers should be run as a non-root user with the minimum required permissions (principle of least privilege) |
| scalardbCluster.service.ports.scalardb-cluster.port | int | `60053` | ScalarDB Cluster port. |
| scalardbCluster.service.ports.scalardb-cluster.protocol | string | `"TCP"` | ScalarDB Cluster protocol. |
| scalardbCluster.service.ports.scalardb-cluster.targetPort | int | `60053` | ScalarDB Cluster target port. |
| scalardbCluster.service.type | string | `"ClusterIP"` | service types in kubernetes. |
| scalardbCluster.serviceMonitor.enabled | bool | `false` | Enable metrics collect with prometheus. |
| scalardbCluster.serviceMonitor.interval | string | `"15s"` | Custom interval to retrieve the metrics. |
| scalardbCluster.serviceMonitor.namespace | string | `"monitoring"` | Which namespace prometheus is located. by default monitoring. |
| scalardbCluster.storageConfiguration.contactPoints | string | `"cassandra"` | The database contanct point such as a hostname of Cassandra or a URL of Cosmos DB account. |
| scalardbCluster.storageConfiguration.contactPort | int | `9042` | The database port number. |
| scalardbCluster.storageConfiguration.dbLogLevel | string | `"INFO"` | The log level of ScalarDB Cluster |
| scalardbCluster.storageConfiguration.password | string | `"cassandra"` | The password of the database. For Cosmos DB, Dynamo DB please specify a secret key here. |
| scalardbCluster.storageConfiguration.storage | string | `"cassandra"` | Storage implementation. Either cassandra or cosmos or dynamo or jdbc can be set. |
| scalardbCluster.storageConfiguration.username | string | `"cassandra"` | The username of the database. For Cosmos DB please leave blank. For Dynamo DB please specify key id here. |
| scalardbCluster.strategy.rollingUpdate.maxSurge | string | `"25%"` | The number of pods that can be created above the desired amount of pods during an update |
| scalardbCluster.strategy.rollingUpdate.maxUnavailable | string | `"25%"` | The number of pods that can be unavailable during the update process |
| scalardbCluster.strategy.type | string | `"RollingUpdate"` | New pods are added gradually, and old pods are terminated gradually, e.g: Recreate or RollingUpdate |
| scalardbCluster.tolerations | list | `[]` | Tolerations are applied to pods, and allow (but do not require) the pods to schedule onto nodes with matching taints. |
