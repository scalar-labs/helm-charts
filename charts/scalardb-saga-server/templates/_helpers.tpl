{{/*
Expand the name of the chart.
*/}}
{{- define "scalardb-saga-server.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "scalardb-saga-server.fullname" -}}
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
{{- define "scalardb-saga-server.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "scalardb-saga-server.labels" -}}
helm.sh/chart: {{ include "scalardb-saga-server.chart" . }}
{{ include "scalardb-saga-server.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
scalar-labs.com/app: scalardb-saga-server
{{- end }}

{{/*
Selector labels
*/}}
{{- define "scalardb-saga-server.selectorLabels" -}}
app.kubernetes.io/name: {{ include "scalardb-saga-server.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "scalardb-saga-server.serviceAccountName" -}}
{{- if .Values.scalarDbSagaServer.serviceAccount.create }}
{{- default (include "scalardb-saga-server.fullname" .) .Values.scalarDbSagaServer.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.scalarDbSagaServer.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Convert a nested map into Java .properties lines ("a.b.c=value").
Keys are joined with ".", nested maps are walked recursively and
map keys are rendered in alphabetical order.
Usage: include "scalardb-saga-server.toProperties" (dict "prefix" "" "values" .Values.scalarDbSagaServer.properties)
*/}}
{{- define "scalardb-saga-server.toProperties" -}}
{{- $prefix := .prefix -}}
{{- range $key, $value := .values -}}
{{- $name := $key -}}
{{- if $prefix -}}
{{- $name = printf "%s.%s" $prefix $key -}}
{{- end -}}
{{- if kindIs "map" $value -}}
{{- include "scalardb-saga-server.toProperties" (dict "prefix" $name "values" $value) -}}
{{- else -}}
{{ $name }}={{ $value }}
{{ end -}}
{{- end -}}
{{- end }}

{{- define "scalardb-saga-server.properties" -}}
{{- include "scalardb-saga-server.toProperties" (dict "prefix" "" "values" .Values.scalarDbSagaServer.properties) -}}
{{- end }}

{{/*
Validate the shape of the properties tree before it is rendered by "toProperties".

Keys: fail if any key of a nested map contains a "." so that the properties are always
written in nested form. A dotted key is rendered as is, which makes it possible to
set the same property twice (once nested and once dotted) without any error, and
the chart itself reads settings such as the TLS flag only from the nested form.

Leaf values: fail on the shapes that "toProperties" would write out verbatim and that
java.util.Properties then reads as something else than the author wrote. Each of them
renders without any error and produces a valid ConfigMap, so without this check the
corruption is only visible once the server reads the file.
Usage: include "scalardb-saga-server.validateNestedKeys" (dict "prefix" "" "values" .Values.scalarDbSagaServer.properties)
*/}}
{{- define "scalardb-saga-server.validateNestedKeys" -}}
{{- $prefix := .prefix -}}
{{- range $key, $value := .values -}}
{{- $name := $key -}}
{{- if $prefix -}}
{{- $name = printf "%s.%s" $prefix $key -}}
{{- end -}}
{{- if contains "." $key -}}
{{- fail (printf "ScalarDB Saga Server: \"scalarDbSagaServer.properties\" must be written in nested form, but the key \"%s\" contains a \".\". Write \"scalar.db.storage: jdbc\" as \"scalar: {db: {storage: jdbc}}\" instead." $name) -}}
{{- end -}}
{{- if kindIs "map" $value -}}
{{- include "scalardb-saga-server.validateNestedKeys" (dict "prefix" $name "values" $value) -}}
{{- else -}}
{{- if kindIs "slice" $value -}}
{{- fail (printf "ScalarDB Saga Server: the value of \"scalarDbSagaServer.properties\" key \"%s\" is a list, which is written to server.properties as \"[a b]\". Write it as a single string instead." $name) -}}
{{- end -}}
{{- if contains "\n" ($value | toString) -}}
{{- fail (printf "ScalarDB Saga Server: the value of \"scalarDbSagaServer.properties\" key \"%s\" contains a newline. server.properties is a line-based format, so the part after the newline is read as a separate property." $name) -}}
{{- end -}}
{{- if hasSuffix "\\" ($value | toString) -}}
{{- fail (printf "ScalarDB Saga Server: the value of \"scalarDbSagaServer.properties\" key \"%s\" ends with a backslash, which continues the line in server.properties and swallows the property written after it." $name) -}}
{{- end -}}
{{- end -}}
{{- end -}}
{{- end }}

{{/*
Read the TLS flag of the server out of the properties tree. This is the single place that knows
where the flag lives, so that the probe scheme in the Deployment and the TLS validation cannot
disagree. "dig" is used so that an incomplete or explicitly nulled "properties" tree does not break
the templates.

IMPORTANT: a named template always returns a string, so a false flag comes back as the string
"false", which is NOT falsy in a template condition. Every caller must compare the result to "true":

  {{- $tlsEnabled := eq (include "scalardb-saga-server.tlsEnabled" .) "true" }}

Never pass the include itself to "if" or to "ternary". An "if" would always take the true branch,
and "ternary" needs a real bool and fails with "wrong type for value; expected bool; got string".
*/}}
{{- define "scalardb-saga-server.tlsEnabled" -}}
{{- dig "scalar" "db" "saga" "server" "tls" "enabled" false (.Values.scalarDbSagaServer.properties | default dict) -}}
{{- end }}
