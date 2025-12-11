{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "scalardb-analytics-server.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "scalardb-analytics-server.fullname" -}}
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
{{- define "scalardb-analytics-server.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "scalardb-analytics-server.labels" -}}
helm.sh/chart: {{ include "scalardb-analytics-server.chart" . }}
{{ include "scalardb-analytics-server.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
scalar-labs.com/app: scalardb-analytics-server
scalar-labs.com/instance: {{ .Release.Name }}
scalar-labs.com/name: {{ include "scalardb-analytics-server.name" . }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "scalardb-analytics-server.selectorLabels" -}}
app.kubernetes.io/name: {{ include "scalardb-analytics-server.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/app: scalardb-analytics-server
{{- end }}
