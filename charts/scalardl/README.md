# scalardl

ScalarDL is a tamper-evident and scalable distributed database.
Current chart version is `4.8.3`

## Requirements

| Repository | Name | Version |
|------------|------|---------|
| https://scalar-labs.github.io/helm-charts | envoy | ~2.5.0 |

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| envoy.enabled | bool | `true` | enable envoy |
| envoy.envoyConfiguration.serviceListeners | string | `"scalardl-service:50051,scalardl-privileged:50052"` | list of service name and port |
| envoy.image.version | string | `"1.6.0"` | Docker tag |
| envoy.nameOverride | string | `"scalardl"` | String to partially override envoy.fullname template |
| envoy.service.annotations | object | `{}` | Service annotations, e.g: prometheus, etc. |
| envoy.service.ports.envoy-priv.port | int | `50052` | nvoy public port |
| envoy.service.ports.envoy-priv.protocol | string | `"TCP"` | envoy protocol |
| envoy.service.ports.envoy-priv.targetPort | int | `50052` | envoy k8s internal name |
| envoy.service.ports.envoy.port | int | `50051` | envoy public port |
| envoy.service.ports.envoy.protocol | string | `"TCP"` | envoy protocol |
| envoy.service.ports.envoy.targetPort | int | `50051` | envoy k8s internal name |
| envoy.service.type | string | `"ClusterIP"` | service types in kubernetes |
| fullnameOverride | string | `""` | String to fully override scalardl.fullname template |
| ledger.affinity | object | `{}` | the affinity/anti-affinity feature, greatly expands the types of constraints you can express |
| ledger.existingSecret | string | `""` | Name of existing secret to use for storing database username and password |
| ledger.extraVolumeMounts | list | `[]` | Defines additional volume mounts. |
| ledger.extraVolumes | list | `[]` | Defines additional volumes. |
| ledger.grafanaDashboard.enabled | bool | `false` | enable grafana dashboard |
| ledger.grafanaDashboard.namespace | string | `"monitoring"` | which namespace grafana dashboard is located. by default monitoring |
| ledger.image.pullPolicy | string | `"IfNotPresent"` | Specify a imagePullPolicy |
| ledger.image.repository | string | `"ghcr.io/scalar-labs/scalar-ledger"` | Docker image |
| ledger.image.version | string | `"3.9.4"` | Docker tag |
| ledger.imagePullSecrets | list | `[{"name":"reg-docker-secrets"}]` | Optionally specify an array of imagePullSecrets. Secrets must be manually created in the namespace. |
| ledger.ledgerProperties | string | The default minimum necessary values of ledger.properties are set. You can overwrite it with your own ledger.properties. | The ledger.properties is created based on the values of ledger.scalarLedgerConfiguration by default. If you want to customize ledger.properties, you can override this value with your ledger.properties. |
| ledger.nodeSelector | object | `{}` | nodeSelector is form of node selection constraint |
| ledger.podSecurityContext | object | `{"seccompProfile":{"type":"RuntimeDefault"}}` | PodSecurityContext holds pod-level security attributes and common container settings |
| ledger.prometheusRule.enabled | bool | `false` | enable rules for prometheus |
| ledger.prometheusRule.namespace | string | `"monitoring"` | which namespace prometheus is located. by default monitoring |
| ledger.replicaCount | int | `3` | number of replicas to deploy |
| ledger.resources | object | `{}` | resources allowed to the pod |
| ledger.scalarLedgerConfiguration.dbContactPoints | string | `"cassandra"` | The contact points of the database such as hostnames or URLs |
| ledger.scalarLedgerConfiguration.dbContactPort | int | `9042` | The port number of the contact points |
| ledger.scalarLedgerConfiguration.dbPassword | string | `"cassandra"` | The password of the database |
| ledger.scalarLedgerConfiguration.dbStorage | string | `"cassandra"` | The storage of the database: cassandra or cosmos |
| ledger.scalarLedgerConfiguration.dbUsername | string | `"cassandra"` | The username of the database |
| ledger.scalarLedgerConfiguration.ledgerAuditorEnabled | bool | `false` | Whether or not Auditor is enabled |
| ledger.scalarLedgerConfiguration.ledgerLogLevel | string | `"INFO"` | The log level of Scalar ledger |
| ledger.scalarLedgerConfiguration.ledgerPrivateKeySecretKey | string | `"private-key"` | The secret key of a Ledger private key |
| ledger.scalarLedgerConfiguration.ledgerProofEnabled | bool | `false` | Whether or not Asset Proof is enabled |
| ledger.scalarLedgerConfiguration.secretName | string | `"ledger-keys"` | The name of a Ledger secret |
| ledger.secretName | string | `""` | Secret name that includes sensitive data such as credentials. Each secret key is passed to Pod as environment variables using envFrom. |
| ledger.securityContext | object | `{"allowPrivilegeEscalation":false,"capabilities":{"drop":["ALL"]},"runAsNonRoot":true}` | Setting security context at the pod applies those settings to all containers in the pod |
| ledger.service.annotations | object | `{}` | Service annotations |
| ledger.service.ports.scalardl-admin.port | int | `50053` | scalardl-admin target port |
| ledger.service.ports.scalardl-admin.protocol | string | `"TCP"` | scalardl-admin protocol |
| ledger.service.ports.scalardl-admin.targetPort | int | `50053` | scalardl-admin k8s internal name |
| ledger.service.ports.scalardl-priv.port | int | `50052` | scalardl-priv target port |
| ledger.service.ports.scalardl-priv.protocol | string | `"TCP"` | scalardl-priv protocol |
| ledger.service.ports.scalardl-priv.targetPort | int | `50052` | scalardl-priv k8s internal name |
| ledger.service.ports.scalardl.port | int | `50051` | scalardl target port |
| ledger.service.ports.scalardl.protocol | string | `"TCP"` | scalardl protocol |
| ledger.service.ports.scalardl.targetPort | int | `50051` | scalardl k8s internal name |
| ledger.service.type | string | `"ClusterIP"` | service types in kubernetes |
| ledger.serviceAccount.automountServiceAccountToken | bool | `false` | Specify to mount a service account token or not |
| ledger.serviceAccount.serviceAccountName | string | `""` | Name of the existing service account resource |
| ledger.serviceMonitor.enabled | bool | `false` | enable metrics collect with prometheus |
| ledger.serviceMonitor.interval | string | `"15s"` | custom interval to retrieve the metrics |
| ledger.serviceMonitor.namespace | string | `"monitoring"` | which namespace prometheus is located. by default monitoring |
| ledger.strategy.rollingUpdate.maxSurge | string | `"25%"` | The number of pods that can be created above the desired amount of pods during an update |
| ledger.strategy.rollingUpdate.maxUnavailable | string | `"25%"` | The number of pods that can be unavailable during the update process |
| ledger.strategy.type | string | `"RollingUpdate"` | New pods are added gradually, and old pods are terminated gradually, e.g: Recreate or RollingUpdate |
| ledger.tls.caRootCertSecret | string | `""` | Name of the Secret containing the custom CA root certificate for TLS communication. |
| ledger.tls.caRootCertSecretForServiceMonitor | string | `""` | Name of the Secret containing the CA root certificate for TLS communication on the metrics endpoint. Prometheus Operator retrieves the CA root certificate file from this secret resource. You must create this secret resource in the same namespace as Prometheus. |
| ledger.tls.certChainSecret | string | `""` | Name of the Secret containing the certificate chain file used for TLS communication. |
| ledger.tls.certManager.dnsNames | list | `["localhost"]` | Subject Alternative Name (SAN) of a certificate. |
| ledger.tls.certManager.duration | string | `"8760h0m0s"` | Duration of a certificate. |
| ledger.tls.certManager.enabled | bool | `false` | Use cert-manager to manage private key and certificate files. |
| ledger.tls.certManager.issuerRef | object | `{}` | Issuer references of cert-manager. |
| ledger.tls.certManager.privateKey | object | `{"algorithm":"ECDSA","encoding":"PKCS1","size":256}` | Configuration of a private key. |
| ledger.tls.certManager.renewBefore | string | `"360h0m0s"` | How long before expiry a certificate should be renewed. |
| ledger.tls.certManager.selfSigned.caRootCert.duration | string | `"8760h0m0s"` | Duration of a self-signed CA certificate. |
| ledger.tls.certManager.selfSigned.caRootCert.renewBefore | string | `"360h0m0s"` | How long before expiry a self-signed CA certificate should be renewed. |
| ledger.tls.certManager.selfSigned.enabled | bool | `false` | Use self-signed CA. |
| ledger.tls.certManager.usages | list | `["server auth","key encipherment","signing"]` | List of key usages. |
| ledger.tls.enabled | bool | `false` | Enable TLS. You need to enable TLS when you use wire encryption feature of ScalarDL Ledger. |
| ledger.tls.overrideAuthority | string | `""` | The custom authority for TLS communication. This doesn't change what host is actually connected. This is intended for testing, but may safely be used outside of tests as an alternative to DNS overrides. For example, you can specify the hostname presented in the certificate chain file that you set by using `ledger.tls.certChainSecret`. This chart uses this value for startupProbe and livenessProbe. |
| ledger.tls.privateKeySecret | string | `""` | Name of the Secret containing the private key file used for TLS communication. |
| ledger.tolerations | list | `[]` | Tolerations are applied to pods, and allow (but do not require) the pods to schedule onto nodes with matching taints. |
| nameOverride | string | `""` | String to partially override scalardl.fullname template (will maintain the release name) |
