# scalardb-analytics-postgresql

ScalarDB Analytics with PostgreSQL
Current chart version is `2.0.0-SNAPSHOT`

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| fullnameOverride | string | `""` | String to fully override scalardb-analytics-postgresql.fullname template |
| nameOverride | string | `""` | String to partially override scalardb-analytics-postgresql.fullname template (will maintain the release name) |
| scalardbAnalyticsPostgreSQL.affinity | object | `{}` | The affinity/anti-affinity feature greatly expands the types of constraints you can express. |
| scalardbAnalyticsPostgreSQL.databaseProperties | string | The minimum template of database.properties is set by default. | The database.properties to access the underlying databases that Schema Importer will load schemas into PostgreSQL. |
| scalardbAnalyticsPostgreSQL.extraVolumeMounts | list | `[]` | Defines additional volume mounts. |
| scalardbAnalyticsPostgreSQL.extraVolumes | list | `[]` | Defines additional volumes. If you want to mount a volume for PGDATA, you can mount extra volumes. |
| scalardbAnalyticsPostgreSQL.image.pullPolicy | string | `"IfNotPresent"` | Specify an image-pulling policy. |
| scalardbAnalyticsPostgreSQL.image.repository | string | `"ghcr.io/scalar-labs/scalardb-analytics-postgresql"` | Docker image repository of ScalarDB Analytics with PostgreSQL. |
| scalardbAnalyticsPostgreSQL.image.tag | string | `""` | Override the image tag with a default that is the chart appVersion. |
| scalardbAnalyticsPostgreSQL.imagePullSecrets | list | `[{"name":"reg-docker-secrets"}]` | Optionally specify an array of imagePullSecrets. Secrets must be manually created in the namespace. |
| scalardbAnalyticsPostgreSQL.nodeSelector | object | `{}` | nodeSelector is a form of node selection constraint. |
| scalardbAnalyticsPostgreSQL.podAnnotations | object | `{}` | Pod annotations for the scalardb-analytics-postgresql deployment. |
| scalardbAnalyticsPostgreSQL.podSecurityContext | object | `{"fsGroup":201,"seccompProfile":{"type":"RuntimeDefault"}}` | PodSecurityContext holds pod-level security attributes and common container settings. |
| scalardbAnalyticsPostgreSQL.podSecurityContext.fsGroup | int | `201` | For ScalarDB Analytics with PostgreSQL to work properly, you must set "podSecurityContext.fsGroup" to "201". |
| scalardbAnalyticsPostgreSQL.postgresql.databaseName | string | `"scalardb"` | The database name that you create in PostgreSQL. Schema Importer creates some objects such as a view of ScalarDB Analytics with PostgreSQL in this database. |
| scalardbAnalyticsPostgreSQL.postgresql.secretName | string | `"scalardb-analytics-postgresql-superuser-password"` | The secret resource name that includes superuser password for PostgreSQL. |
| scalardbAnalyticsPostgreSQL.replicaCount | int | `3` | Default values for number of replicas. |
| scalardbAnalyticsPostgreSQL.resources | object | `{}` | Resources allowed to the pod. |
| scalardbAnalyticsPostgreSQL.secretName | string | `""` | Secret name that includes sensitive data such as credentials. Each secret key is passed to a pod as environment variables by using envFrom. |
| scalardbAnalyticsPostgreSQL.securityContext | object | `{"allowPrivilegeEscalation":false,"capabilities":{"drop":["ALL"]},"runAsNonRoot":true,"runAsUser":999}` | Setting security context at the pod applies those settings to all containers in the pod. |
| scalardbAnalyticsPostgreSQL.securityContext.allowPrivilegeEscalation | bool | `false` | AllowPrivilegeEscalation controls whether a process can gain more privileges than its parent process. |
| scalardbAnalyticsPostgreSQL.securityContext.capabilities | object | `{"drop":["ALL"]}` | Capabilities (specifically, Linux capabilities), are used for permission management in Linux. Some capabilities are enabled by default. |
| scalardbAnalyticsPostgreSQL.securityContext.runAsNonRoot | bool | `true` | Containers should be run as a non-root user with the minimum required permissions (principle of least privilege). |
| scalardbAnalyticsPostgreSQL.securityContext.runAsUser | int | `999` | The official PostgreSQL image uses the "postgres (UID=999)" user by default. |
| scalardbAnalyticsPostgreSQL.service.annotations | object | `{}` | Service annotations, e.g: prometheus, etc. |
| scalardbAnalyticsPostgreSQL.service.ports.postgresql.port | int | `5432` | PostgreSQL public port |
| scalardbAnalyticsPostgreSQL.service.ports.postgresql.protocol | string | `"TCP"` | PostgreSQL protocol |
| scalardbAnalyticsPostgreSQL.service.ports.postgresql.targetPort | int | `5432` | PostgreSQL k8s internal port |
| scalardbAnalyticsPostgreSQL.service.type | string | `"ClusterIP"` | Service types in Kubernetes |
| scalardbAnalyticsPostgreSQL.serviceAccount.automountServiceAccountToken | bool | `false` | Specify whether to mount a service account token or not. |
| scalardbAnalyticsPostgreSQL.serviceAccount.serviceAccountName | string | `""` | Name of the existing service account resource. |
| scalardbAnalyticsPostgreSQL.strategy.rollingUpdate.maxSurge | string | `"25%"` | The number of pods that can be created above the desired amount of pods during an update. |
| scalardbAnalyticsPostgreSQL.strategy.rollingUpdate.maxUnavailable | string | `"25%"` | The number of pods that can be unavailable during the update process. |
| scalardbAnalyticsPostgreSQL.strategy.type | string | `"RollingUpdate"` | New pods are added gradually, and old pods are terminated gradually, e.g: Recreate or RollingUpdate |
| scalardbAnalyticsPostgreSQL.tolerations | list | `[]` | Tolerations are applied to pods and allow (but do not require) the pods to schedule onto nodes with matching taints. |
| schemaImporter.entrypointShell.maxRetryCount | int | `10` | Maximum retry count of Schema Importer in entrypoint.sh. |
| schemaImporter.entrypointShell.retryInterval | int | `3` | Retry interval of Schema Importer in entrypoint.sh. |
| schemaImporter.image.pullPolicy | string | `"IfNotPresent"` | Specify an image-pulling policy. |
| schemaImporter.image.repository | string | `"ghcr.io/scalar-labs/scalardb-analytics-postgresql-schema-importer"` | Docker image repository of Schema Importer. |
| schemaImporter.image.tag | string | `""` | Override the image tag with a default that is the chart appVersion |
| schemaImporter.namespaces | list | `[]` | Namespace list that includes tables you want to read via ScalarDB Analytics with PostgreSQL. |
| schemaImporter.securityContext | object | `{"allowPrivilegeEscalation":false,"capabilities":{"drop":["ALL"]},"runAsNonRoot":true}` | Setting security context at the pod applies those settings to all containers in the pod. |
| schemaImporter.securityContext.allowPrivilegeEscalation | bool | `false` | AllowPrivilegeEscalation controls whether a process can gain more privileges than its parent process. |
| schemaImporter.securityContext.capabilities | object | `{"drop":["ALL"]}` | Capabilities (specifically, Linux capabilities), are used for permission management in Linux. Some capabilities are enabled by default. |
| schemaImporter.securityContext.runAsNonRoot | bool | `true` | Containers should be run as a non-root user with the minimum required permissions (principle of least privilege). |
