# Configure a custom values file for ScalarDB Analytics with PostgreSQL

This document explains how to create your custom values file for the ScalarDB Analytics with PostgreSQL chart. For details on the parameters, see the [README](https://github.com/scalar-labs/helm-charts/blob/main/charts/scalardb-analytics-postgresql/README.md) of the ScalarDB Analytics with PostgreSQL chart.

## Required configurations

This section explains the required configurations when setting up a custom values file for ScalarDB Analytics with PostgreSQL.

### Database configurations

To access databases via ScalarDB Analytics with PostgreSQL, you must set the `scalardbAnalyticsPostgreSQL.databaseProperties` parameter by following the same syntax that you use to configure the `database.properties` file. For details about configurations, see [ScalarDB Configurations](https://github.com/scalar-labs/scalardb/blob/master/docs/configurations.md).

```yaml
scalardbAnalyticsPostgreSQL:
  databaseProperties: |
    scalar.db.contact_points=localhost
    scalar.db.username=${env:SCALAR_DB_USERNAME:-}
    scalar.db.password=${env:SCALAR_DB_PASSWORD:-}
    scalar.db.storage=cassandra
```

### Database namespaces configurations

You must set `schemaImporter.namespaces` to all the database namespaces that include tables you want to read via ScalarDB Analytics with PostgreSQL.

```yaml
schemaImporter:
  namespaces:
    - namespace1
    - namespace2
    - namespace3
```

## Optional configurations

This section explains the optional configurations when setting up a custom values file for ScalarDB Analytics with PostgreSQL.

### Resource configurations (recommended in production environments)

To control pod resources by using requests and limits in Kubernetes, you can use `scalardbAnalyticsPostgreSQL.resources`.

You can configure requests and limits by using the same syntax as requests and limits in Kubernetes. For more details on requests and limits in Kubernetes, see [Resource Management for Pods and Containers](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/).

```yaml
scalardbAnalyticsPostgreSQL:
  resources:
    requests:
      cpu: 1000m
      memory: 2Gi
    limits:
      cpu: 2000m
      memory: 4Gi
```

### Secret configurations (recommended in production environments)

To use environment variables to set some properties, like credentials, in `scalardbAnalyticsPostgreSQL.databaseProperties`, you can use `scalardbAnalyticsPostgreSQL.secretName` to specify the secret resource that includes some credentials.

For example, you can set credentials for a backend database (`scalar.db.username` and `scalar.db.password`) by using environment variables, which makes your pods more secure.

For more details on how to use a secret resource, see [How to use Secret resources to pass the credentials as the environment variables into the properties file](./use-secret-for-credentials.md).

```yaml
scalardbAnalyticsPostgreSQL:
  secretName: "scalardb-analytics-postgresql-credentials-secret"
```

### Affinity configurations (recommended in production environments)

To control pod deployment by using affinity and anti-affinity in Kubernetes, you can use `scalardbAnalyticsPostgreSQL.affinity`.

You can configure affinity and anti-affinity by using the same syntax for affinity and anti-affinity in Kubernetes. For more details on configuring affinity in Kubernetes, see [Assigning Pods to Nodes](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/).

```yaml
scalardbAnalyticsPostgreSQL:
  affinity:
    podAntiAffinity:
      requiredDuringSchedulingIgnoredDuringExecution:
        - labelSelector:
            matchExpressions:
              - key: app.kubernetes.io/name
                operator: In
                values:
                  - scalardb-analytics-postgresql
              - key: app.kubernetes.io/app
                operator: In
                values:
                  - scalardb-analytics-postgresql
          topologyKey: kubernetes.io/hostname
```

### SecurityContext configurations (default value is recommended)

To set SecurityContext and PodSecurityContext for ScalarDB Analytics with PostgreSQL pods, you can use `scalardbAnalyticsPostgreSQL.securityContext`, `scalardbAnalyticsPostgreSQL.podSecurityContext`, and `schemaImporter.securityContext`.

You can configure SecurityContext and PodSecurityContext by using the same syntax as SecurityContext and PodSecurityContext in Kubernetes. For more details on the SecurityContext and PodSecurityContext configurations in Kubernetes, see [Configure a Security Context for a Pod or Container](https://kubernetes.io/docs/tasks/configure-pod-container/security-context/).

```yaml
scalardbAnalyticsPostgreSQL:
  podSecurityContext:
    fsGroup: 201
    seccompProfile:
      type: RuntimeDefault
  securityContext:
    capabilities:
      drop:
        - ALL
    runAsNonRoot: true
    runAsUser: 999
    allowPrivilegeEscalation: false

schemaImporter:
  securityContext:
    capabilities:
      drop:
        - ALL
    runAsNonRoot: true
    allowPrivilegeEscalation: false
```

### Image configurations (default value is recommended)

If you want to change the image repository, you can use `scalardbAnalyticsPostgreSQL.image.repository` and `schemaImporter.image.repository` to specify the container repository information of the ScalarDB Analytics with PostgreSQL and Schema Importer images that you want to pull.

```yaml
scalardbAnalyticsPostgreSQL:
  image:
    repository: <SCALARDB_ANALYTICS_WITH_POSTGRESQL_CONTAINER_IMAGE>

schemaImporter:
  image:
    repository: <SCHEMA_IMPORTER_CONTAINER_IMAGE>
```

### Replica configurations (optional based on your environment)

You can specify the number of ScalarDB Analytics with PostgreSQL replicas (pods) by using `scalardbAnalyticsPostgreSQL.replicaCount`.

```yaml
scalardbAnalyticsPostgreSQL:
  replicaCount: 3
```

### PostgreSQL database name configuration (optional based on your environment)

You can specify the database name that you create in PostgreSQL. Schema Importer creates some objects, such as a view of ScalarDB Analytics with PostgreSQL, in this database.

```yaml
scalardbAnalyticsPostgreSQL:
  postgresql:
    databaseName: scalardb
```

### PostgreSQL superuser password configuration (optional based on your environment)

You can specify the secret name that includes the superuser password for PostgreSQL.

```yaml
scalardbAnalyticsPostgreSQL:
  postgresql:
    secretName: scalardb-analytics-postgresql-superuser-password
```

{% capture notice--info %}
**Note**

You must create a secret resource with this name (`scalardb-analytics-postgresql-superuser-password` by default) before you deploy ScalarDB Analytics with PostgreSQL. For details, see [Prepare a secret resource](./how-to-deploy-scalardb-analytics-postgresql.md#prepare-a-secret-resource).
{% endcapture %}

<div class="notice--info">{{ notice--info | markdownify }}</div>

### Taint and toleration configurations (optional based on your environment)

If you want to control pod deployment by using taints and tolerations in Kubernetes, you can use `scalardbAnalyticsPostgreSQL.tolerations`.

You can configure taints and tolerations by using the same syntax as the tolerations in Kubernetes. For details on configuring tolerations in Kubernetes, see the official Kubernetes documentation [Taints and Tolerations](https://kubernetes.io/docs/concepts/scheduling-eviction/taint-and-toleration/).

```yaml
scalardbAnalyticsPostgreSQL:
  tolerations:
    - effect: NoSchedule
      key: scalar-labs.com/dedicated-node
      operator: Equal
      value: scalardb-analytics-postgresql
```
