{{/*
Expand the name of the chart.
*/}}
{{- define "gatebear.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
*/}}
{{- define "gatebear.fullname" -}}
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
{{- define "gatebear.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "gatebear.labels" -}}
helm.sh/chart: {{ include "gatebear.chart" . }}
{{ include "gatebear.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "gatebear.selectorLabels" -}}
app.kubernetes.io/name: {{ include "gatebear.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "gatebear.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "gatebear.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Frontend specific helpers
*/}}
{{- define "gatebear.frontend.fullname" -}}
{{- printf "%s-frontend" (include "gatebear.fullname" .) | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "gatebear.frontend.labels" -}}
{{ include "gatebear.labels" . }}
app.kubernetes.io/component: frontend
{{- end }}

{{- define "gatebear.frontend.selectorLabels" -}}
{{ include "gatebear.selectorLabels" . }}
app.kubernetes.io/component: frontend
{{- end }}

{{/*
Backend specific helpers
*/}}
{{- define "gatebear.backend.fullname" -}}
{{- printf "%s-backend" (include "gatebear.fullname" .) | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "gatebear.backend.labels" -}}
{{ include "gatebear.labels" . }}
app.kubernetes.io/component: backend
{{- end }}

{{- define "gatebear.backend.selectorLabels" -}}
{{ include "gatebear.selectorLabels" . }}
app.kubernetes.io/component: backend
{{- end }}

{{/*
AI Backend specific helpers
*/}}
{{- define "gatebear.aiBackend.fullname" -}}
{{- printf "%s-ai-backend" (include "gatebear.fullname" .) | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "gatebear.aiBackend.labels" -}}
{{ include "gatebear.labels" . }}
app.kubernetes.io/component: ai-backend
{{- end }}

{{- define "gatebear.aiBackend.selectorLabels" -}}
{{ include "gatebear.selectorLabels" . }}
app.kubernetes.io/component: ai-backend
{{- end }}

{{/*
MongoDB specific helpers
*/}}
{{- define "gatebear.mongodb.fullname" -}}
{{- printf "%s-mongodb" (include "gatebear.fullname" .) | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "gatebear.mongodb.labels" -}}
{{ include "gatebear.labels" . }}
app.kubernetes.io/component: mongodb
{{- end }}

{{- define "gatebear.mongodb.selectorLabels" -}}
{{ include "gatebear.selectorLabels" . }}
app.kubernetes.io/component: mongodb
{{- end }}

{{/*
Qdrant specific helpers
*/}}
{{- define "gatebear.qdrant.fullname" -}}
{{- printf "%s-qdrant" (include "gatebear.fullname" .) | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "gatebear.qdrant.labels" -}}
{{ include "gatebear.labels" . }}
app.kubernetes.io/component: qdrant
{{- end }}

{{- define "gatebear.qdrant.selectorLabels" -}}
{{ include "gatebear.selectorLabels" . }}
app.kubernetes.io/component: qdrant
{{- end }}

{{/*
Redis specific helpers
*/}}
{{- define "gatebear.redis.fullname" -}}
{{- printf "%s-redis" (include "gatebear.fullname" .) | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "gatebear.redis.labels" -}}
{{ include "gatebear.labels" . }}
app.kubernetes.io/component: redis
{{- end }}

{{- define "gatebear.redis.selectorLabels" -}}
{{ include "gatebear.selectorLabels" . }}
app.kubernetes.io/component: redis
{{- end }}
