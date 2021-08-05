# scalardb

A Helm chart of Scalar DB
Current chart version is `2.0.0`

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| affinity | object | `{}` | The affinity/anti-affinity feature, greatly expands the types of constraints you can express. |
| existingSecret | string | `nil` | Name of existing secret to use for storing database username and password. |
| fullnameOverride | string | `""` | String to fully override scalardl.fullname template |
| nameOverride | string | `""` | String to partially override scalardl.fullname template (will maintain the release name) |
| nodeSelector | object | `{}` | nodeSelector is form of node selection constraint. |
| podSecurityContext | object | `{}` | PodSecurityContext holds pod-level security attributes and common container settings. |
| replicaCount | int | `1` | Default values for number of replicas. |
| resources | object | `{}` | Resources allowed to the pod. |
| scalardb.contactPoints | string | `"192.168.10.105"` | The database contanct point such as a hostname of Cassandra or a URL of Cosmos DB account. |
| scalardb.contactPort | int | `9042` | The database port number. |
| scalardb.image.pullPolicy | string | `"IfNotPresent"` |  |
| scalardb.image.repository | string | `"ghcr.io/scalar-labs/scalardb-server"` | Docker image reposiory of Scalar DB server. |
| scalardb.image.tag | string | `"3.1.0"` | Docker tag of the image. |
| scalardb.imagePullSecrets | list | `[]` | Optionally specify an array of imagePullSecrets. Secrets must be manually created in the namespace. |
| scalardb.password | string | `"cassandra"` | The password of the database. For Cosmos DB, Dynamo DB please specify a secret key here. |
| scalardb.server.port | int | `60051` | The port of Scalar DB server. |
| scalardb.server.prometheus_http_endpoint_port | int | `8080` | The port of Prometheus service runnning in Scalar DB server. |
| scalardb.storage | string | `"cassandra"` | Storage implementation. Either cassandra or cosmos or dynamo or jdbc can be set. |
| scalardb.username | string | `"cassandra"` | The username of the database. For Cosmos DB please leave blank. For Dynamo DB please specify key id here. |
| securityContext | object | `{}` | Setting security context at the pod applies those settings to all containers in the pod. |
| service.ports.scalardb-server-prometheus.port | int | `8080` | Prometheus of Scalar DB server protocol. |
| service.ports.scalardb-server-prometheus.protocol | string | `"TCP"` |  |
| service.ports.scalardb-server-prometheus.targetPort | int | `8080` |  |
| service.ports.scalardb-server.port | int | `60051` | Scalar DB server port. |
| service.ports.scalardb-server.protocol | string | `"TCP"` | Scalar DB server protocol. |
| service.ports.scalardb-server.targetPort | int | `60051` | Scalar DB server target port. |
| service.type | string | `"LoadBalancer"` | service types in kubernetes. |
| strategy.rollingUpdate | object | `{"maxSurge":"25%","maxUnavailable":"25%"}` | The number of pods that can be unavailable during the update process |
| strategy.type | string | `"RollingUpdate"` | New pods are added gradually, and old pods are terminated gradually, e.g: Recreate or RollingUpdate |
| tolerations | list | `[]` | Tolerations are applied to pods, and allow (but do not require) the pods to schedule onto nodes with matching taints. |
