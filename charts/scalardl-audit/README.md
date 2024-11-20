# scalardl-audit

ScalarDL is a tamper-evident and scalable distributed database. This chart adds an auditing capability to Ledger (scalardl chart).
Current chart version is `3.0.0-SNAPSHOT`

## Requirements

| Repository | Name | Version |
|------------|------|---------|
| file://../envoy/ | envoy | ~3.0.0-SNAPSHOT |

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| auditor.affinity | object | `{}` | the affinity/anti-affinity feature, greatly expands the types of constraints you can express |
| auditor.auditorProperties | string | The default minimum necessary values of auditor.properties are set. You can overwrite it with your own auditor.properties. | The auditor.properties is created based on the values of auditor.scalarAuditorConfiguration by default. If you want to customize auditor.properties, you can override this value with your auditor.properties. |
| auditor.existingSecret | string | `""` | Name of existing secret to use for storing database username and password |
| auditor.extraVolumeMounts | list | `[]` | Defines additional volume mounts. |
| auditor.extraVolumes | list | `[]` | Defines additional volumes. |
| auditor.grafanaDashboard.enabled | bool | `false` | enable grafana dashboard |
| auditor.grafanaDashboard.namespace | string | `"monitoring"` | which namespace grafana dashboard is located. by default monitoring |
| auditor.image.pullPolicy | string | `"IfNotPresent"` | Specify a imagePullPolicy |
| auditor.image.repository | string | `"ghcr.io/scalar-labs/scalar-auditor"` | Docker image |
| auditor.image.version | string | `"4.0.0-SNAPSHOT"` | Docker tag |
| auditor.imagePullSecrets | list | `[{"name":"reg-docker-secrets"}]` | Optionally specify an array of imagePullSecrets. Secrets must be manually created in the namespace. |
| auditor.nodeSelector | object | `{}` | nodeSelector is form of node selection constraint |
| auditor.podSecurityContext | object | `{"seccompProfile":{"type":"RuntimeDefault"}}` | PodSecurityContext holds pod-level security attributes and common container settings |
| auditor.prometheusRule.enabled | bool | `false` | enable rules for prometheus |
| auditor.prometheusRule.namespace | string | `"monitoring"` | which namespace prometheus is located. by default monitoring |
| auditor.replicaCount | int | `3` | number of replicas to deploy |
| auditor.resources | object | `{}` | resources allowed to the pod |
| auditor.scalarAuditorConfiguration.auditorCertHolderId | string | `"auditor"` | The holder ID of an Auditor certificate |
| auditor.scalarAuditorConfiguration.auditorCertSecretKey | string | `"certificate"` | The secret key of an Auditor certificate |
| auditor.scalarAuditorConfiguration.auditorCertVersion | int | `1` | The version of an Auditor certificate |
| auditor.scalarAuditorConfiguration.auditorLedgerHost | string | `""` | The host name of Ledger. The service endpoint of Ledger-side envoy should be specified |
| auditor.scalarAuditorConfiguration.auditorLogLevel | string | `"INFO"` | The log level of Scalar auditor |
| auditor.scalarAuditorConfiguration.auditorPrivateKeySecretKey | string | `"private-key"` | The secret key of an Auditor private key |
| auditor.scalarAuditorConfiguration.auditorServerAdminPort | int | `40053` | The port number of Auditor Admin Server |
| auditor.scalarAuditorConfiguration.auditorServerPort | int | `40051` | The port number of Auditor Server |
| auditor.scalarAuditorConfiguration.auditorServerPrivilegedPort | int | `40052` | The port number of Auditor Privileged Server |
| auditor.scalarAuditorConfiguration.dbContactPoints | string | `"cassandra"` | The contact points of the database such as hostnames or URLs |
| auditor.scalarAuditorConfiguration.dbContactPort | int | `9042` | The port number of the contact points |
| auditor.scalarAuditorConfiguration.dbPassword | string | `"cassandra"` | The password of the database |
| auditor.scalarAuditorConfiguration.dbStorage | string | `"cassandra"` | The storage of the database: cassandra or cosmos |
| auditor.scalarAuditorConfiguration.dbUsername | string | `"cassandra"` | The username of the database |
| auditor.scalarAuditorConfiguration.secretName | string | `"auditor-keys"` | The name of an Auditor secret |
| auditor.secretName | string | `""` | Secret name that includes sensitive data such as credentials. Each secret key is passed to Pod as environment variables using envFrom. |
| auditor.securityContext | object | `{"allowPrivilegeEscalation":false,"capabilities":{"drop":["ALL"]},"runAsNonRoot":true}` | Setting security context at the pod applies those settings to all containers in the pod |
| auditor.service.annotations | object | `{}` | Service annotations |
| auditor.service.ports.scalardl-auditor-admin.port | int | `40053` | scalardl-admin target port |
| auditor.service.ports.scalardl-auditor-admin.protocol | string | `"TCP"` | scalardl-admin protocol |
| auditor.service.ports.scalardl-auditor-admin.targetPort | int | `40053` | scalardl-admin k8s internal name |
| auditor.service.ports.scalardl-auditor-priv.port | int | `40052` | scalardl-priv target port |
| auditor.service.ports.scalardl-auditor-priv.protocol | string | `"TCP"` | scalardl-priv protocol |
| auditor.service.ports.scalardl-auditor-priv.targetPort | int | `40052` | scalardl-priv k8s internal name |
| auditor.service.ports.scalardl-auditor.port | int | `40051` | scalardl target port |
| auditor.service.ports.scalardl-auditor.protocol | string | `"TCP"` | scalardl protocol |
| auditor.service.ports.scalardl-auditor.targetPort | int | `40051` | scalardl k8s internal name |
| auditor.service.type | string | `"ClusterIP"` | service types in kubernetes |
| auditor.serviceAccount.automountServiceAccountToken | bool | `false` | Specify to mount a service account token or not |
| auditor.serviceAccount.serviceAccountName | string | `""` | Name of the existing service account resource |
| auditor.serviceMonitor.enabled | bool | `false` | enable metrics collect with prometheus |
| auditor.serviceMonitor.interval | string | `"15s"` | custom interval to retrieve the metrics |
| auditor.serviceMonitor.namespace | string | `"monitoring"` | which namespace prometheus is located. by default monitoring |
| auditor.strategy.rollingUpdate.maxSurge | string | `"25%"` | The number of pods that can be created above the desired amount of pods during an update |
| auditor.strategy.rollingUpdate.maxUnavailable | string | `"25%"` | The number of pods that can be unavailable during the update process |
| auditor.strategy.type | string | `"RollingUpdate"` | New pods are added gradually, and old pods are terminated gradually, e.g: Recreate or RollingUpdate |
| auditor.tls.caRootCertForLedgerSecret | string | `""` | Name of the Secret containing the custom CA root certificate for TLS communication between Auditor and Ledger. |
| auditor.tls.caRootCertSecret | string | `""` | Name of the Secret containing the custom CA root certificate for TLS communication. |
| auditor.tls.caRootCertSecretForServiceMonitor | string | `""` | Name of the Secret containing the CA root certificate for TLS communication on the metrics endpoint. Prometheus Operator retrieves the CA root certificate file from this secret resource. You must create this secret resource in the same namespace as Prometheus. |
| auditor.tls.certChainSecret | string | `""` | Name of the Secret containing the certificate chain file used for TLS communication. |
| auditor.tls.certManager.dnsNames | list | `["localhost"]` | Subject Alternative Name (SAN) of a certificate. |
| auditor.tls.certManager.duration | string | `"8760h0m0s"` | Duration of a certificate. |
| auditor.tls.certManager.enabled | bool | `false` | Use cert-manager to manage private key and certificate files. |
| auditor.tls.certManager.issuerRef | object | `{}` | Issuer references of cert-manager. |
| auditor.tls.certManager.privateKey | object | `{"algorithm":"ECDSA","encoding":"PKCS1","size":256}` | Configuration of a private key. |
| auditor.tls.certManager.renewBefore | string | `"360h0m0s"` | How long before expiry a certificate should be renewed. |
| auditor.tls.certManager.selfSigned.caRootCert.duration | string | `"8760h0m0s"` | Duration of a self-signed CA certificate. |
| auditor.tls.certManager.selfSigned.caRootCert.renewBefore | string | `"360h0m0s"` | How long before expiry a self-signed CA certificate should be renewed. |
| auditor.tls.certManager.selfSigned.enabled | bool | `false` | Use self-signed CA. |
| auditor.tls.certManager.usages | list | `["server auth","key encipherment","signing"]` | List of key usages. |
| auditor.tls.enabled | bool | `false` | Enable TLS. You need to enable TLS when you use wire encryption feature of ScalarDL Auditor. |
| auditor.tls.overrideAuthority | string | `""` | The custom authority for TLS communication. This doesn't change what host is actually connected. This is intended for testing, but may safely be used outside of tests as an alternative to DNS overrides. For example, you can specify the hostname presented in the certificate chain file that you set by using `auditor.tls.certChainSecret`. This chart uses this value for startupProbe and livenessProbe. |
| auditor.tls.privateKeySecret | string | `""` | Name of the Secret containing the private key file used for TLS communication. |
| auditor.tolerations | list | `[]` | Tolerations are applied to pods, and allow (but do not require) the pods to schedule onto nodes with matching taints. |
| envoy.enabled | bool | `true` | enable envoy |
| envoy.envoyConfiguration.serviceListeners | string | `"scalardl-audit-service:40051,scalardl-audit-privileged:40052"` | list of service name and port |
| envoy.image.version | string | `"2.0.0-SNAPSHOT"` | Docker tag |
| envoy.nameOverride | string | `"scalardl-audit"` | String to partially override envoy.fullname template |
| envoy.service.annotations | object | `{}` | Service annotations, e.g: prometheus, etc. |
| envoy.service.ports.envoy-priv.port | int | `40052` | envoy public port |
| envoy.service.ports.envoy-priv.protocol | string | `"TCP"` | envoy protocol |
| envoy.service.ports.envoy-priv.targetPort | int | `40052` | envoy k8s internal name |
| envoy.service.ports.envoy.port | int | `40051` | envoy public port |
| envoy.service.ports.envoy.protocol | string | `"TCP"` | envoy protocol |
| envoy.service.ports.envoy.targetPort | int | `40051` | envoy k8s internal name |
| envoy.service.type | string | `"ClusterIP"` | service types in kubernetes |
| fullnameOverride | string | `""` | String to fully override scalardl-audit.fullname template |
| global.azure | object | `{"images":{"envoy":{"image":"scalar-envoy","registry":"scalar.azurecr.io","tag":"2.0.0-SNAPSHOT"},"scalardbCluster":{"image":"scalardl-auditor-azure-payg","registry":"scalar.azurecr.io","tag":"4.0.0-SNAPSHOT"}}}` | Azure Marketplace specific configurations. |
| global.azure.images.envoy | object | `{"image":"scalar-envoy","registry":"scalar.azurecr.io","tag":"2.0.0-SNAPSHOT"}` | Container image of Envoy for Azure Marketplace. |
| global.azure.images.scalardbCluster | object | `{"image":"scalardl-auditor-azure-payg","registry":"scalar.azurecr.io","tag":"4.0.0-SNAPSHOT"}` | Container image of ScalarDL Auditor for Azure Marketplace. |
| global.platform | string | `""` | Specify the platform that you use. This configuration is for internal use. |
| nameOverride | string | `""` | String to partially override scalardl-audit.fullname template (will maintain the release name) |
