# scalardb-mcp-server

![Version: 1.0.0-SNAPSHOT](https://img.shields.io/badge/Version-1.0.0--SNAPSHOT-informational?style=flat-square)  ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square)  ![AppVersion: 1.0.0-SNAPSHOT](https://img.shields.io/badge/AppVersion-1.0.0--SNAPSHOT-informational?style=flat-square)

ScalarDB MCP Server
Current chart version is `1.0.0-SNAPSHOT`

**Homepage:** <https://scalar-labs.com/>

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| fullnameOverride | string | `""` | Override the fully qualified app name. |
| ingress | object | `{"annotations":{},"className":"","enabled":false,"hosts":[{"host":"","paths":[{"path":"/","pathType":"Prefix"}]}],"tls":[]}` | Ingress configuration with TLS termination support. |
| ingress.annotations | object | `{}` | Ingress annotations. |
| ingress.className | string | `""` | Ingress class name (e.g., nginx, alb, azure/application-gateway). |
| ingress.enabled | bool | `false` | Enable ingress. |
| ingress.hosts | list | `[{"host":"","paths":[{"path":"/","pathType":"Prefix"}]}]` | Ingress hosts configuration. |
| ingress.tls | list | `[]` | TLS configuration for ingress. |
| nameOverride | string | `""` | Override the name of the chart. |
| scalardbMcpServer.affinity | object | `{}` | Affinity for pod assignment. |
| scalardbMcpServer.applicationProperties | string | The default application.properties for ScalarDB MCP Server with OAuth 2.1 configuration. | The application.properties for ScalarDB MCP Server. If you want to customize application.properties, you can override this value with your application.properties. |
| scalardbMcpServer.env | list | No environment variables are set by default. | Environment variables for the container. Use this to inject secrets and configuration. |
| scalardbMcpServer.image.pullPolicy | string | `"IfNotPresent"` | Container image pull policy. |
| scalardbMcpServer.image.repository | string | `"ghcr.io/scalar-labs/scalardb-mcp-server"` | Container image repository. |
| scalardbMcpServer.image.tag | string | `""` | Overrides the image tag whose default is the chart appVersion. |
| scalardbMcpServer.imagePullSecrets | list | `[]` | Secrets for pulling container images. |
| scalardbMcpServer.nodeSelector | object | `{}` | Node selector for pod assignment. |
| scalardbMcpServer.persistence | object | `{"accessMode":"ReadWriteOnce","annotations":{},"enabled":true,"existingClaim":"","mountPath":"/scalardb-mcp-server/data","size":"1Gi","storageClass":""}` | Persistence configuration for SQLite database. |
| scalardbMcpServer.persistence.accessMode | string | `"ReadWriteOnce"` | Access mode for the PVC. |
| scalardbMcpServer.persistence.annotations | object | `{}` | Annotations for the PVC. |
| scalardbMcpServer.persistence.enabled | bool | `true` | Enable persistence using PVC. |
| scalardbMcpServer.persistence.existingClaim | string | `""` | Use an existing PVC instead of creating a new one. |
| scalardbMcpServer.persistence.mountPath | string | `"/scalardb-mcp-server/data"` | Mount path for the persistent volume. |
| scalardbMcpServer.persistence.size | string | `"1Gi"` | Size of the PVC. |
| scalardbMcpServer.persistence.storageClass | string | `""` | Storage class for dynamic provisioning. Leave empty for default. |
| scalardbMcpServer.podAnnotations | object | `{}` | Annotations to add to the pod. |
| scalardbMcpServer.podLabels | object | `{}` | Labels to add to the pod. |
| scalardbMcpServer.podSecurityContext | object | `{"seccompProfile":{"type":"RuntimeDefault"}}` | Pod security context. |
| scalardbMcpServer.replicaCount | int | `1` | Number of replicas to deploy. |
| scalardbMcpServer.resources | object | `{}` | Resource limits and requests for the container. |
| scalardbMcpServer.securityContext | object | `{"allowPrivilegeEscalation":false,"capabilities":{"drop":["ALL"]},"runAsNonRoot":true}` | Container security context. |
| scalardbMcpServer.service.annotations | object | `{}` | Service annotations. |
| scalardbMcpServer.service.port | int | `8080` | Service port. |
| scalardbMcpServer.service.protocol | string | `"TCP"` | Protocol for the service. |
| scalardbMcpServer.service.targetPort | int | `8080` | Container target port. |
| scalardbMcpServer.service.type | string | `"ClusterIP"` | Service type. |
| scalardbMcpServer.serviceAccount.automountServiceAccountToken | bool | `false` | Whether to automount the service account token. |
| scalardbMcpServer.serviceAccount.serviceAccountName | string | `""` | Specify an existing service account name. If not specified, a new service account will be created. |
| scalardbMcpServer.tolerations | list | `[]` | Tolerations for pod assignment. |
