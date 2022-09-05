# schema-loading

A schema loading tool for Scalar DL.
Current chart version is `2.6.0`

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| schemaLoading.cassandraReplicationFactor | int | `1` | The replication factor value of the Cassandra schema. This is a Cassandra specific option. |
| schemaLoading.cassandraReplicationStrategy | string | `"SimpleStrategy"` | The replication strategy of the Cassandra schema. This is a Cassandra specific option. |
| schemaLoading.commandArgs | list | `[]` | Arguments of Schema Loader. You can specify several args as array. |
| schemaLoading.contactPoints | string | `"cassandra"` | The database contanct point such as a hostname of Cassandra or a URL of Cosmos DB account. |
| schemaLoading.contactPort | int | `9042` | The database port number. (Ignored if the database is `cosmos`.) |
| schemaLoading.cosmosBaseResourceUnit | int | `400` | The resource unit value of the Cosmos DB schema. This is a Cosmos DB specific option. |
| schemaLoading.database | string | `"cassandra"` | The database to which the schema is loaded. `cassandra` and `cosmos` are supported. |
| schemaLoading.databaseProperties | string | `""` | If you want to customize database.properties, you can override this value with your database.properties. |
| schemaLoading.dynamoBaseResourceUnit | int | `10` | The resource unit value of the DynamoDB schema. This is a DynamoDB specific option. |
| schemaLoading.existingSecret | string | `""` | Name of existing secret to use for storing database username and password |
| schemaLoading.image.pullPolicy | string | `"IfNotPresent"` | Specify a imagePullPolicy |
| schemaLoading.image.repository | string | `"ghcr.io/scalar-labs/scalardl-schema-loader"` | Docker image |
| schemaLoading.image.version | string | `"3.5.0"` | Docker tag |
| schemaLoading.imagePullSecrets | list | `[{"name":"reg-docker-secrets"}]` | Optionally specify an array of imagePullSecrets. Secrets must be manually created in the namespace. |
| schemaLoading.password | string | `"cassandra"` | The password of the database. For Cosmos DB, please specify a key here. |
| schemaLoading.schemaType | string | `"ledger"` | Type of schema to apply (ledger or auditor). |
| schemaLoading.secretName | string | `""` | Secret name that includes sensitive data such as credentials. Each secret key is passed to Pod as environment variables using envFrom. |
| schemaLoading.username | string | `"cassandra"` | The username of the database. (Ignored if the database is `cosmos`.) |
