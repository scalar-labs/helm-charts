# scalar-manager

![Version: 3.0.0](https://img.shields.io/badge/Version-3.0.0-informational?style=flat-square)  ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square)  ![AppVersion: 3.0.1](https://img.shields.io/badge/AppVersion-3.0.1-informational?style=flat-square)

Scalar Manager
Current chart version is `3.0.0`

**Homepage:** <https://scalar-labs.com/>

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| fullnameOverride | string | `""` |  |
| global.azure | object | `{"extension":{"resourceId":"DONOTMODIFY"},"identity":{"clientId":"DONOTMODIFY"},"images":{"scalarManagerApi":{"image":"scalar-manager-api-azure-payg","registry":"scalar.azurecr.io","tag":""},"scalarManagerWeb":{"image":"scalar-manager-web-azure-payg","registry":"scalar.azurecr.io","tag":""}},"marketplace":{"planId":"DONOTMODIFY"}}` | Azure Marketplace specific configurations. |
| global.azure.images.scalarManagerApi | object | `{"image":"scalar-manager-api-azure-payg","registry":"scalar.azurecr.io","tag":""}` | Container image of Scalar Manager for Azure Marketplace. |
| global.platform | string | `""` | Specify the platform that you use. This configuration is for internal use. |
| nameOverride | string | `""` |  |
| scalarManager.affinity | object | `{}` | The affinity/anti-affinity feature, greatly expands the types of constraints you can express. |
| scalarManager.api.applicationProperties | string | The minimum template of application.properties is set by default. | The application.properties for Scalar Manager. If you want to customize application.properties, you can override this value with your application.properties. |
| scalarManager.api.image.pullPolicy | string | `"IfNotPresent"` |  |
| scalarManager.api.image.repository | string | `"ghcr.io/scalar-labs/scalar-manager-api"` |  |
| scalarManager.api.image.tag | string | `""` |  |
| scalarManager.api.resources | object | `{}` |  |
| scalarManager.imagePullSecrets | list | `[]` |  |
| scalarManager.nodeSelector | object | `{}` |  |
| scalarManager.podAnnotations | object | `{}` | Pod annotations for the scalar-manager deployment |
| scalarManager.podLabels | object | `{}` | Pod labels for the scalar-manager deployment |
| scalarManager.podSecurityContext.seccompProfile.type | string | `"RuntimeDefault"` |  |
| scalarManager.replicaCount | int | `1` |  |
| scalarManager.securityContext.allowPrivilegeEscalation | bool | `false` |  |
| scalarManager.securityContext.capabilities.drop[0] | string | `"ALL"` |  |
| scalarManager.securityContext.runAsNonRoot | bool | `true` |  |
| scalarManager.serviceAccount.automountServiceAccountToken | bool | `true` |  |
| scalarManager.serviceAccount.serviceAccountName | string | `""` |  |
| scalarManager.tls | object | `{"certManager":{"dnsNames":["localhost","scalar-manager"],"duration":"8760h0m0s","enabled":false,"issuerRef":{},"privateKey":{"algorithm":"RSA","encoding":"PKCS8","size":2048},"renewBefore":"360h0m0s","selfSigned":{"enabled":false},"usages":["server auth","key encipherment","signing"]},"downstream":{"caRootCertSecret":"","certChainSecret":"","enabled":false,"privateKeySecret":""},"upstream":{"grafana":[],"prometheus":[],"scalardb":[],"scalardl":{"auditor":[],"ledger":[]}}}` | Unified TLS configuration for both API and Web components. |
| scalarManager.tls.certManager | object | `{"dnsNames":["localhost","scalar-manager"],"duration":"8760h0m0s","enabled":false,"issuerRef":{},"privateKey":{"algorithm":"RSA","encoding":"PKCS8","size":2048},"renewBefore":"360h0m0s","selfSigned":{"enabled":false},"usages":["server auth","key encipherment","signing"]}` | Cert-manager integration for automatic certificate management. |
| scalarManager.tls.certManager.dnsNames | list | `["localhost","scalar-manager"]` | DNS names for the certificate. |
| scalarManager.tls.certManager.duration | string | `"8760h0m0s"` | Duration of the certificate. |
| scalarManager.tls.certManager.enabled | bool | `false` | Enable cert-manager integration. |
| scalarManager.tls.certManager.issuerRef | object | `{}` | Reference to the issuer for the certificate. |
| scalarManager.tls.certManager.privateKey | object | `{"algorithm":"RSA","encoding":"PKCS8","size":2048}` | Private key configurations. |
| scalarManager.tls.certManager.renewBefore | string | `"360h0m0s"` | How long before expiry the certificate should be renewed. |
| scalarManager.tls.certManager.selfSigned | object | `{"enabled":false}` | Use a self-signed certificate. |
| scalarManager.tls.certManager.usages | list | `["server auth","key encipherment","signing"]` | Usages for the certificate. |
| scalarManager.tls.downstream | object | `{"caRootCertSecret":"","certChainSecret":"","enabled":false,"privateKeySecret":""}` | Enable downstream TLS for Scalar Manager (applies to both API and Web components). |
| scalarManager.tls.downstream.caRootCertSecret | string | `""` | Secret containing the CA root certificate for web-to-API communication (Web needs to validate API's TLS certificate). |
| scalarManager.tls.downstream.certChainSecret | string | `""` | Secret containing the certificate for downstream TLS. |
| scalarManager.tls.downstream.enabled | bool | `false` | Enable downstream TLS (Web and API share the same certificate). |
| scalarManager.tls.downstream.privateKeySecret | string | `""` | Secret containing the private key for downstream TLS. |
| scalarManager.tls.upstream | object | `{"grafana":[],"prometheus":[],"scalardb":[],"scalardl":{"auditor":[],"ledger":[]}}` | Upstream TLS configuration for external service connections. |
| scalarManager.tls.upstream.grafana | list | `[]` | Grafana TLS configuration (array to support multiple namespaces). |
| scalarManager.tls.upstream.prometheus | list | `[]` | Prometheus TLS configuration (array to support multiple namespaces). |
| scalarManager.tls.upstream.scalardb | list | `[]` | ScalarDB TLS configuration (array to support multiple namespaces). |
| scalarManager.tls.upstream.scalardl | object | `{"auditor":[],"ledger":[]}` | ScalarDL TLS configuration (nested structure for ledger and auditor). |
| scalarManager.tls.upstream.scalardl.auditor | list | `[]` | ScalarDL Auditor TLS configuration (array to support multiple namespaces). |
| scalarManager.tls.upstream.scalardl.ledger | list | `[]` | ScalarDL Ledger TLS configuration (array to support multiple namespaces). |
| scalarManager.tolerations | list | `[]` |  |
| scalarManager.web.env | list | `[{"name":"GRAFANA_SERVICE_INFO_CACHE_TTL","value":"180000"}]` | The environment variables for Scalar Manager web container. If you want to customize environment variables, you can override this value with your environment variables. |
| scalarManager.web.image.pullPolicy | string | `"IfNotPresent"` |  |
| scalarManager.web.image.repository | string | `"ghcr.io/scalar-labs/scalar-manager-web"` |  |
| scalarManager.web.image.tag | string | `""` |  |
| scalarManager.web.resources | object | `{}` |  |
| scalarManager.web.service.annotations | object | `{}` | Service annotations. For example, you can configure the Load Balancer provided by Cloud Service. |
| scalarManager.web.service.ports.web.port | int | `13000` |  |
| scalarManager.web.service.ports.web.protocol | string | `"TCP"` |  |
| scalarManager.web.service.ports.web.targetPort | int | `13000` |  |
| scalarManager.web.service.type | string | `"ClusterIP"` |  |
