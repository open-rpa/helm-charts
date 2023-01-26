# {{- template "var_dump" $.Values }}
{{- define "var_dump" -}}
{{- . | mustToPrettyJson | printf "\nThe JSON output of the dumped var is: \n%s" | fail }}
{{- end -}}

{{- define "common.name" -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if ne .Release.Name $name -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s" $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{- define "common.arbitername" -}}
{{- $name := include "common.name" . -}}
{{- printf "%s-arbiter" $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "common.snapname" -}}
{{- $name := include "common.name" . -}}
{{- printf "%s-snap" $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

# {{- $replicahosts := include "mongodb.replicahosts" . -}}
# {{- template "var_dump" $replicahosts }}

{{- define "mongodb.replicahosts" -}}
{{- $name := include "common.name" . -}}
{{- range $mongocount, $e := until (.Values.replicas|int) -}}
{{- $c := $mongocount | int -}}
{{- $c = add1 $c -}}
{{- printf "%v-%v.%v:27017" $name $mongocount $name -}}
{{- if ne ($.Values.replicas|int) ($c) -}}
{{- printf "," -}}
{{- end -}}
{{- end -}}
{{- end -}}


{{- define "mongodb.extreplicahosts" -}}
{{- $name := include "common.name" . -}}
{{- range $mongocount, $e := until (.Values.replicas|int) -}}
{{- $c := $mongocount | int -}}
{{- $c = add1 $c -}}
{{- $port := 27017 -}}
{{- if ge (len $.Values.service.external) ($c) -}}
  {{- with (index $.Values.service.external $mongocount) -}}
    {{- $port = .port -}}
  {{- end -}}
{{- end -}}
{{- if $.Values.ingress.enabled -}}
{{- printf "%v-%v.%s:%v" $name $mongocount $.Values.ingress.domainprefix $.Values.ingress.externalport -}}
{{- else -}}
{{- printf "%v-%v.%s:%v" $name $mongocount $.Values.service.domainprefix $port -}}
{{- end -}}
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
{{- if eq .Values.tls.enabled true -}}
{{- printf "&tls=true" -}}
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