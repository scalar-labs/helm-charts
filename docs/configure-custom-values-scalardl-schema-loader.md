# Configure a custom values file for ScalarDL Schema Loader

This document explains how to create your custom values file for the ScalarDL Schema Loader chart. If you want to know the details of the parameters, please refer to the [README](https://github.com/scalar-labs/helm-charts/blob/main/charts/schema-loading/README.md) of the ScalarDL Schema Loader chart.

## Required configurations

### Image configurations

You must set `schemaLoading.image.repository`. Be sure to specify the ScalarDL Schema Loader container image so that you can pull the image from the container repository.

```yaml
schemaLoading:
  image:
    repository: <SCALARDL_SCHEMA_LOADER_CONTAINER_IMAGE>
```

If you're using AWS or Azure, please refer to the following documents for more details:

* [How to install Scalar products through AWS Marketplace](https://github.com/scalar-labs/scalar-kubernetes/blob/master/docs/AwsMarketplaceGuide.md)
* [How to install Scalar products through Azure Marketplace](https://github.com/scalar-labs/scalar-kubernetes/blob/master/docs/AzureMarketplaceGuide.md)

### Database configurations

You must set `schemaLoading.databaseProperties`. Please set your `database.properties` to access the backend database to this parameter. Please refer to the [Getting Started with ScalarDB](https://github.com/scalar-labs/scalardb/blob/master/docs/getting-started-with-scalardb.md) for more details on the database configuration of ScalarDB.

```yaml
schemaLoading:
  databaseProperties: |
    scalar.db.contact_points=cassandra
    scalar.db.contact_port=9042
    scalar.db.username=cassandra
    scalar.db.password=cassandra
    scalar.db.storage=cassandra
```

### Schema type configurations

You must set `schemaLoading.schemaType`.

If you create the schema of ScalarDL Ledger, please set `ledger`.

```yaml
schemaLoading:
  schemaType: ledger
```

If you create the schema of ScalarDL Auditor, please set `auditor`.

```yaml
schemaLoading:
  schemaType: auditor
```

## Optional configurations

### Secret configurations (Recommended in the production environment)

If you want to use environment variables to set some properties (e.g., credentials) in the `schemaLoading.databaseProperties`, you can use `schemaLoading.secretName` to specify the Secret resource that includes some credentials.

For example, you can set credentials for a backend database (`scalar.db.username` and `scalar.db.password`) using environment variables, which makes your pods more secure.

Please refer to the document [How to use Secret resources to pass the credentials as the environment variables into the properties file](./use-secret-for-credentials.md) for more details on how to use a Secret resource.

```yaml
schemaLoading:
  secretName: "schema-loader-credentials-secret"
```

### Flags configurations (Optional based on your environment)

You can specify several flags as an array. Please refer to the document [ScalarDB Schema Loader](https://github.com/scalar-labs/scalardb/blob/master/docs/schema-loader.md) for more details on the flags.

```yaml
schemaLoading:
  commandArgs:
  - "--alter"
  - "--compaction-strategy"
  - "<compactionStrategy>"
  - "--delete-all"
  - "--no-backup"
  - "--no-scaling"
  - "--repair-all"
  - "--replication-factor"
  - "<replicaFactor>"
  - "--replication-strategy"
  - "<replicationStrategy>"
  - "--ru"
  - "<ru>"
```
