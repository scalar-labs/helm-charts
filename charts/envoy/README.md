# envoy

![Version: 2.6.0](https://img.shields.io/badge/Version-2.6.0-informational?style=flat-square)  ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square)  ![AppVersion: 1.6.1](https://img.shields.io/badge/AppVersion-1.6.1-informational?style=flat-square)

Envoy Proxy for Scalar applications
Current chart version is `2.6.0`

**Homepage:** <https://scalar-labs.com/>

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| affinity | object | `{}` | the affinity/anti-affinity feature, greatly expands the types of constraints you can express |
| envoyConfiguration.adminAccessLogPath | string | `"/dev/stdout"` | admin log path |
| envoyConfiguration.serviceListeners | string | `"scalar-service:50051,scalar-privileged:50052"` | list of service name and port |
| global.platform | string | `""` | Specify the platform that you use. This configuration is for internal use. |
| grafanaDashboard.enabled | bool | `false` | enable grafana dashboard |
| grafanaDashboard.namespace | string | `"monitoring"` | which namespace grafana dashboard is located. by default monitoring |
| image.pullPolicy | string | `"IfNotPresent"` | Specify a imagePullPolicy |
| image.repository | string | `"ghcr.io/scalar-labs/scalar-envoy"` | Docker image |
| image.version | string | `"1.6.1"` |  |
| imagePullSecrets | list | `[]` | Optionally specify an array of imagePullSecrets. Secrets must be manually created in the namespace. |
| nodeSelector | object | `{}` | nodeSelector is form of node selection constraint |
| podAnnotations | object | `{}` | Pod annotations for the envoy Deployment |
| podSecurityContext | object | `{"seccompProfile":{"type":"RuntimeDefault"}}` | PodSecurityContext holds pod-level security attributes and common container settings |
| podSecurityPolicy.enabled | bool | `false` | enable pod security policy |
| prometheusRule.enabled | bool | `false` | enable rules for prometheus |
| prometheusRule.namespace | string | `"monitoring"` | which namespace prometheus is located. by default monitoring |
| rbac.create | bool | `true` | If true, create and use RBAC resources |
| rbac.serviceAccountAnnotations | object | `{}` | Annotations for the Service Account |
| replicaCount | int | `3` | number of replicas to deploy |
| resources | object | `{}` | resources allowed to the pod |
| securityContext | object | `{"allowPrivilegeEscalation":false,"capabilities":{"drop":["ALL"]},"runAsNonRoot":true}` | Setting security context at the pod applies those settings to all containers in the pod |
| securityContext.allowPrivilegeEscalation | bool | `false` | AllowPrivilegeEscalation controls whether a process can gain more privileges than its parent process |
| securityContext.capabilities | object | `{"drop":["ALL"]}` | Capabilities (specifically, Linux capabilities), are used for permission management in Linux. Some capabilities are enabled by default |
| securityContext.runAsNonRoot | bool | `true` | Containers should be run as a non-root user with the minimum required permissions (principle of least privilege) |
| service.annotations | object | `{}` | Service annotations, e.g: prometheus, etc. |
| service.ports.envoy.port | int | `50051` | envoy public port |
| service.ports.envoy.protocol | string | `"TCP"` | envoy protocol |
| service.ports.envoy.targetPort | int | `50051` | envoy k8s internal name |
| service.type | string | `"ClusterIP"` | service types in kubernetes |
| serviceMonitor.enabled | bool | `false` | enable metrics collect with prometheus |
| serviceMonitor.interval | string | `"15s"` | custom interval to retrieve the metrics |
| serviceMonitor.namespace | string | `"monitoring"` | which namespace prometheus is located. by default monitoring |
| strategy.rollingUpdate | object | `{"maxSurge":"25%","maxUnavailable":"25%"}` | The number of pods that can be unavailable during the update process |
| strategy.type | string | `"RollingUpdate"` | New pods are added gradually, and old pods are terminated gradually, e.g: Recreate or RollingUpdate |
| tls.downstream | object | `{"certChainSecret":"","certManager":{"dnsNames":["localhost"],"duration":"8760h0m0s","enabled":false,"issuerRef":{},"privateKey":{"algorithm":"ECDSA","encoding":"PKCS1","size":256},"renewBefore":"360h0m0s","selfSigned":{"enabled":false},"usages":["server auth","key encipherment","signing"]},"enabled":false,"privateKeySecret":""}` | TLS configuration between client and Envoy. |
| tls.downstream.certChainSecret | string | `""` | Name of the Secret containing the certificate chain file used for TLS communication. |
| tls.downstream.certManager.dnsNames | list | `["localhost"]` | Subject Alternative Name (SAN) of a certificate. |
| tls.downstream.certManager.duration | string | `"8760h0m0s"` | Duration of a certificate. |
| tls.downstream.certManager.enabled | bool | `false` | Use cert-manager to manage private key and certificate files. |
| tls.downstream.certManager.issuerRef | object | `{}` | Issuer references of cert-manager. |
| tls.downstream.certManager.privateKey | object | `{"algorithm":"ECDSA","encoding":"PKCS1","size":256}` | Configuration of a private key. |
| tls.downstream.certManager.renewBefore | string | `"360h0m0s"` | How long before expiry a certificate should be renewed. |
| tls.downstream.certManager.selfSigned | object | `{"enabled":false}` | Use self-signed CA. |
| tls.downstream.certManager.usages | list | `["server auth","key encipherment","signing"]` | List of key usages. |
| tls.downstream.enabled | bool | `false` | Enable TLS between client and Envoy. |
| tls.downstream.privateKeySecret | string | `""` | Name of the Secret containing the private key file used for TLS communication. |
| tls.upstream | object | `{"caRootCertSecret":"","enabled":false,"overrideAuthority":""}` | TLS configuration between Envoy and ScalarDB Cluster or ScalarDL. |
| tls.upstream.caRootCertSecret | string | `""` | Name of the Secret containing the custom CA root certificate for TLS communication. |
| tls.upstream.enabled | bool | `false` | Enable TLS between Envoy and ScalarDB Cluster or ScalarDL. You need to enable TLS when you use wire encryption feature of ScalarDB Cluster or ScalarDL. |
| tls.upstream.overrideAuthority | string | `""` | The custom authority for TLS communication. This doesn't change what host is actually connected. This is intended for testing, but may safely be used outside of tests as an alternative to DNS overrides. For example, you can specify the hostname presented in the certificate chain file that you set by using `scalardbCluster.tls.certChainSecret`, `ledger.tls.certChainSecret`, or `auditor.tls.certChainSecret`. Envoy uses this value for certificate verification of TLS connection with ScalarDB Cluster or ScalarDL. |
| tolerations | list | `[]` | Tolerations are applied to pods, and allow (but do not require) the pods to schedule onto nodes with matching taints. |
