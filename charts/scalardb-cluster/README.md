# scalardb-cluster

ScalarDB Cluster
Current chart version is `1.6.1`

## Requirements

| Repository | Name | Version |
|------------|------|---------|
| https://scalar-labs.github.io/helm-charts | envoy | ~2.6.0 |

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| envoy.enabled | bool | `false` | enable envoy |
| envoy.envoyConfiguration.serviceListeners | string | `"scalardb-cluster-service:60053"` | list of service name and port |
| envoy.image.version | string | `"1.6.1"` | Docker tag |
| envoy.nameOverride | string | `"scalardb-cluster"` | String to partially override envoy.fullname template |
| envoy.service.annotations | object | `{}` | Service annotations, e.g: prometheus, etc. |
| envoy.service.ports.envoy.port | int | `60053` | envoy public port |
| envoy.service.ports.envoy.protocol | string | `"TCP"` | envoy protocol |
| envoy.service.ports.envoy.targetPort | int | `60053` | envoy k8s internal name |
| envoy.service.type | string | `"ClusterIP"` | service types in kubernetes |
| fullnameOverride | string | `""` | String to fully override scalardb-cluster.fullname template |
| global.azure | object | `{"images":{"envoy":{"image":"scalar-envoy","registry":"scalar.azurecr.io","tag":"1.6.1"},"scalardbCluster":{"image":"scalardb-cluster-node-azure-payg-premium","registry":"scalar.azurecr.io","tag":"3.14.0"}}}` | Azure Marketplace specific configurations. |
| global.azure.images.envoy | object | `{"image":"scalar-envoy","registry":"scalar.azurecr.io","tag":"1.6.1"}` | Container image of Envoy for Azure Marketplace. |
| global.azure.images.scalardbCluster | object | `{"image":"scalardb-cluster-node-azure-payg-premium","registry":"scalar.azurecr.io","tag":"3.14.0"}` | Container image of ScalarDB Cluster for Azure Marketplace. |
| global.platform | string | `""` | Specify the platform that you use. This configuration is for internal use. |
| nameOverride | string | `""` | String to partially override scalardb-cluster.fullname template (will maintain the release name) |
| scalardbCluster.affinity | object | `{}` | The affinity/anti-affinity feature, greatly expands the types of constraints you can express. |
| scalardbCluster.encryption.enabled | bool | `false` | Enable encryption at rest. You must set this to `true` if you're using the encryption feature in ScalarDB Cluster. |
| scalardbCluster.encryption.type | string | `""` | Type of encryption. You must set this value to the same value as "scalar.db.cluster.encryption.type" for ScalarDB Cluster. |
| scalardbCluster.encryption.vault | object | `{"tls":{"caRootCertSecret":"","enabled":false}}` | Vault-specific configurations. |
| scalardbCluster.encryption.vault.tls | object | `{"caRootCertSecret":"","enabled":false}` | TLS configurations to provide access from ScalarDB Cluster to Vault by using TLS. If you're using HashiCorp Cloud Platform (HCP) Vault Dedicated, you don't need to set these TLS configurations because HCP Vault Dedicated uses a trusted, well-known CA and ScalarDB Cluster can validate the certificate that is provided by HCP Vault Dedicated. You need to set these TLS configurations only if you need to set a custom CA root certificate, for example, you're using your private CA together with HashiCorp Vault deployments other than HCP Vault Dedicated, like a self-hosted HashiCorp Vault. |
| scalardbCluster.encryption.vault.tls.caRootCertSecret | string | `""` | Name of the Secret containing the custom CA root certificate for TLS communication between ScalarDB Cluster and Vault. The certificate file will be mounted under the `/encryption/vault/tls/certs/` directory in the ScalarDB Cluster pod. |
| scalardbCluster.encryption.vault.tls.enabled | bool | `false` | Enable TLS between ScalarDB Cluster and Vault. Note that you must enable the TLS feature on the Vault side. |
| scalardbCluster.extraVolumeMounts | list | `[]` | Defines additional volume mounts. If you want to get a heap dump of the ScalarDB Cluster node, you need to mount a volume to make the dump file persistent. |
| scalardbCluster.extraVolumes | list | `[]` | Defines additional volumes. If you want to get a heap dump of the ScalarDB Cluster node, you need to mount a volume to make the dump file persistent. |
| scalardbCluster.grafanaDashboard.enabled | bool | `false` | Enable grafana dashboard. |
| scalardbCluster.grafanaDashboard.namespace | string | `"monitoring"` | Which namespace grafana dashboard is located. by default monitoring. |
| scalardbCluster.graphql.enabled | bool | `false` | enable graphql |
| scalardbCluster.graphql.service.annotations | object | `{}` | Service annotations, e.g: prometheus, etc. |
| scalardbCluster.graphql.service.ports.graphql.port | int | `8080` | graphql public port |
| scalardbCluster.graphql.service.ports.graphql.protocol | string | `"TCP"` | graphql protocol |
| scalardbCluster.graphql.service.ports.graphql.targetPort | int | `8080` | graphql k8s internal port |
| scalardbCluster.graphql.service.type | string | `"ClusterIP"` | service types in kubernetes |
| scalardbCluster.image.pullPolicy | string | `"IfNotPresent"` | Specify a image pulling policy. |
| scalardbCluster.image.repository | string | `"ghcr.io/scalar-labs/scalardb-cluster-node"` | Docker image reposiory of ScalarDB Cluster. |
| scalardbCluster.image.tag | string | `""` | Override the image tag whose default is the chart appVersion |
| scalardbCluster.imagePullSecrets | list | `[{"name":"reg-docker-secrets"}]` | Optionally specify an array of imagePullSecrets. Secrets must be manually created in the namespace. |
| scalardbCluster.logLevel | string | `"INFO"` | The log level of ScalarDB Cluster |
| scalardbCluster.nodeSelector | object | `{}` | nodeSelector is form of node selection constraint. |
| scalardbCluster.podAnnotations | object | `{}` | Pod annotations for the scalardb-cluster deployment |
| scalardbCluster.podSecurityContext | object | `{"seccompProfile":{"type":"RuntimeDefault"}}` | PodSecurityContext holds pod-level security attributes and common container settings. |
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
| scalardbCluster.serviceAccount.automountServiceAccountToken | bool | `true` | Specify to mount a service account token or not |
| scalardbCluster.serviceAccount.serviceAccountName | string | `""` | Name of the existing service account resource |
| scalardbCluster.serviceMonitor.enabled | bool | `false` | Enable metrics collect with prometheus. |
| scalardbCluster.serviceMonitor.interval | string | `"15s"` | Custom interval to retrieve the metrics. |
| scalardbCluster.serviceMonitor.namespace | string | `"monitoring"` | Which namespace prometheus is located. by default monitoring. |
| scalardbCluster.strategy.rollingUpdate.maxSurge | string | `"25%"` | The number of pods that can be created above the desired amount of pods during an update |
| scalardbCluster.strategy.rollingUpdate.maxUnavailable | string | `"25%"` | The number of pods that can be unavailable during the update process |
| scalardbCluster.strategy.type | string | `"RollingUpdate"` | New pods are added gradually, and old pods are terminated gradually, e.g: Recreate or RollingUpdate |
| scalardbCluster.tls.caRootCertSecret | string | `""` | Name of the Secret containing the custom CA root certificate for TLS communication. |
| scalardbCluster.tls.caRootCertSecretForServiceMonitor | string | `""` | Name of the Secret containing the CA root certificate for TLS communication on the metrics endpoint. Prometheus Operator retrieves the CA root certificate file from this secret resource. You must create this secret resource in the same namespace as Prometheus. |
| scalardbCluster.tls.certChainSecret | string | `""` | Name of the Secret containing the certificate chain file used for TLS communication. |
| scalardbCluster.tls.certManager.dnsNames | list | `["localhost"]` | Subject Alternative Name (SAN) of a certificate. |
| scalardbCluster.tls.certManager.duration | string | `"8760h0m0s"` | Duration of a certificate. |
| scalardbCluster.tls.certManager.enabled | bool | `false` | Use cert-manager to manage private key and certificate files. |
| scalardbCluster.tls.certManager.issuerRef | object | `{}` | Issuer references of cert-manager. |
| scalardbCluster.tls.certManager.privateKey | object | `{"algorithm":"ECDSA","encoding":"PKCS1","size":256}` | Configuration of a private key. |
| scalardbCluster.tls.certManager.renewBefore | string | `"360h0m0s"` | How long before expiry a certificate should be renewed. |
| scalardbCluster.tls.certManager.selfSigned | object | `{"caRootCert":{"duration":"8760h0m0s","renewBefore":"360h0m0s"},"enabled":false}` | Configuration of a certificate for self-signed CA. |
| scalardbCluster.tls.certManager.selfSigned.caRootCert.duration | string | `"8760h0m0s"` | Duration of a self-signed CA certificate. |
| scalardbCluster.tls.certManager.selfSigned.caRootCert.renewBefore | string | `"360h0m0s"` | How long before expiry a self-signed CA certificate should be renewed. |
| scalardbCluster.tls.certManager.selfSigned.enabled | bool | `false` | Use self-signed CA. |
| scalardbCluster.tls.certManager.usages | list | `["server auth","key encipherment","signing"]` | List of key usages. |
| scalardbCluster.tls.enabled | bool | `false` | Enable TLS. You need to enable TLS when you use wire encryption feature of ScalarDB Cluster. |
| scalardbCluster.tls.overrideAuthority | string | `""` | The custom authority for TLS communication. This doesn't change what host is actually connected. This is intended for testing, but may safely be used outside of tests as an alternative to DNS overrides. For example, you can specify the hostname presented in the certificate chain file that you set by using `scalardbCluster.tls.certChainSecret`. This chart uses this value for startupProbe and livenessProbe. |
| scalardbCluster.tls.privateKeySecret | string | `""` | Name of the Secret containing the private key file used for TLS communication. |
| scalardbCluster.tolerations | list | `[]` | Tolerations are applied to pods, and allow (but do not require) the pods to schedule onto nodes with matching taints. |
