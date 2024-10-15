# scalardb-graphql

ScalarDB GraphQL server
Current chart version is `1.4.7`

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| affinity | object | `{}` | The affinity/anti-affinity feature, greatly expands the types of constraints you can express. |
| existingSecret | string | `""` | Name of existing secret to use for storing database username and password. |
| fullnameOverride | string | `""` |  |
| grafanaDashboard.enabled | bool | `false` | enable grafana dashboard |
| grafanaDashboard.namespace | string | `"monitoring"` | which namespace grafana dashboard is located. by default monitoring |
| image.pullPolicy | string | `"IfNotPresent"` | Specify a image pulling policy. |
| image.repository | string | `"ghcr.io/scalar-labs/scalardb-graphql"` | Docker image reposiory of ScalarDB GraphQL. |
| image.tag | string | `"3.9.7"` | Docker tag of the image. |
| imagePullSecrets | list | `[{"name":"reg-docker-secrets"}]` | Optionally specify an array of imagePullSecrets. Secrets must be manually created in the namespace. |
| ingress.annotations | object | `{"alb.ingress.kubernetes.io/healthcheck-path":"/graphql?query=%7B__typename%7D","alb.ingress.kubernetes.io/scheme":"internal","alb.ingress.kubernetes.io/target-group-attributes":"stickiness.enabled=true,stickiness.lb_cookie.duration_seconds=60","alb.ingress.kubernetes.io/target-type":"ip","nginx.ingress.kubernetes.io/affinity":"cookie","nginx.ingress.kubernetes.io/session-cookie-hash":"sha1","nginx.ingress.kubernetes.io/session-cookie-max-age":"300","nginx.ingress.kubernetes.io/session-cookie-name":"INGRESSCOOKIE","nginx.ingress.kubernetes.io/session-cookie-path":"/"}` | The class-specific annotations for the ingress resource. |
| ingress.className | string | `""` | The ingress class name. Specify "alb" for AWS Application Load Balancer. |
| ingress.enabled | bool | `true` | Enable ingress resource. |
| ingress.hosts | list | `[{"host":"","paths":[{"path":"/graphql","pathType":"Exact"}]}]` | List of rules that are handled with the the ingress. |
| ingress.tls | list | `[]` |  |
| nameOverride | string | `""` |  |
| nodeSelector | object | `{}` | nodeSelector is form of node selection constraint. |
| podSecurityContext | object | `{}` | PodSecurityContext holds pod-level security attributes and common container settings. |
| prometheusRule.enabled | bool | `false` | enable rules for prometheus |
| prometheusRule.namespace | string | `"monitoring"` | which namespace prometheus is located. by default monitoring |
| replicaCount | int | `3` |  |
| resources | object | `{}` | Resources allowed to the pod. |
| scalarDbGraphQlConfiguration.consensuscommitIsolationLevel | string | `""` | Default isolation level for ConsensusCommit. |
| scalarDbGraphQlConfiguration.consensuscommitSerializableStrategy | string | `""` | Default serializable strategy for ConsensusCommit transaction manager. |
| scalarDbGraphQlConfiguration.contactPoints | string | `"cassandra"` | The database contact point such as a hostname of Cassandra or a URL of Cosmos DB account. |
| scalarDbGraphQlConfiguration.contactPort | int | `9042` | The database port number. |
| scalarDbGraphQlConfiguration.graphiql | string | `"true"` | Whether the GraphQL server serves GraphiQL IDE. The default is true. |
| scalarDbGraphQlConfiguration.logLevel | string | `"INFO"` | The log level of ScalarDB GraphQL |
| scalarDbGraphQlConfiguration.namespaces | string | `""` | Comma-separated list of namespaces of tables for which the GraphQL server generates a schema. |
| scalarDbGraphQlConfiguration.password | string | `"cassandra"` | The password of the database. For Cosmos DB, Dynamo DB please specify a secret key here. |
| scalarDbGraphQlConfiguration.path | string | `"/graphql"` | Path component of the URL of the GraphQL endpoint. The default is /graphql. |
| scalarDbGraphQlConfiguration.storage | string | `"cassandra"` | Storage implementation. Either cassandra or cosmos or dynamo or jdbc can be set. |
| scalarDbGraphQlConfiguration.transactionManager | string | `"consensus-commit"` | The type of the transaction manager. |
| scalarDbGraphQlConfiguration.username | string | `"cassandra"` | The username of the database. For Cosmos DB please leave blank. For Dynamo DB please specify key id here. |
| securityContext | object | `{}` | Setting security context at the pod applies those settings to all containers in the pod. |
| service.annotations | object | `{}` | Service annotations, e.g: prometheus, etc. |
| service.port | int | `8080` | ScalarDB GraphQL server port. |
| service.type | string | `"ClusterIP"` | service types in kubernetes. |
| serviceMonitor.enabled | bool | `false` | enable metrics collect with prometheus |
| serviceMonitor.interval | string | `"15s"` | custom interval to retrieve the metrics |
| serviceMonitor.namespace | string | `"monitoring"` | which namespace prometheus is located. by default monitoring |
| strategy.rollingUpdate.maxSurge | string | `"25%"` | The number of pods that can be created above the desired amount of pods during an update |
| strategy.rollingUpdate.maxUnavailable | string | `"25%"` | The number of pods that can be unavailable during the update process |
| strategy.type | string | `"RollingUpdate"` | New pods are added gradually, and old pods are terminated gradually, e.g: Recreate or RollingUpdate |
| tolerations | list | `[]` | Tolerations are applied to pods, and allow (but do not require) the pods to schedule onto nodes with matching taints. |
