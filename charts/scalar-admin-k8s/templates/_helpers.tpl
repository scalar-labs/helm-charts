{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "scalar-admin-k8s.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "scalar-admin-k8s.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "scalar-admin-k8s.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "scalar-admin-k8s.labels" -}}
helm.sh/chart: {{ include "scalar-admin-k8s.chart" . }}
{{ include "scalar-admin-k8s.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "scalar-admin-k8s.selectorLabels" -}}
app.kubernetes.io/name: {{ include "scalar-admin-k8s.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/app: scalar-admin-k8s
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "scalar-admin-k8s.serviceAccountName" -}}
{{- if .Values.scalarAdminK8s.serviceAccount.serviceAccountName }}
{{- .Values.scalarAdminK8s.serviceAccount.serviceAccountName }}
{{- else }}
{{- print (include "scalar-admin-k8s.fullname" .) "-sa" | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
