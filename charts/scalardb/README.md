# Scalar DB server Helm chart

The Helm chart for deployment to k8s cluster of the Scalar DB server.

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| scalardb.contactPoints | string | `"cassandra"` | The database contanct point such as a hostname of Cassandra or a URL of Cosmos DB account. |
| scalardb.contactPort | int | `9042` | The database port number. |
| scalardb.password | string | `"cassandra"` | The password of the database. For Cosmos DB, please specify a key here. |
| scalardb.username | string | `"cassandra"` | The username of the database. (Ignored if the database is `cosmos`.) |s
| scalardb.storage | string | `"cassandra"` | Storage implementation. Either cassandra or cosmos or dynamo or jdbc can be set. |
| scalardb.serverCfg.port | int | `60051` | The port of Scalar DB server. |
| scalardb.serverCfg.prometheus_http_endpoint_port | int | `8080` | The port of Prometheus service runnning in Scalar DB server. |
| scalardb.image.pullPolicy | string | `"IfNotPresent"` | Specify a imagePullPolicy |
| scalardb.image.repository | string | `"ghcr.io/scalar-labs/scalardb-server"` | Docker image reposiory of Scalar DB server |
| scalardb.image.tag | string | `"3.1.0"` | Docker tag |
| scalardb.imagePullSecrets | list | `[]` | Optionally specify an array of imagePullSecrets. Secrets must be manually created in the namespace. |
| service.type | string | `LoadBalancer` | The type of service in k8s. |
