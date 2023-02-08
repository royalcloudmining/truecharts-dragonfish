{{/*
This template serves as a blueprint for horizontal pod autoscaler objects that are created
using the common library.
*/}}
{{- define "tc.v1.common.class.hpa" -}}
  {{- $targetName := include "ix.v1.common.names.fullname" . -}}
  {{- $fullName := include "ix.v1.common.names.fullname" . -}}
  {{- $hpaName := $fullName -}}
  {{- $values := .Values.hpa -}}

  {{- if hasKey . "ObjectValues" -}}
    {{- with .ObjectValues.hpa -}}
      {{- $values = . -}}
    {{- end -}}
  {{- end -}}
  {{- $hpaLabels := $values.labels -}}
  {{- $hpaAnnotations := $values.annotations -}}

  {{- if and (hasKey $values "nameOverride") $values.nameOverride -}}
    {{- $hpaName = printf "%v-%v" $hpaName $values.nameOverride -}}
  {{- end }}
---
apiVersion: {{ include "tc.v1.common.capabilities.hpa.apiVersion" $ }}
kind: HorizontalPodAutoscaler
metadata:
  name: {{ $hpaName }}
  {{- $labels := (mustMerge ($hpaLabels | default dict) (include "ix.v1.common.labels" $ | fromYaml)) -}}
  {{- with (include "ix.v1.common.util.labels.render" (dict "root" $ "labels" $labels) | trim) }}
  labels:
    {{- . | nindent 4 }}
  {{- end -}}
  {{- $annotations := (mustMerge ($hpaAnnotations | default dict) (include "ix.v1.common.annotations" $ | fromYaml)) -}}
  {{- with (include "ix.v1.common.util.annotations.render" (dict "root" $ "annotations" $annotations) | trim) }}
  annotations:
    {{- . | nindent 4 }}
  {{- end -}}
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: {{ $values.targetKind | default ( include "ix.v1.common.names.controllerType" . ) }}
    name: {{ $values.target | default $targetName }}
  minReplicas: {{ $values.minReplicas | default 1 }}
  maxReplicas: {{ $values.maxReplicas | default 3 }}
  metrics:
    {{- if $values.targetCPUUtilizationPercentage }}
    - type: Resource
      resource:
        name: cpu
        targetAverageUtilization: {{ $values.targetCPUUtilizationPercentage }}
    {{- end -}}
    {{- if $values.targetMemoryUtilizationPercentage }}
    - type: Resource
      resource:
        name: memory
        targetAverageUtilization: {{ $values.targetMemoryUtilizationPercentage }}
    {{- end -}}
{{- end -}}