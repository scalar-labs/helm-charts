# scalardb-analytics

ScalarDB Analytics
Current chart version is `1.0.0-SNAPSHOT`

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| fullnameOverride | string | `""` | String to fully override scalardb-analytics.fullname template |
| nameOverride | string | `""` | String to partially override scalardb-analytics.fullname template (will maintain the release name) |
| scalardbAnalytics.affinity | object | `{}` | The affinity/anti-affinity feature, greatly expands the types of constraints you can express. |
| scalardbAnalytics.extraVolumeMounts | list | `[]` | Defines additional volume mounts. If you want to get a heap dump of the ScalarDB Analytics node, you need to mount a volume to make the dump file persistent. |
| scalardbAnalytics.extraVolumes | list | `[]` | Defines additional volumes. If you want to get a heap dump of the ScalarDB Analytics node, you need to mount a volume to make the dump file persistent. |
| scalardbAnalytics.image.pullPolicy | string | `"IfNotPresent"` | Specify a image pulling policy. |
| scalardbAnalytics.image.repository | string | `"ghcr.io/scalar-labs/scalardb-analytics-server"` | Docker image reposiory of ScalarDB Analytics. |
| scalardbAnalytics.image.tag | string | `""` | Override the image tag whose default is the chart appVersion |
| scalardbAnalytics.imagePullSecrets | list | `[]` | Optionally specify an array of imagePullSecrets. Secrets must be manually created in the namespace. |
| scalardbAnalytics.nodeSelector | object | `{}` | nodeSelector is form of node selection constraint. |
| scalardbAnalytics.podAnnotations | object | `{}` | Pod annotations for the scalardb-analytics deployment |
| scalardbAnalytics.podSecurityContext | object | `{"seccompProfile":{"type":"RuntimeDefault"}}` | PodSecurityContext holds pod-level security attributes and common container settings. |
| scalardbAnalytics.replicaCount | int | `1` | Default values for number of replicas. |
| scalardbAnalytics.resources | object | `{}` | Resources allowed to the pod. |
| scalardbAnalytics.scalardbAnalyticsProperties | object | The minimum template of database.properties is set by default. | The database.properties is created based on the values of scalardb-analytics.storageConfiguration by default. If you want to customize database.properties, you can override this value with your database.properties. |
| scalardbAnalytics.secretNames | list | `[]` | Secret name that includes sensitive data such as credentials. Each secret key is passed to Pod as environment variables using envFrom. |
| scalardbAnalytics.securityContext | object | `{"allowPrivilegeEscalation":false,"capabilities":{"drop":["ALL"]},"runAsNonRoot":true}` | Setting security context at the pod applies those settings to all containers in the pod. |
| scalardbAnalytics.securityContext.allowPrivilegeEscalation | bool | `false` | AllowPrivilegeEscalation controls whether a process can gain more privileges than its parent process |
| scalardbAnalytics.securityContext.capabilities | object | `{"drop":["ALL"]}` | Capabilities (specifically, Linux capabilities), are used for permission management in Linux. Some capabilities are enabled by default |
| scalardbAnalytics.securityContext.runAsNonRoot | bool | `true` | Containers should be run as a non-root user with the minimum required permissions (principle of least privilege) |
| scalardbAnalytics.service.ports.scalardb-analytics-catalog.port | int | `11051` | ScalarDB Analytics port. |
| scalardbAnalytics.service.ports.scalardb-analytics-catalog.protocol | string | `"TCP"` | ScalarDB Analytics protocol. |
| scalardbAnalytics.service.ports.scalardb-analytics-catalog.targetPort | int | `11051` | ScalarDB Analytics target port. |
| scalardbAnalytics.service.ports.scalardb-analytics-usage.port | int | `11052` | ScalarDB Analytics port. |
| scalardbAnalytics.service.ports.scalardb-analytics-usage.protocol | string | `"TCP"` | ScalarDB Analytics protocol. |
| scalardbAnalytics.service.ports.scalardb-analytics-usage.targetPort | int | `11052` | ScalarDB Analytics target port. |
| scalardbAnalytics.service.type | string | `"ClusterIP"` | service types in kubernetes. |
| scalardbAnalytics.serviceAccount.automountToken | bool | `true` | Specify to mount a service account token or not |
| scalardbAnalytics.serviceAccount.name | string | `""` | Name of the existing service account resource |
| scalardbAnalytics.strategy.rollingUpdate.maxSurge | string | `"25%"` | The number of pods that can be created above the desired amount of pods during an update |
| scalardbAnalytics.strategy.rollingUpdate.maxUnavailable | string | `"25%"` | The number of pods that can be unavailable during the update process |
| scalardbAnalytics.strategy.type | string | `"RollingUpdate"` | New pods are added gradually, and old pods are terminated gradually, e.g: Recreate or RollingUpdate |
| scalardbAnalytics.tls.caRootCertSecret | string | `""` | Name of the Secret containing the custom CA root certificate for TLS communication. |
| scalardbAnalytics.tls.caRootCertSecretForServiceMonitor | string | `""` | Name of the Secret containing the CA root certificate for TLS communication on the metrics endpoint. Prometheus Operator retrieves the CA root certificate file from this secret resource. You must create this secret resource in the same namespace as Prometheus. |
| scalardbAnalytics.tls.certChainSecret | string | `""` | Name of the Secret containing the certificate chain file used for TLS communication. |
| scalardbAnalytics.tls.certManager.dnsNames | list | `["localhost"]` | Subject Alternative Name (SAN) of a certificate. |
| scalardbAnalytics.tls.certManager.duration | string | `"8760h0m0s"` | Duration of a certificate. |
| scalardbAnalytics.tls.certManager.enabled | bool | `false` | Use cert-manager to manage private key and certificate files. |
| scalardbAnalytics.tls.certManager.issuerRef | object | `{}` | Issuer references of cert-manager. |
| scalardbAnalytics.tls.certManager.privateKey | object | `{"algorithm":"ECDSA","encoding":"PKCS1","size":256}` | Configuration of a private key. |
| scalardbAnalytics.tls.certManager.renewBefore | string | `"360h0m0s"` | How long before expiry a certificate should be renewed. |
| scalardbAnalytics.tls.certManager.selfSigned | object | `{"caRootCert":{"duration":"8760h0m0s","renewBefore":"360h0m0s"},"enabled":false}` | Configuration of a certificate for self-signed CA. |
| scalardbAnalytics.tls.certManager.selfSigned.caRootCert.duration | string | `"8760h0m0s"` | Duration of a self-signed CA certificate. |
| scalardbAnalytics.tls.certManager.selfSigned.caRootCert.renewBefore | string | `"360h0m0s"` | How long before expiry a self-signed CA certificate should be renewed. |
| scalardbAnalytics.tls.certManager.selfSigned.enabled | bool | `false` | Use self-signed CA. |
| scalardbAnalytics.tls.certManager.usages | list | `["server auth","key encipherment","signing"]` | List of key usages. |
| scalardbAnalytics.tls.enabled | bool | `false` | Enable TLS. You need to enable TLS when you use wire encryption feature of ScalarDB Analytics. |
| scalardbAnalytics.tls.overrideAuthority | string | `""` | The custom authority for TLS communication. This doesn't change what host is actually connected. This is intended for testing, but may safely be used outside of tests as an alternative to DNS overrides. For example, you can specify the hostname presented in the certificate chain file that you set by using `scalardbAnalytics.tls.certChainSecret`. This chart uses this value for startupProbe and livenessProbe. |
| scalardbAnalytics.tls.privateKeySecret | string | `""` | Name of the Secret containing the private key file used for TLS communication. |
| scalardbAnalytics.tolerations | list | `[]` | Tolerations are applied to pods, and allow (but do not require) the pods to schedule onto nodes with matching taints. |
