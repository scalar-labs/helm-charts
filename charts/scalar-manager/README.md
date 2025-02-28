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
| api.service.port | int | `8080` |  |
| api.service.type | string | `"ClusterIP"` |  |
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
| serviceAccount.automountServiceAccountToken | bool | `true` |  |
| serviceAccount.serviceAccountName | string | `""` |  |
| tolerations | list | `[]` |  |
| web.env | string | `"GRAFANA_SERVER_URL=http://scalar-monitoring-grafana.monitoring.svc.cluster.local:3000\n"` | The environment variables for Scalar Manager web container. If you want to customize environment variables, you can override this value with your environment variables. Currently, the GRAFANA_SERVER_URL is set to the Grafana service url installed in the monitoring namespace. |
| web.image.pullPolicy | string | `"IfNotPresent"` |  |
| web.image.repository | string | `"ghcr.io/scalar-labs/scalar-manager-web"` |  |
| web.image.tag | string | `""` |  |
| web.resources | object | `{}` |  |
| web.service.port | int | `80` |  |
| web.service.type | string | `"ClusterIP"` |  |
