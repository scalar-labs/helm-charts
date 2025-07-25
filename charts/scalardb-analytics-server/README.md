# scalardb-analytics-server

ScalarDB Analytics Server
Current chart version is `1.0.0`

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| fullnameOverride | string | `""` | String to fully override scalardb-analytics-server.fullname template |
| nameOverride | string | `""` | String to partially override scalardb-analytics-server.fullname template (will maintain the release name) |
| scalarDbAnalyticsServer.affinity | object | `{}` | The affinity/anti-affinity feature, greatly expands the types of constraints you can express. |
| scalarDbAnalyticsServer.extraVolumeMounts | list | `[]` | Defines additional volume mounts. If you want to get a heap dump of the ScalarDB Analytics Server, you need to mount a volume to make the dump file persistent. |
| scalarDbAnalyticsServer.extraVolumes | list | `[]` | Defines additional volumes. If you want to get a heap dump of the ScalarDB Analytics Server, you need to mount a volume to make the dump file persistent. |
| scalarDbAnalyticsServer.image.pullPolicy | string | `"IfNotPresent"` | Specify a image pulling policy. |
| scalarDbAnalyticsServer.image.repository | string | `"ghcr.io/scalar-labs/scalardb-analytics-server-byol"` | Docker image repository of ScalarDB Analytics Server. |
| scalarDbAnalyticsServer.image.tag | string | `""` | Override the image tag whose default is the chart appVersion |
| scalarDbAnalyticsServer.imagePullSecrets | list | `[]` | Optionally specify an array of imagePullSecrets. Secrets must be manually created in the namespace. |
| scalarDbAnalyticsServer.nodeSelector | object | `{}` | nodeSelector is form of node selection constraint. |
| scalarDbAnalyticsServer.podAnnotations | object | `{}` | Pod annotations for the scalardb-analytics-server deployment |
| scalarDbAnalyticsServer.podSecurityContext | object | `{"seccompProfile":{"type":"RuntimeDefault"}}` | PodSecurityContext holds pod-level security attributes and common container settings. |
| scalarDbAnalyticsServer.properties | string | You can specify your server.properties. | You can specify your server.properties. |
| scalarDbAnalyticsServer.replicaCount | int | `1` | Default values for number of replicas. |
| scalarDbAnalyticsServer.resources | object | `{}` | Resources allowed to the pod. |
| scalarDbAnalyticsServer.secretName | string | `""` | Secret name that includes sensitive data such as credentials. Each secret key is passed to Pod as environment variables using envFrom. |
| scalarDbAnalyticsServer.securityContext | object | `{"allowPrivilegeEscalation":false,"capabilities":{"drop":["ALL"]},"runAsNonRoot":true}` | Setting security context at the pod applies those settings to all containers in the pod. |
| scalarDbAnalyticsServer.securityContext.allowPrivilegeEscalation | bool | `false` | AllowPrivilegeEscalation controls whether a process can gain more privileges than its parent process |
| scalarDbAnalyticsServer.securityContext.capabilities | object | `{"drop":["ALL"]}` | Capabilities (specifically, Linux capabilities), are used for permission management in Linux. Some capabilities are enabled by default |
| scalarDbAnalyticsServer.securityContext.runAsNonRoot | bool | `true` | Containers should be run as a non-root user with the minimum required permissions (principle of least privilege) |
| scalarDbAnalyticsServer.service.annotations | object | `{}` |  |
| scalarDbAnalyticsServer.service.ports.scalardb-analytics-server-catalog.port | int | `11051` | ScalarDB Analytics Server catalog port. |
| scalarDbAnalyticsServer.service.ports.scalardb-analytics-server-catalog.protocol | string | `"TCP"` | ScalarDB Analytics Server catalog protocol. |
| scalarDbAnalyticsServer.service.ports.scalardb-analytics-server-catalog.targetPort | int | `11051` | ScalarDB Analytics Server catalog target port. |
| scalarDbAnalyticsServer.service.ports.scalardb-analytics-server-metering.port | int | `11052` | ScalarDB Analytics Server metering port. |
| scalarDbAnalyticsServer.service.ports.scalardb-analytics-server-metering.protocol | string | `"TCP"` | ScalarDB Analytics Server metering protocol. |
| scalarDbAnalyticsServer.service.ports.scalardb-analytics-server-metering.targetPort | int | `11052` | ScalarDB Analytics Server metering target port. |
| scalarDbAnalyticsServer.service.type | string | `"ClusterIP"` | service types in kubernetes. |
| scalarDbAnalyticsServer.serviceAccount.automountServiceAccountToken | bool | `true` | Specify to mount a service account token or not |
| scalarDbAnalyticsServer.serviceAccount.serviceAccountName | string | `""` | Name of the existing service account resource |
| scalarDbAnalyticsServer.strategy.rollingUpdate.maxSurge | string | `"25%"` | The number of pods that can be created above the desired amount of pods during an update |
| scalarDbAnalyticsServer.strategy.rollingUpdate.maxUnavailable | string | `"25%"` | The number of pods that can be unavailable during the update process |
| scalarDbAnalyticsServer.strategy.type | string | `"RollingUpdate"` | New pods are added gradually, and old pods are terminated gradually, e.g: Recreate or RollingUpdate |
| scalarDbAnalyticsServer.tls.caRootCertSecret | string | `""` | Name of the Secret containing the custom CA root certificate for TLS communication. |
| scalarDbAnalyticsServer.tls.certChainSecret | string | `""` | Name of the Secret containing the certificate chain file used for TLS communication. |
| scalarDbAnalyticsServer.tls.certManager.dnsNames | list | `["localhost"]` | Subject Alternative Name (SAN) of a certificate. |
| scalarDbAnalyticsServer.tls.certManager.duration | string | `"8760h0m0s"` | Duration of a certificate. |
| scalarDbAnalyticsServer.tls.certManager.enabled | bool | `false` | Use cert-manager to manage private key and certificate files. |
| scalarDbAnalyticsServer.tls.certManager.issuerRef | object | `{}` | Issuer references of cert-manager. |
| scalarDbAnalyticsServer.tls.certManager.privateKey | object | `{"algorithm":"ECDSA","encoding":"PKCS8","size":256}` | Configuration of a private key. |
| scalarDbAnalyticsServer.tls.certManager.renewBefore | string | `"360h0m0s"` | How long before expiry a certificate should be renewed. |
| scalarDbAnalyticsServer.tls.certManager.selfSigned | object | `{"caRootCert":{"duration":"8760h0m0s","renewBefore":"360h0m0s"},"enabled":false}` | Configuration of a certificate for self-signed CA. |
| scalarDbAnalyticsServer.tls.certManager.selfSigned.caRootCert.duration | string | `"8760h0m0s"` | Duration of a self-signed CA certificate. |
| scalarDbAnalyticsServer.tls.certManager.selfSigned.caRootCert.renewBefore | string | `"360h0m0s"` | How long before expiry a self-signed CA certificate should be renewed. |
| scalarDbAnalyticsServer.tls.certManager.selfSigned.enabled | bool | `false` | Use self-signed CA. |
| scalarDbAnalyticsServer.tls.certManager.usages | list | `["server auth","key encipherment","signing"]` | List of key usages. |
| scalarDbAnalyticsServer.tls.enabled | bool | `false` | Enable TLS. You need to enable TLS when you use wire encryption feature of ScalarDB Analytics Server. |
| scalarDbAnalyticsServer.tls.overrideAuthority | string | `""` | The custom authority for TLS communication. This doesn't change what host is actually connected. This is intended for testing, but may safely be used outside of tests as an alternative to DNS overrides. For example, you can specify the hostname presented in the certificate chain file that you set by using `scalarDbAnalyticsServer.tls.certChainSecret`. This chart uses this value for startupProbe and livenessProbe. |
| scalarDbAnalyticsServer.tls.privateKeySecret | string | `""` | Name of the Secret containing the private key file used for TLS communication. |
| scalarDbAnalyticsServer.tolerations | list | `[]` | Tolerations are applied to pods, and allow (but do not require) the pods to schedule onto nodes with matching taints. |
