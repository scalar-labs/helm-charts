{{/*
Prometheus scrape configuration
*/}}
{{- define "scalardl-ledger-monitoring.prometheusExtraScrapeConfig" -}}
{{- if .Values.global.envoy.enabled }}
- job_name: scalardl-ledger-envoy-metrics
  honor_timestamps: true
  track_timestamps_staleness: false
  scrape_interval: 10s
  scrape_timeout: 10s
  scrape_protocols:
  - OpenMetricsText1.0.0
  - OpenMetricsText0.0.1
  - PrometheusText1.0.0
  - PrometheusText0.0.4
  metrics_path: /stats/prometheus
  scheme: http
  enable_compression: true
  follow_redirects: true
  enable_http2: true
  relabel_configs:
  - source_labels: [job]
    separator: ;
    target_label: __tmp_prometheus_job_name
    replacement: $1
    action: replace
  - source_labels: [__meta_kubernetes_service_label_app_kubernetes_io_app, __meta_kubernetes_service_labelpresent_app_kubernetes_io_app]
    separator: ;
    regex: (envoy);true
    replacement: $1
    action: keep
  - source_labels: [__meta_kubernetes_service_label_app_kubernetes_io_name, __meta_kubernetes_service_labelpresent_app_kubernetes_io_name]
    separator: ;
    regex: (scalardl);true
    replacement: $1
    action: keep
  - source_labels: [__meta_kubernetes_endpoint_port_name]
    separator: ;
    regex: admin
    replacement: $1
    action: keep
  - source_labels: [__meta_kubernetes_endpoint_address_target_kind, __meta_kubernetes_endpoint_address_target_name]
    separator: ;
    regex: Node;(.*)
    target_label: node
    replacement: ${1}
    action: replace
  - source_labels: [__meta_kubernetes_endpoint_address_target_kind, __meta_kubernetes_endpoint_address_target_name]
    separator: ;
    regex: Pod;(.*)
    target_label: pod
    replacement: ${1}
    action: replace
  - source_labels: [__meta_kubernetes_namespace]
    separator: ;
    target_label: namespace
    replacement: $1
    action: replace
  - source_labels: [__meta_kubernetes_service_name]
    separator: ;
    target_label: service
    replacement: $1
    action: replace
  - source_labels: [__meta_kubernetes_pod_name]
    separator: ;
    target_label: pod
    replacement: $1
    action: replace
  - source_labels: [__meta_kubernetes_pod_container_name]
    separator: ;
    target_label: container
    replacement: $1
    action: replace
  - source_labels: [__meta_kubernetes_pod_phase]
    separator: ;
    regex: (Failed|Succeeded)
    replacement: $1
    action: drop
  - source_labels: [__meta_kubernetes_service_name]
    separator: ;
    target_label: job
    replacement: ${1}
    action: replace
  - separator: ;
    target_label: endpoint
    replacement: admin
    action: replace
  - source_labels: [__address__, __tmp_hash]
    separator: ;
    regex: (.+);
    target_label: __tmp_hash
    replacement: $1
    action: replace
  - source_labels: [__tmp_hash]
    separator: ;
    modulus: 1
    target_label: __tmp_hash
    replacement: $1
    action: hashmod
  - source_labels: [__tmp_hash]
    separator: ;
    regex: "0"
    replacement: $1
    action: keep
  kubernetes_sd_configs:
  - role: endpoints
    kubeconfig_file: ""
    follow_redirects: true
    enable_http2: true
    namespaces:
      own_namespace: true
{{- else }}
{{/*
Nothing to do if global.envoy.enabled=false
*/}}
{{- end }}
{{- end }}
