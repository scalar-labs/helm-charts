# scalardb-cluster-monitoring

ScalarDB Cluster Monitoring Stack
Current chart version is `0.0.0-SNAPSHOT`

## Requirements

| Repository | Name | Version |
|------------|------|---------|
| https://grafana.github.io/helm-charts | alloy | ~0.12.5 |
| https://grafana.github.io/helm-charts | grafana | ~8.10.4 |
| https://grafana.github.io/helm-charts | loki | ~6.28.0 |
| https://prometheus-community.github.io/helm-charts | prometheus | ~27.7.0 |

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| alloy.alloy.configMap.content | string | `"{{ include \"scalardb-cluster-monitoring.alloyContent\" . }}\n"` |  |
| alloy.alloy.securityContext.allowPrivilegeEscalation | bool | `false` |  |
| alloy.alloy.securityContext.capabilities.drop[0] | string | `"ALL"` |  |
| alloy.configReloader.securityContext.allowPrivilegeEscalation | bool | `false` |  |
| alloy.configReloader.securityContext.capabilities.drop[0] | string | `"ALL"` |  |
| alloy.configReloader.securityContext.runAsNonRoot | bool | `true` |  |
| alloy.controller.podLabels."app.kubernetes.io/app" | string | `"scalardb-cluster-monitoring"` |  |
| alloy.controller.podLabels."container.kubeaudit.io/alloy.allow-run-as-root" | string | `""` |  |
| alloy.controller.replicas | int | `1` |  |
| alloy.controller.type | string | `"deployment"` |  |
| alloy.enabled | bool | `true` |  |
| alloy.global.podSecurityContext.seccompProfile.type | string | `"RuntimeDefault"` |  |
| global.envoy.enabled | bool | `false` |  |
| grafana.datasources."datasources.yaml".apiVersion | int | `1` |  |
| grafana.datasources."datasources.yaml".datasources[0].access | string | `"proxy"` |  |
| grafana.datasources."datasources.yaml".datasources[0].editable | bool | `false` |  |
| grafana.datasources."datasources.yaml".datasources[0].isDefault | bool | `false` |  |
| grafana.datasources."datasources.yaml".datasources[0].jsonData.timeInterval | string | `"30s"` |  |
| grafana.datasources."datasources.yaml".datasources[0].name | string | `"Prometheus"` |  |
| grafana.datasources."datasources.yaml".datasources[0].type | string | `"prometheus"` |  |
| grafana.datasources."datasources.yaml".datasources[0].uid | string | `"prometheus"` |  |
| grafana.datasources."datasources.yaml".datasources[0].url | string | `"http://{{ .Release.Name }}-prometheus-server:9090/"` |  |
| grafana.datasources."datasources.yaml".datasources[1].access | string | `"proxy"` |  |
| grafana.datasources."datasources.yaml".datasources[1].editable | bool | `false` |  |
| grafana.datasources."datasources.yaml".datasources[1].isDefault | bool | `false` |  |
| grafana.datasources."datasources.yaml".datasources[1].name | string | `"Loki"` |  |
| grafana.datasources."datasources.yaml".datasources[1].type | string | `"loki"` |  |
| grafana.datasources."datasources.yaml".datasources[1].uid | string | `"loki"` |  |
| grafana.datasources."datasources.yaml".datasources[1].url | string | `"http://{{ .Release.Name }}-loki:3100/"` |  |
| grafana.enabled | bool | `true` |  |
| grafana.extraLabels."app.kubernetes.io/app" | string | `"scalardb-cluster-monitoring"` |  |
| grafana.service.port | int | `3000` |  |
| grafana.service.type | string | `"ClusterIP"` |  |
| grafana.sidecar.dashboards.enabled | bool | `true` |  |
| grafana.sidecar.dashboards.label | string | `"grafana_dashboard"` |  |
| grafana.sidecar.dashboards.labelValue | string | `"1"` |  |
| grafana.sidecar.datasources.enabled | bool | `true` |  |
| grafana.sidecar.datasources.label | string | `"grafana_datasource"` |  |
| grafana.sidecar.datasources.labelValue | string | `"1"` |  |
| grafana.testFramework.containerSecurityContext.allowPrivilegeEscalation | bool | `false` |  |
| grafana.testFramework.containerSecurityContext.capabilities.drop[0] | string | `"ALL"` |  |
| grafana.testFramework.securityContext.runAsNonRoot | bool | `true` |  |
| grafana.testFramework.securityContext.seccompProfile.type | string | `"RuntimeDefault"` |  |
| loki.backend.replicas | int | `0` |  |
| loki.bloomCompactor.replicas | int | `0` |  |
| loki.bloomGateway.replicas | int | `0` |  |
| loki.chunksCache.enabled | bool | `false` |  |
| loki.compactor.replicas | int | `0` |  |
| loki.deploymentMode | string | `"SingleBinary"` |  |
| loki.distributor.replicas | int | `0` |  |
| loki.enabled | bool | `true` |  |
| loki.gateway.enabled | bool | `false` |  |
| loki.indexGateway.replicas | int | `0` |  |
| loki.ingester.replicas | int | `0` |  |
| loki.loki.auth_enabled | bool | `false` |  |
| loki.loki.commonConfig.replication_factor | int | `1` |  |
| loki.loki.compactor.delete_request_store | string | `"s3"` |  |
| loki.loki.compactor.retention_enabled | bool | `true` |  |
| loki.loki.extraMemberlistConfig.bind_addr[0] | string | `"${MY_POD_IP}"` |  |
| loki.loki.limits_config.discover_service_name | list | `[]` |  |
| loki.loki.limits_config.retention_period | string | `"720h"` |  |
| loki.loki.pattern_ingester.enabled | bool | `true` |  |
| loki.loki.podLabels."app.kubernetes.io/app" | string | `"scalardb-cluster-monitoring"` |  |
| loki.loki.schemaConfig.configs[0].from | string | `"2024-04-01"` |  |
| loki.loki.schemaConfig.configs[0].index.period | string | `"24h"` |  |
| loki.loki.schemaConfig.configs[0].index.prefix | string | `"loki_index_"` |  |
| loki.loki.schemaConfig.configs[0].object_store | string | `"s3"` |  |
| loki.loki.schemaConfig.configs[0].schema | string | `"v13"` |  |
| loki.loki.schemaConfig.configs[0].store | string | `"tsdb"` |  |
| loki.lokiCanary.enabled | bool | `false` |  |
| loki.minio.additionalLabels."app.kubernetes.io/app" | string | `"scalardb-cluster-monitoring"` |  |
| loki.minio.containerSecurityContext.allowPrivilegeEscalation | bool | `false` |  |
| loki.minio.containerSecurityContext.capabilities.drop[0] | string | `"ALL"` |  |
| loki.minio.containerSecurityContext.readOnlyRootFilesystem | bool | `false` |  |
| loki.minio.enabled | bool | `true` |  |
| loki.minio.makeBucketJob.containerSecurityContext.allowPrivilegeEscalation | bool | `false` |  |
| loki.minio.makeBucketJob.containerSecurityContext.capabilities.drop[0] | string | `"ALL"` |  |
| loki.minio.makeBucketJob.containerSecurityContext.runAsGroup | int | `1000` |  |
| loki.minio.makeBucketJob.containerSecurityContext.runAsUser | int | `1000` |  |
| loki.minio.makeBucketJob.securityContext.enabled | bool | `true` |  |
| loki.minio.makeUserJob.containerSecurityContext.allowPrivilegeEscalation | bool | `false` |  |
| loki.minio.makeUserJob.containerSecurityContext.capabilities.drop[0] | string | `"ALL"` |  |
| loki.minio.makeUserJob.containerSecurityContext.runAsGroup | int | `1000` |  |
| loki.minio.makeUserJob.containerSecurityContext.runAsUser | int | `1000` |  |
| loki.minio.makeUserJob.securityContext.enabled | bool | `true` |  |
| loki.minio.podLabels."app.kubernetes.io/app" | string | `"scalardb-cluster-monitoring"` |  |
| loki.minio.postJob.securityContext.enabled | bool | `true` |  |
| loki.minio.postJob.securityContext.fsGroup | int | `1000` |  |
| loki.minio.postJob.securityContext.runAsGroup | int | `1000` |  |
| loki.minio.postJob.securityContext.runAsUser | int | `1000` |  |
| loki.querier.replicas | int | `0` |  |
| loki.queryFrontend.replicas | int | `0` |  |
| loki.queryScheduler.replicas | int | `0` |  |
| loki.read.replicas | int | `0` |  |
| loki.resultsCache.enabled | bool | `false` |  |
| loki.singleBinary.extraArgs[0] | string | `"-config.expand-env=true"` |  |
| loki.singleBinary.extraEnv[0].name | string | `"MY_POD_IP"` |  |
| loki.singleBinary.extraEnv[0].valueFrom.fieldRef.fieldPath | string | `"status.podIP"` |  |
| loki.singleBinary.replicas | int | `1` |  |
| loki.test.enabled | bool | `false` |  |
| loki.write.replicas | int | `0` |  |
| prometheus.alertmanager.enabled | bool | `false` |  |
| prometheus.commonMetaLabels."app.kubernetes.io/app" | string | `"scalardb-cluster-monitoring"` |  |
| prometheus.configmapReload.prometheus.containerSecurityContext.allowPrivilegeEscalation | bool | `false` |  |
| prometheus.configmapReload.prometheus.containerSecurityContext.capabilities.drop[0] | string | `"ALL"` |  |
| prometheus.enabled | bool | `true` |  |
| prometheus.extraScrapeConfigs | string | `"{{ include \"scalardb-cluster-monitoring.prometheusExtraScrapeConfig\" . }}\n"` |  |
| prometheus.kube-state-metrics.customLabels."app.kubernetes.io/app" | string | `"scalardb-cluster-monitoring"` |  |
| prometheus.kube-state-metrics.enabled | bool | `true` |  |
| prometheus.kube-state-metrics.rbac.useClusterRole | bool | `false` |  |
| prometheus.kube-state-metrics.releaseNamespace | bool | `true` |  |
| prometheus.prometheus-node-exporter.enabled | bool | `false` |  |
| prometheus.prometheus-pushgateway.enabled | bool | `false` |  |
| prometheus.server.affinity | object | `{}` |  |
| prometheus.server.containerSecurityContext.allowPrivilegeEscalation | bool | `false` |  |
| prometheus.server.containerSecurityContext.capabilities.drop[0] | string | `"ALL"` |  |
| prometheus.server.releaseNamespace | bool | `true` |  |
| prometheus.server.service.enabled | bool | `true` |  |
| prometheus.server.service.servicePort | int | `9090` |  |
| prometheus.server.service.type | string | `"ClusterIP"` |  |
| prometheus.serverFiles."prometheus.yml".scrape_configs | list | `[]` |  |
