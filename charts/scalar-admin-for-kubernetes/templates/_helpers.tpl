{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "scalar-admin-for-kubernetes.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "scalar-admin-for-kubernetes.fullname" -}}
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
{{- define "scalar-admin-for-kubernetes.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "scalar-admin-for-kubernetes.labels" -}}
helm.sh/chart: {{ include "scalar-admin-for-kubernetes.chart" . }}
{{ include "scalar-admin-for-kubernetes.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "scalar-admin-for-kubernetes.selectorLabels" -}}
app.kubernetes.io/name: {{ include "scalar-admin-for-kubernetes.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/app: scalar-admin-for-kubernetes
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "scalar-admin-for-kubernetes.serviceAccountName" -}}
{{- if .Values.scalarAdminK8s.serviceAccount.serviceAccountName }}
{{- .Values.scalarAdminK8s.serviceAccount.serviceAccountName }}
{{- else }}
{{- print (include "scalar-admin-for-kubernetes.fullname" .) "-sa" | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
