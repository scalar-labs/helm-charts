# scalar-admin-for-kubernetes

Scalar Admin k8s
Current chart version is `1.0.0-SNAPSHOT`

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| fullnameOverride | string | `""` | String to fully override scalar-admin-for-kubernetes.fullname template |
| nameOverride | string | `""` | String to partially override scalar-admin-for-kubernetes.fullname template (will maintain the release name) |
| scalarAdminK8s.affinity | object | `{}` | The affinity/anti-affinity feature greatly expands the types of constraints you can express. |
| scalarAdminK8s.commandArgs | list | `[]` | Arguments of Scalar Admin k8s. You can specify several args as array. |
| scalarAdminK8s.cronJob.enabled | bool | `false` | Deploy CronJob resource to run Scalar Admin k8s. Disable (using Job resource) by default. |
| scalarAdminK8s.cronJob.schedule | string | `"0 0 * * *"` | Schedule for a CronJob. |
| scalarAdminK8s.cronJob.timeZone | string | `"Etc/UTC"` | A time zone for a CronJob. |
| scalarAdminK8s.image.pullPolicy | string | `"IfNotPresent"` | Specify an image-pulling policy. |
| scalarAdminK8s.image.repository | string | `"ghcr.io/scalar-labs/scalar-admin-for-kubernetes"` | Docker image repository of Scalar Admin k8s. |
| scalarAdminK8s.image.tag | string | `""` | Override the image tag with a default that is the chart appVersion. |
| scalarAdminK8s.imagePullSecrets | list | `[{"name":"reg-docker-secrets"}]` | Optionally specify an array of imagePullSecrets. Secrets must be manually created in the namespace. |
| scalarAdminK8s.nodeSelector | object | `{}` | nodeSelector is a form of node selection constraint. |
| scalarAdminK8s.podAnnotations | object | `{}` | Pod annotations for the scalar-admin-for-kubernetes pod. |
| scalarAdminK8s.podSecurityContext | object | `{"seccompProfile":{"type":"RuntimeDefault"}}` | PodSecurityContext holds pod-level security attributes and common container settings. |
| scalarAdminK8s.resources | object | `{}` | Resources allowed to the pod. |
| scalarAdminK8s.securityContext | object | `{"allowPrivilegeEscalation":false,"capabilities":{"drop":["ALL"]},"runAsNonRoot":true}` | Setting security context at the pod applies those settings to all containers in the pod. |
| scalarAdminK8s.securityContext.allowPrivilegeEscalation | bool | `false` | AllowPrivilegeEscalation controls whether a process can gain more privileges than its parent process. |
| scalarAdminK8s.securityContext.capabilities | object | `{"drop":["ALL"]}` | Capabilities (specifically, Linux capabilities), are used for permission management in Linux. Some capabilities are enabled by default. |
| scalarAdminK8s.securityContext.runAsNonRoot | bool | `true` | Containers should be run as a non-root user with the minimum required permissions (principle of least privilege). |
| scalarAdminK8s.serviceAccount.automountServiceAccountToken | bool | `true` | Specify whether to mount a service account token or not. |
| scalarAdminK8s.serviceAccount.serviceAccountName | string | `""` | Name of the existing service account resource. |
| scalarAdminK8s.tolerations | list | `[]` | Tolerations are applied to pods and allow (but do not require) the pods to schedule onto nodes with matching taints. |
| scalarAdminK8s.ttlSecondsAfterFinished | int | `0` | ttlSecondsAfterFinished value for the job resource. |
