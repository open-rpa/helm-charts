# {{- template "var_dump" $.Values -}}
{{- define "var_dump" -}}
{{- . | mustToPrettyJson | printf "\nThe JSON output of the dumped var is: \n%s" | fail }}
{{- end -}}

{{- define "replicahosts" -}}
{{- $cname := default .Chart.Name .Values.nameOverride -}}
{{- $mname := default "mongodb" .Values.mongodb.nameOverride -}}
{{- range $mongocount, $e := until (.Values.mongodb.replicas|int) -}}
{{- $c := $mongocount | int -}}
{{- $c = add1 $c -}}
{{- printf "%v-%v-%v.%v-%v" $cname $mname $mongocount $cname $mname -}}
{{- if ne ($.Values.mongodb.replicas|int) ($c) -}}
{{- printf "," -}}
{{- end -}}
{{- end -}}
{{- end -}}


{{- define "extreplicahosts" -}}
{{- $cname := default .Chart.Name .Values.nameOverride -}}
{{- $mname := default "mongodb" .Values.mongodb.nameOverride -}}
{{- $port := 27017 -}}
{{- range $mongocount, $e := until (.Values.mongodb.replicas|int) -}}
{{- $c := $mongocount | int -}}
{{- $c = add1 $c -}}
{{- if ge (len $.Values.mongodb.service.external) ($c) -}}
  {{- with (index $.Values.mongodb.service.external $mongocount) -}}
    {{- $port = .port -}}
  {{- end -}}
{{- end -}}
{{- if $.Values.mongodb.ingress.enabled -}}
{{- printf "%v-%v-%v.%s:%v" $cname $mname $mongocount $.Values.mongodb.ingress.domainprefix $.Values.mongodb.ingress.externalport -}}
{{- else -}}
{{- printf "%v-%v-%v.%s:%v" $cname $mname $mongocount $.Values.mongodb.service.domainprefix $port -}}
{{- end -}}
{{- if ne ($.Values.mongodb.replicas|int) ($c) -}}
{{- printf "," -}}
{{- end -}}
{{- end -}}
{{- end -}}


{{- define "mongodburl" -}}
{{- $replicahosts := include "replicahosts" . -}}
{{- if and (eq .Values.mongodb.service.enabled true) (ne (len $.Values.mongodb.service.external) 0) -}}
{{- $replicahosts = include "extreplicahosts" . -}}
{{- else if eq .Values.mongodb.ingress.enabled true -}}
{{- $replicahosts = include "extreplicahosts" . -}}
{{- end -}}
{{- if and (eq .Values.mongodb.auth.enabled true) $.Values.mongodb.auth.initdb -}}
{{- printf "mongodb://%s:%s@%s/%v?replicaSet=%s" $.Values.mongodb.auth.username $.Values.mongodb.auth.password $replicahosts $.Values.mongodb.auth.initdb $.Values.mongodb.rsname -}}
{{- else if eq .Values.mongodb.auth.enabled true -}}
{{- printf "mongodb://%s:%s@%s/?replicaSet=%s" $.Values.mongodb.auth.adminuser $.Values.mongodb.auth.adminpass $replicahosts $.Values.mongodb.rsname -}}
{{- else -}}
{{- printf "mongodb://%s/?replicaSet=%s" $replicahosts $.Values.mongodb.rsname -}}
{{- end -}}
{{- if eq .Values.mongodb.tls.enabled true -}}
{{- printf "&tls=true" -}}
{{- end -}}
{{- end -}}
