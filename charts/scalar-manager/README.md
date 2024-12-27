# scalar-manager

![Version: 3.0.0-SNAPSHOT](https://img.shields.io/badge/Version-3.0.0--SNAPSHOT-informational?style=flat-square)  ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square)  ![AppVersion: 3.0.0-SNAPSHOT](https://img.shields.io/badge/AppVersion-3.0.0--SNAPSHOT-informational?style=flat-square)

Scalar Manager
Current chart version is `3.0.0-SNAPSHOT`

**Homepage:** <https://scalar-labs.com/>

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| api.applicationProperties | string | The minimum template of application.properties is set by default. | The application.properties for Scalar Manager. If you want to customize application.properties, you can override this value with your application.properties. |
| api.image.pullPolicy | string | `"IfNotPresent"` |  |
| api.image.repository | string | `"ghcr.io/scalar-labs/scalar-manager-api"` |  |
| api.image.tag | string | `""` |  |
| api.resources | object | `{}` |  |
| fullnameOverride | string | `""` |  |
| imagePullSecrets[0].name | string | `"reg-docker-secrets"` |  |
| nameOverride | string | `""` |  |
| nodeSelector | object | `{}` |  |
| podAnnotations | object | `{}` |  |
| podLabels | object | `{}` |  |
| podSecurityContext.seccompProfile.type | string | `"RuntimeDefault"` |  |
| replicaCount | int | `1` |  |
| securityContext.allowPrivilegeEscalation | bool | `false` |  |
| securityContext.capabilities.drop[0] | string | `"ALL"` |  |
| securityContext.runAsNonRoot | bool | `true` |  |
| service.api.port | int | `8080` |  |
| service.api.type | string | `"ClusterIP"` |  |
| service.web.port | int | `80` |  |
| service.web.type | string | `"ClusterIP"` |  |
| serviceAccount.automountServiceAccountToken | bool | `true` |  |
| serviceAccount.serviceAccountName | string | `""` |  |
| tolerations | list | `[]` |  |
| web.authorization.baseUrl | string | `"http://localhost:8080"` |  |
| web.authorization.enabled | bool | `false` |  |
| web.image.pullPolicy | string | `"IfNotPresent"` |  |
| web.image.repository | string | `"ghcr.io/scalar-labs/scalar-manager-web"` |  |
| web.image.tag | string | `""` |  |
| web.operation.baseUrl | string | `"http://localhost:8080"` |  |
| web.resources | object | `{}` |  |
