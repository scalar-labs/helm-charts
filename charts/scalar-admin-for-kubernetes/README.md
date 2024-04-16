# scalar-admin-for-kubernetes

Scalar Admin for Kubernetes
Current chart version is `1.0.0`.

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| fullnameOverride | string | `""` | String to fully override scalar-admin-for-kubernetes.fullname template. |
| nameOverride | string | `""` | String to partially override scalar-admin-for-kubernetes.fullname template (will maintain the release name). |
| scalarAdminForKubernetes.affinity | object | `{}` | The affinity/anti-affinity feature greatly expands the types of constraints you can express. |
| scalarAdminForKubernetes.commandArgs | list | `[]` | Arguments of Scalar Admin for Kubernetes. You can specify several args as an array. |
| scalarAdminForKubernetes.cronJob.schedule | string | `"0 0 * * *"` | Schedule for a CronJob. |
| scalarAdminForKubernetes.cronJob.timeZone | string | `"Etc/UTC"` | A time zone for a CronJob. |
| scalarAdminForKubernetes.image.pullPolicy | string | `"IfNotPresent"` | Specify an image-pulling policy. |
| scalarAdminForKubernetes.image.repository | string | `"ghcr.io/scalar-labs/scalar-admin-for-kubernetes"` | Docker image repository of Scalar Admin for Kubernetes. |
| scalarAdminForKubernetes.image.tag | string | `""` | Override the image tag with a default that is the chart appVersion. |
| scalarAdminForKubernetes.imagePullSecrets | list | `[{"name":"reg-docker-secrets"}]` | Optionally specify an array of imagePullSecrets. Secrets must be manually created in the namespace. |
| scalarAdminForKubernetes.jobType | string | `"job"` | Resource which you deploy. Specify "job" or "cronjob". By default deploy scalar-admin-for-kubernetes as a Job resource. If you specify "cronjob", you can create a CronJob resource instead of a Job. |
| scalarAdminForKubernetes.nodeSelector | object | `{}` | nodeSelector is a form of node selection constraint. |
| scalarAdminForKubernetes.podAnnotations | object | `{}` | Pod annotations for the scalar-admin-for-kubernetes pod. |
| scalarAdminForKubernetes.podSecurityContext | object | `{"seccompProfile":{"type":"RuntimeDefault"}}` | PodSecurityContext holds pod-level security attributes and common container settings. |
| scalarAdminForKubernetes.resources | object | `{}` | Resources allowed to the pod. |
| scalarAdminForKubernetes.securityContext | object | `{"allowPrivilegeEscalation":false,"capabilities":{"drop":["ALL"]},"runAsNonRoot":true}` | Setting security context at the pod applies those settings to all containers in the pod. |
| scalarAdminForKubernetes.securityContext.allowPrivilegeEscalation | bool | `false` | AllowPrivilegeEscalation controls whether a process can gain more privileges than its parent process. |
| scalarAdminForKubernetes.securityContext.capabilities | object | `{"drop":["ALL"]}` | Capabilities (specifically, Linux capabilities), are used for permission management in Linux. Some capabilities are enabled by default. |
| scalarAdminForKubernetes.securityContext.runAsNonRoot | bool | `true` | Containers should be run as a non-root user with the minimum required permissions (principle of least privilege). |
| scalarAdminForKubernetes.serviceAccount.automountServiceAccountToken | bool | `true` | Specify whether to mount a service account token or not. |
| scalarAdminForKubernetes.serviceAccount.serviceAccountName | string | `""` | Name of the existing service account resource. |
| scalarAdminForKubernetes.tls.caRootCertSecret | string | `""` | Name of the secret containing the custom CA root certificate for TLS communication. This chart mounts the root CA certificate file on /tls/certs/ directory. |
| scalarAdminForKubernetes.tolerations | list | `[]` | Tolerations are applied to pods and allow (but do not require) the pods to schedule onto nodes with matching taints. |
| scalarAdminForKubernetes.ttlSecondsAfterFinished | int | `0` | ttlSecondsAfterFinished value for the job resource. |
