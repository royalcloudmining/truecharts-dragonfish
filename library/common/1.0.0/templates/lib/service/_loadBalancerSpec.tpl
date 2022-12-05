{{- define "ix.v1.common.class.serivce.loadBalancer.spec" -}}
  {{- $svcValues := .svc -}}
  {{- $root := .root }}
type: LoadBalancer
  {{- with $svcValues.loadBalancerIP }}
loadBalancerIP: {{ . }}
  {{- end -}}
  {{- with $svcValues.loadBalancerSourceRanges }}
loadBalancerSourceRanges:
    {{- range . }}
  - {{ tpl . $root }}
    {{- end }}
  {{- end -}}
  {{- include "ix.v1.common.class.serivce.clusterIP" (dict "svc" $svcValues) | trim | nindent 0 -}}
  {{- include "ix.v1.common.class.serivce.ipFamily" (dict "svc" $svcValues "root" $root) | trim | nindent 0 -}}
  {{- include "ix.v1.common.class.serivce.externalTrafficPolicy" (dict "svc" $svcValues "root" $root) | trim | nindent 0 -}}
{{- end -}}
