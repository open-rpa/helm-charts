# {{- template "var_dump" $.Values -}}
{{- define "var_dump" -}}
{{- . | mustToPrettyJson | printf "\nThe JSON output of the dumped var is: \n%s" | fail }}
{{- end -}}

{{- define "replicahosts" -}}
{{- range $mongocount, $e := until (.Values.mongodb.replicas|int) -}}
{{- $c := $mongocount | int -}}
{{- $c = add1 $c -}}
{{- printf "mongo-%v.mongo:27017" $mongocount -}}
{{- if ne ($.Values.mongodb.replicas|int) ($c) -}}
{{- printf "," -}}
{{- end -}}
{{- end -}}
{{- end -}}


{{- define "extreplicahosts" -}}
{{- range $mongocount, $e := until (.Values.mongodb.replicas|int) -}}
{{- $c := $mongocount | int -}}
{{- $c = add1 $c -}}
{{- $port := 27017 -}}
{{- if ge (len $.Values.mongodb.service.external) ($c) -}}
  {{- with (index $.Values.mongodb.service.external $mongocount) -}}
    {{- $port = .port -}}
  {{- end -}}
{{- end -}}
{{- if $.Values.mongodb.ingress.enabled -}}
{{- printf "mongo-%v.%s:%v" $mongocount $.Values.mongodb.ingress.domainprefix $.Values.mongodb.ingress.externalport -}}
{{- else -}}
{{- printf "mongo-%v.%s:%v" $mongocount $.Values.mongodb.service.domainprefix $port -}}
{{- end -}}
{{- if ne ($.Values.mongodb.replicas|int) ($c) -}}
{{- printf "," -}}
{{- end -}}
{{- end -}}
{{- end -}}


{{- define "mongodburl" -}}
{{- $replicahosts := include "replicahosts" . -}}
{{- if and (eq .Values.mongodb.auth.enabled true) $.Values.mongodb.auth.initdb -}}
{{- printf "mongodb://%s:%s@%s/%v?replicaSet=%s" $.Values.mongodb.auth.username $.Values.mongodb.auth.password $replicahosts $.Values.mongodb.auth.initdb $.Values.mongodb.rsname -}}
{{- else if eq .Values.mongodb.auth.enabled true -}}
{{- printf "mongodb://%s:%s@%s/?replicaSet=%s" $.Values.mongodb.auth.adminuser $.Values.mongodb.auth.adminpass $replicahosts $.Values.mongodb.rsname -}}
{{- else -}}
{{- printf "mongodb://%s/?replicaSet=%s" $replicahosts $.Values.mongodb.rsname -}}
{{- end -}}
{{- end -}}
