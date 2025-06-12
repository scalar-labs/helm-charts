# scalardb-analytics-server

ScalarDB Analytics Server
Current chart version is `1.0.0-SNAPSHOT`

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| fullnameOverride | string | `""` | String to fully override scalardb-analytics-server.fullname template |
| nameOverride | string | `""` | String to partially override scalardb-analytics-server.fullname template (will maintain the release name) |
| scalardbAnalyticsServer.affinity | object | `{}` | The affinity/anti-affinity feature, greatly expands the types of constraints you can express. |
| scalardbAnalyticsServer.extraVolumeMounts | list | `[]` | Defines additional volume mounts. If you want to get a heap dump of the ScalarDB Analytics Server node, you need to mount a volume to make the dump file persistent. |
| scalardbAnalyticsServer.extraVolumes | list | `[]` | Defines additional volumes. If you want to get a heap dump of the ScalarDB Analytics Server node, you need to mount a volume to make the dump file persistent. |
| scalardbAnalyticsServer.image.pullPolicy | string | `"Never"` | Specify a image pulling policy. |
| scalardbAnalyticsServer.image.repository | string | `"local/scalardb-analytics-server"` | Docker image repository of ScalarDB Analytics Server. |
| scalardbAnalyticsServer.image.tag | string | `""` | Override the image tag whose default is the chart appVersion |
| scalardbAnalyticsServer.imagePullSecrets | list | `[]` | Optionally specify an array of imagePullSecrets. Secrets must be manually created in the namespace. |
| scalardbAnalyticsServer.nodeSelector | object | `{}` | nodeSelector is form of node selection constraint. |
| scalardbAnalyticsServer.podAnnotations | object | `{}` | Pod annotations for the scalardb-analytics-server deployment |
| scalardbAnalyticsServer.podSecurityContext | object | `{"seccompProfile":{"type":"RuntimeDefault"}}` | PodSecurityContext holds pod-level security attributes and common container settings. |
| scalardbAnalyticsServer.properties | object | The minimum template of database.properties is set by default. | The database.properties is created based on the values of scalardb-analytics-server.storageConfiguration by default. If you want to customize database.properties, you can override this value with your database.properties. |
| scalardbAnalyticsServer.replicaCount | int | `1` | Default values for number of replicas. |
| scalardbAnalyticsServer.resources | object | `{}` | Resources allowed to the pod. |
| scalardbAnalyticsServer.secretNames | list | `[]` | Secret name that includes sensitive data such as credentials. Each secret key is passed to Pod as environment variables using envFrom. |
| scalardbAnalyticsServer.securityContext | object | `{"allowPrivilegeEscalation":false,"capabilities":{"drop":["ALL"]},"runAsNonRoot":true}` | Setting security context at the pod applies those settings to all containers in the pod. |
| scalardbAnalyticsServer.securityContext.allowPrivilegeEscalation | bool | `false` | AllowPrivilegeEscalation controls whether a process can gain more privileges than its parent process |
| scalardbAnalyticsServer.securityContext.capabilities | object | `{"drop":["ALL"]}` | Capabilities (specifically, Linux capabilities), are used for permission management in Linux. Some capabilities are enabled by default |
| scalardbAnalyticsServer.securityContext.runAsNonRoot | bool | `true` | Containers should be run as a non-root user with the minimum required permissions (principle of least privilege) |
| scalardbAnalyticsServer.service.ports.scalardb-analytics-server-report.port | int | `11052` | ScalarDB Analytics Server port. |
| scalardbAnalyticsServer.service.ports.scalardb-analytics-server-report.protocol | string | `"TCP"` | ScalarDB Analytics Server protocol. |
| scalardbAnalyticsServer.service.ports.scalardb-analytics-server-report.targetPort | int | `11052` | ScalarDB Analytics Server target port. |
| scalardbAnalyticsServer.service.ports.scalardb-analytics-server.port | int | `50051` | ScalarDB Analytics Server port. |
| scalardbAnalyticsServer.service.ports.scalardb-analytics-server.protocol | string | `"TCP"` | ScalarDB Analytics Server protocol. |
| scalardbAnalyticsServer.service.ports.scalardb-analytics-server.targetPort | int | `50051` | ScalarDB Analytics Server target port. |
| scalardbAnalyticsServer.service.type | string | `"ClusterIP"` | service types in kubernetes. |
| scalardbAnalyticsServer.serviceAccount.automountToken | bool | `true` | Specify to mount a service account token or not |
| scalardbAnalyticsServer.serviceAccount.name | string | `""` | Name of the existing service account resource |
| scalardbAnalyticsServer.strategy.rollingUpdate.maxSurge | string | `"25%"` | The number of pods that can be created above the desired amount of pods during an update |
| scalardbAnalyticsServer.strategy.rollingUpdate.maxUnavailable | string | `"25%"` | The number of pods that can be unavailable during the update process |
| scalardbAnalyticsServer.strategy.type | string | `"RollingUpdate"` | New pods are added gradually, and old pods are terminated gradually, e.g: Recreate or RollingUpdate |
| scalardbAnalyticsServer.tls.caRootCertSecret | string | `""` | Name of the Secret containing the custom CA root certificate for TLS communication. |
| scalardbAnalyticsServer.tls.caRootCertSecretForServiceMonitor | string | `""` | Name of the Secret containing the CA root certificate for TLS communication on the metrics endpoint. Prometheus Operator retrieves the CA root certificate file from this secret resource. You must create this secret resource in the same namespace as Prometheus. |
| scalardbAnalyticsServer.tls.certChainSecret | string | `""` | Name of the Secret containing the certificate chain file used for TLS communication. |
| scalardbAnalyticsServer.tls.certManager.dnsNames | list | `["localhost"]` | Subject Alternative Name (SAN) of a certificate. |
| scalardbAnalyticsServer.tls.certManager.duration | string | `"8760h0m0s"` | Duration of a certificate. |
| scalardbAnalyticsServer.tls.certManager.enabled | bool | `false` | Use cert-manager to manage private key and certificate files. |
| scalardbAnalyticsServer.tls.certManager.issuerRef | object | `{}` | Issuer references of cert-manager. |
| scalardbAnalyticsServer.tls.certManager.privateKey | object | `{"algorithm":"ECDSA","encoding":"PKCS1","size":256}` | Configuration of a private key. |
| scalardbAnalyticsServer.tls.certManager.renewBefore | string | `"360h0m0s"` | How long before expiry a certificate should be renewed. |
| scalardbAnalyticsServer.tls.certManager.selfSigned | object | `{"caRootCert":{"duration":"8760h0m0s","renewBefore":"360h0m0s"},"enabled":false}` | Configuration of a certificate for self-signed CA. |
| scalardbAnalyticsServer.tls.certManager.selfSigned.caRootCert.duration | string | `"8760h0m0s"` | Duration of a self-signed CA certificate. |
| scalardbAnalyticsServer.tls.certManager.selfSigned.caRootCert.renewBefore | string | `"360h0m0s"` | How long before expiry a self-signed CA certificate should be renewed. |
| scalardbAnalyticsServer.tls.certManager.selfSigned.enabled | bool | `false` | Use self-signed CA. |
| scalardbAnalyticsServer.tls.certManager.usages | list | `["server auth","key encipherment","signing"]` | List of key usages. |
| scalardbAnalyticsServer.tls.enabled | bool | `false` | Enable TLS. You need to enable TLS when you use wire encryption feature of ScalarDB Analytics Server. |
| scalardbAnalyticsServer.tls.overrideAuthority | string | `""` | The custom authority for TLS communication. This doesn't change what host is actually connected. This is intended for testing, but may safely be used outside of tests as an alternative to DNS overrides. For example, you can specify the hostname presented in the certificate chain file that you set by using `scalardbAnalyticsServer.tls.certChainSecret`. This chart uses this value for startupProbe and livenessProbe. |
| scalardbAnalyticsServer.tls.privateKeySecret | string | `""` | Name of the Secret containing the private key file used for TLS communication. |
| scalardbAnalyticsServer.tolerations | list | `[]` | Tolerations are applied to pods, and allow (but do not require) the pods to schedule onto nodes with matching taints. |
