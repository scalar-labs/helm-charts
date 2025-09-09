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
| scalarManager.tolerations | list | `[]` |  |
| scalarManager.web.env | list | `[{"name":"GRAFANA_SERVER_URL","value":"http://scalardb-cluster-monitoring-grafana:3000"}]` | The environment variables for Scalar Manager web container. If you want to customize environment variables, you can override this value with your environment variables. |
| scalarManager.web.image.pullPolicy | string | `"IfNotPresent"` |  |
| scalarManager.web.image.repository | string | `"ghcr.io/scalar-labs/scalar-manager-web"` |  |
| scalarManager.web.image.tag | string | `""` |  |
| scalarManager.web.resources | object | `{}` |  |
| scalarManager.web.service.annotations | object | `{}` | Service annotations. For example, you can configure the Load Balancer provided by Cloud Service. |
| scalarManager.web.service.ports.web.port | int | `13000` |  |
| scalarManager.web.service.ports.web.protocol | string | `"TCP"` |  |
| scalarManager.web.service.ports.web.targetPort | int | `13000` |  |
| scalarManager.web.service.type | string | `"ClusterIP"` |  |
