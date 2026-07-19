{{/*
Expand the name of the chart.
*/}}
{{- define "streampark.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
*/}}
{{- define "streampark.fullname" -}}
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
Chart label value.
*/}}
{{- define "streampark.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels.
*/}}
{{- define "streampark.labels" -}}
helm.sh/chart: {{ include "streampark.chart" . }}
{{ include "streampark.selectorLabels" . }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels.
*/}}
{{- define "streampark.selectorLabels" -}}
app.kubernetes.io/name: {{ include "streampark.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
ServiceAccount name.
*/}}
{{- define "streampark.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "streampark.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Database dialect — maps values "postgresql" to the image's expected "pgsql".
*/}}
{{- define "streampark.dbDialect" -}}
{{- if eq .Values.database.dialect "postgresql" }}pgsql{{- else }}{{ .Values.database.dialect }}{{- end }}
{{- end }}

{{/*
JDBC URL constructed from host, db, and dialect.
*/}}
{{- define "streampark.jdbcUrl" -}}
{{- if eq .Values.database.dialect "mysql" -}}
jdbc:mysql://{{ .Values.database.host }}/{{ .Values.database.database }}?useSSL=false&useUnicode=true&characterEncoding=UTF-8&allowPublicKeyRetrieval=false&useJDBCCompliantTimezoneShift=true&useLegacyDatetimeCode=false&serverTimezone=GMT%2B8
{{- else if eq .Values.database.dialect "postgresql" -}}
jdbc:postgresql://{{ .Values.database.host }}/{{ .Values.database.database }}?stringtype=unspecified
{{- end -}}
{{- end }}
