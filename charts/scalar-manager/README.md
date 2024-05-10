# scalar-manager

![Version: 2.0.0-SNAPSHOT](https://img.shields.io/badge/Version-2.0.0--SNAPSHOT-informational?style=flat-square)  ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square)  ![AppVersion: 2.0.0-SNAPSHOT](https://img.shields.io/badge/AppVersion-2.0.0--SNAPSHOT-informational?style=flat-square)

Scalar Manager
Current chart version is `2.0.0-SNAPSHOT`

**Homepage:** <https://scalar-labs.com/>

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| api.applicationProperties | string | `"grafana.kubernetesServiceLabelName=${GRAFANA_KUBERNETES_SERVICE_LABEL_NAME:app.kubernetes.io/name}\ngrafana.kubernetesServiceLabelValue=${GRAFANA_KUBERNETES_SERVICE_LABEL_VALUE:grafana}\ngrafana.kubernetesServicePortName=${GRAFANA_KUBERNETES_SERVICE_PORT_NAME:http-web}\n\nprometheus.kubernetesServiceLabelName=${PROMETHEUS_KUBERNETES_SERVICE_LABEL_NAME:app}\nprometheus.kubernetesServiceLabelValue=${PROMETHEUS_KUBERNETES_SERVICE_LABEL_VALUE:kube-prometheus-stack-prometheus}\nprometheus.kubernetesServicePortName=${PROMETHEUS_KUBERNETES_SERVICE_PORT_NAME:http-web}\n\nloki.kubernetesServiceLabelName=${LOKI_KUBERNETES_SERVICE_LABEL_NAME:app}\nloki.kubernetesServiceLabelValue=${LOKI_KUBERNETES_SERVICE_LABEL_VALUE:loki}\nloki.kubernetesServicePortName=${LOKI_KUBERNETES_SERVICE_PORT_NAME:http-metrics}\n\nhelm.scalarRepositoryName=${HELM_SCALAR_REPOSITORY_NAME:scalar-labs}\nhelm.scalarRepositoryUrl=${HELM_SCALAR_REPOSITORY_URL:https://scalar-labs.github.io/helm-charts}\nhelm.scalarAdminForKubernetesChartName=${HELM_SCALAR_ADMIN_FOR_KUBERNETES_CHART_NAME:scalar-admin-for-kubernetes}\nhelm.scalarAdminForKubernetesChartVersion=${HELM_SCALAR_ADMIN_FOR_KUBERNETES_CHART_VERSION:1.0.0}\n\nconfigMapNamespace=${CONFIG_MAP_NAMESPACE:default}\nconfigMapName=${CONFIG_MAP_NAME:scalar-manager-metadata}\n\npaused-state-retention.storage=${PAUSED_STATE_RETENTION_STORAGE:configmap}\npaused-state-retention.max-number=${PAUSED_STATE_RETENTION_MAX_NUMBER:100}\n"` |  |
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
| service.port | int | `80` |  |
| service.type | string | `"ClusterIP"` |  |
| serviceAccount.automountServiceAccountToken | bool | `true` |  |
| serviceAccount.serviceAccountName | string | `""` |  |
| tolerations | list | `[]` |  |
| web.image.pullPolicy | string | `"IfNotPresent"` |  |
| web.image.repository | string | `"ghcr.io/scalar-labs/scalar-manager-web"` |  |
| web.image.tag | string | `""` |  |
| web.resources | object | `{}` |  |
