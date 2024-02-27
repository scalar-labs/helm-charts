# scalar-manager

![Version: 2.0.0-SNAPSHOT](https://img.shields.io/badge/Version-2.0.0--SNAPSHOT-informational?style=flat-square)  ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square)  ![AppVersion: 2.0.0-SNAPSHOT](https://img.shields.io/badge/AppVersion-2.0.0--SNAPSHOT-informational?style=flat-square)

Scalar Manager
Current chart version is `2.0.0-SNAPSHOT`

**Homepage:** <https://scalar-labs.com/>

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| api.grafanaKubernetesServiceLabelName | string | `"app.kubernetes.io/name"` |  |
| api.grafanaKubernetesServiceLabelValue | string | `"grafana"` |  |
| api.grafanaKubernetesServicePortName | string | `"http-web"` |  |
| api.helmScalarAdminForKubernetesChartName | string | `"scalar-admin-for-kubernetes"` |  |
| api.helmScalarAdminForKubernetesChartVersion | string | `"1.0.0"` |  |
| api.helmScalarRepositoryName | string | `"scalar-labs"` |  |
| api.helmScalarRepositoryUrl | string | `"https://scalar-labs.github.io/helm-charts"` |  |
| api.image.pullPolicy | string | `"IfNotPresent"` |  |
| api.image.repository | string | `"ghcr.io/scalar-labs/scalar-manager-api"` |  |
| api.image.tag | string | `""` |  |
| api.lokiKubernetesServiceLabelName | string | `"app"` |  |
| api.lokiKubernetesServiceLabelValue | string | `"loki"` |  |
| api.lokiKubernetesServicePortName | string | `"http-metrics"` |  |
| api.pausedStateRetentionMaxNumber | string | `"100"` |  |
| api.pausedStateRetentionStorage | string | `"configmap"` |  |
| api.prometheusKubernetesServiceLabelName | string | `"app"` |  |
| api.prometheusKubernetesServiceLabelValue | string | `"kube-prometheus-stack-prometheus"` |  |
| api.prometheusKubernetesServicePortName | string | `"http-web"` |  |
| fullnameOverride | string | `""` |  |
| imagePullSecrets[0].name | string | `"reg-docker-secrets"` |  |
| nameOverride | string | `""` |  |
| nodeSelector | object | `{}` |  |
| podAnnotations | object | `{}` |  |
| podLabels | object | `{}` |  |
| podSecurityContext | object | `{}` |  |
| replicaCount | int | `1` |  |
| resources | object | `{}` |  |
| securityContext | object | `{}` |  |
| service.port | int | `80` |  |
| service.type | string | `"LoadBalancer"` |  |
| serviceAccount.automount | bool | `true` |  |
| serviceAccount.create | bool | `true` |  |
| serviceAccount.name | string | `""` |  |
| tolerations | list | `[]` |  |
| web.image.pullPolicy | string | `"IfNotPresent"` |  |
| web.image.repository | string | `"ghcr.io/scalar-labs/scalar-manager-web"` |  |
| web.image.tag | string | `""` |  |
