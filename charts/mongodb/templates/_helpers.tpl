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

# {{- $mongourl := include "mongourl" . -}}
# {{- template "var_dump" $mongourl }}

{{- define "replicahosts" -}}
{{- range $mongocount, $e := until (.Values.replicas|int) -}}
{{- $c := $mongocount | int -}}
{{- $c = add1 $c -}}
{{- printf "mongo-%v.mongo:27017" $mongocount -}}
{{- if ne ($.Values.replicas|int) ($c) -}}
{{- printf "," -}}
{{- end -}}
{{- end -}}
{{- end -}}


{{- define "extreplicahosts" -}}
{{- range $mongocount, $e := until (.Values.replicas|int) -}}
{{- $c := $mongocount | int -}}
{{- $c = add1 $c -}}
{{- printf "mongo-%v.%s:27017" $mongocount $.Values.service.domainprefix -}}
{{- if ne ($.Values.replicas|int) ($c) -}}
{{- printf "," -}}
{{- end -}}
{{- end -}}
{{- end -}}
