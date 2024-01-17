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
Create the name of the service account to use.
*/}}
{{- define "scalar-admin-for-kubernetes.serviceAccountName" -}}
{{- if .Values.scalarAdminForKubernetes.serviceAccount.serviceAccountName }}
{{- .Values.scalarAdminForKubernetes.serviceAccount.serviceAccountName }}
{{- else }}
{{- print (include "scalar-admin-for-kubernetes.fullname" .) "-sa" | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}

{{/*
Job template for "Job" and "CronJob" resources
*/}}
{{- define "job-spec" -}}
backoffLimit: 0
{{- if .Values.scalarAdminForKubernetes.ttlSecondsAfterFinished }}
ttlSecondsAfterFinished: {{ .Values.scalarAdminForKubernetes.ttlSecondsAfterFinished }}
{{- end }}
template:
  metadata:
    {{- if .Values.scalarAdminForKubernetes.podAnnotations }}
    annotations:
      {{- toYaml .Values.scalarAdminForKubernetes.podAnnotations | nindent 8 }}
    {{- end }}
    labels:
      {{- include "scalar-admin-for-kubernetes.selectorLabels" . | nindent 8 }}
  spec:
    restartPolicy: Never
    serviceAccountName: {{ include "scalar-admin-for-kubernetes.serviceAccountName" . }}
    automountServiceAccountToken: {{ .Values.scalarAdminForKubernetes.serviceAccount.automountServiceAccountToken }}
    {{- with .Values.scalarAdminForKubernetes.imagePullSecrets }}
    imagePullSecrets:
      {{- toYaml . | nindent 8 }}
    {{- end }}
    securityContext:
      {{- toYaml .Values.scalarAdminForKubernetes.podSecurityContext | nindent 8 }}
    containers:
      - name: {{ .Chart.Name }}
        securityContext:
          {{- toYaml .Values.scalarAdminForKubernetes.securityContext | nindent 12 }}
        image: "{{ .Values.scalarAdminForKubernetes.image.repository }}:{{ .Values.scalarAdminForKubernetes.image.tag | default .Chart.AppVersion }}"
        imagePullPolicy: {{ .Values.scalarAdminForKubernetes.image.pullPolicy }}
        resources:
          {{- toYaml .Values.scalarAdminForKubernetes.resources | nindent 12 }}
        args:
          {{- range .Values.scalarAdminForKubernetes.commandArgs }}
          - {{ . | quote }}
          {{- end }}
    {{- with .Values.scalarAdminForKubernetes.nodeSelector }}
    nodeSelector:
      {{- toYaml . | nindent 8 }}
    {{- end }}
    {{- with .Values.scalarAdminForKubernetes.affinity }}
    affinity:
      {{- toYaml . | nindent 8 }}
    {{- end }}
    {{- with .Values.scalarAdminForKubernetes.tolerations }}
    tolerations:
      {{- toYaml . | nindent 8 }}
    {{- end }}
{{- end }}
