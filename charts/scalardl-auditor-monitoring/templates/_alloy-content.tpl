{{/*
Grafana Alloy components configuration
*/}}
{{- define "scalardl-auditor-monitoring.alloyContent" -}}
discovery.kubernetes "scalardl_auditor" {
  role = "pod"
  namespaces {
    names = ["{{ .Release.Namespace }}"]
  }
  selectors {
    role = "pod"
    label = "app.kubernetes.io/app=auditor"
  }
}

{{- if .Values.global.envoy.enabled }}
discovery.kubernetes "envoy" {
  role = "pod"
  namespaces {
    names = ["{{ .Release.Namespace }}"]
  }
  selectors {
    role = "pod"
    label = "app.kubernetes.io/app=envoy"
  }
}
{{- end }}

discovery.kubernetes "scalar_admin_for_kubernetes" {
  role = "pod"
  namespaces {
    names = ["{{ .Release.Namespace }}"]
  }
  selectors {
    role = "pod"
    label = "app.kubernetes.io/app=scalar-admin-for-kubernetes"
  }
}

discovery.relabel "replace_label_to_pod_scalardl_auditor" {
  targets = discovery.kubernetes.scalardl_auditor.targets
  rule {
    source_labels = ["__meta_kubernetes_pod_name"]
    action        = "replace"
    target_label  = "pod"
  }
}

{{- if .Values.global.envoy.enabled }}
discovery.relabel "replace_label_to_pod_envoy" {
  targets = discovery.kubernetes.envoy.targets
  rule {
    source_labels = ["__meta_kubernetes_pod_name"]
    action        = "replace"
    target_label  = "pod"
  }
}
{{- end }}

discovery.relabel "replace_label_to_pod_scalar_admin_for_kubernetes" {
  targets = discovery.kubernetes.scalar_admin_for_kubernetes.targets
  rule {
    source_labels = ["__meta_kubernetes_pod_name"]
    action        = "replace"
    target_label  = "pod"
  }
}

loki.source.kubernetes "scalardl_auditor" {
  targets    = discovery.relabel.replace_label_to_pod_scalardl_auditor.output
  forward_to = [loki.relabel.remove_unnecessary_labels.receiver]
}

{{- if .Values.global.envoy.enabled }}
loki.source.kubernetes "envoy" {
  targets    = discovery.relabel.replace_label_to_pod_envoy.output
  forward_to = [loki.relabel.remove_unnecessary_labels.receiver]
}
{{- end }}

loki.source.kubernetes "scalar_admin_for_kubernetes" {
  targets    = discovery.relabel.replace_label_to_pod_scalar_admin_for_kubernetes.output
  forward_to = [loki.relabel.remove_unnecessary_labels.receiver]
}

loki.relabel "remove_unnecessary_labels" {
  forward_to = [loki.write.loki.receiver]
  rule {
    action   = "labelkeep"
    regex    = "pod"
  }
}

loki.write "loki" {
  endpoint {
    url = "http://{{ .Release.Name }}-loki:3100/loki/api/v1/push"
  }
}
{{- end }}
