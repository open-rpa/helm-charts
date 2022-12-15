# {{- template "var_dump" $.Values }}
{{- define "var_dump" -}}
{{- . | mustToPrettyJson | printf "\nThe JSON output of the dumped var is: \n%s" | fail }}
{{- end -}}

{{- define "name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "fullname" -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

# {{- $replicahosts := include "mongodb.replicahosts" . -}}
# {{- template "var_dump" $replicahosts }}

{{- define "mongodb.replicahosts" -}}
{{- range $mongocount, $e := until (.Values.replicas|int) -}}
{{- $c := $mongocount | int -}}
{{- $c = add1 $c -}}
{{- printf "mongo-%v.mongo:27017" $mongocount -}}
{{- if ne ($.Values.replicas|int) ($c) -}}
{{- printf "," -}}
{{- end -}}
{{- end -}}
{{- end -}}


{{- define "mongodb.extreplicahosts" -}}
{{- range $mongocount, $e := until (.Values.replicas|int) -}}
{{- $c := $mongocount | int -}}
{{- $c = add1 $c -}}
{{- $port := 27017 -}}
{{- if ge (len $.Values.service.external) ($c) -}}
  {{- with (index $.Values.service.external $mongocount) -}}
    {{- $port = .port -}}
  {{- end -}}
{{- end -}}

{{- printf "mongo-%v.%s:%v" $mongocount $.Values.service.domainprefix $port -}}
{{- if ne ($.Values.replicas|int) ($c) -}}
{{- printf "," -}}
{{- end -}}
{{- end -}}
{{- end -}}


{{- define "mongodb.mongodburl" -}}
{{- $replicahosts := include "mongodb.replicahosts" . -}}
{{- if and (eq .Values.auth.enabled true) $.Values.auth.initdb -}}
{{- printf "mongodb://%s:%s@%s/%v?replicaSet=%s" $.Values.auth.username $.Values.auth.password $replicahosts $.Values.auth.initdb $.Values.rsname -}}
{{- else if eq .Values.auth.enabled true -}}
{{- printf "mongodb://%s:%s@%s/?replicaSet=%s" $.Values.auth.adminuser $.Values.auth.adminpass $replicahosts $.Values.rsname -}}
{{- else -}}
{{- printf "mongodb://%s/?replicaSet=%s" $replicahosts $.Values.rsname -}}
{{- end -}}
{{- end -}}



{{- define "mongodb.mongodblocalurl" -}}
{{- $replicahosts := include "mongodb.replicahosts" . -}}
{{- if eq .Values.auth.enabled true  -}}
{{- printf "mongodb://%s:%s@localhost:27017" $.Values.auth.adminuser $.Values.auth.adminpass  -}}
{{- else -}}
{{- printf "mongodb://localhost:27017" -}}
{{- end -}}
{{- end -}}