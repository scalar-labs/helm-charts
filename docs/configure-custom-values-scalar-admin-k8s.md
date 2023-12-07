# Configure a custom values file for Scalar Admin k8s

This document explains how to create your custom values file for the Scalar Admin k8s chart. For details on the parameters, see the [README](https://github.com/scalar-labs/helm-charts/blob/main/charts/scalar-admin-k8s/README.md) of the Scalar Admin k8s chart.

## Required configurations

This section explains the required configurations when setting up a custom values file for Scalar Admin k8s.

### Flag configurations

You must specify several flags to `scalarAdminK8s.commandArgs` as an array to run Scalar Admin k8s. For more details on the flags, see [README](https://github.com/scalar-labs/scalar-admin-k8s/blob/main/README.md) of Scalar Admin k8s.

```yaml
scalarAdminK8s:
  commandArgs:
    - -r
    - <HELM_RELEASE_NAME>
    - -n
    - <SCALAR_PRODUCT_NAMESPACE>
    - -d
    - <PAUSE_DURATION>
    - -z
    - <TIMEZONE>
```

## Optional configurations

This section explains the optional configurations when setting up a custom values file for Scalar Admin k8s.

### CronJob configurations (optional based on your environment)

By default, the Scalar Admin k8s chart creates a [Job](https://kubernetes.io/docs/concepts/workloads/controllers/job/) resource to run the Scalar Admin k8s CLI tool once. If you want to run the Scalar Admin k8s CLI tool periodically by using [CronJob](https://kubernetes.io/docs/concepts/workloads/controllers/cron-jobs/), you can set `scalarAdminK8s.cronJob.enabled` to `true`. Also, you can set some configurations for the CronJob resource.

```yaml
scalarAdminK8s:
  cronJob:
    enabled: true
    timeZone: "Etc/UTC"
    schedule: "0 0 * * *"
```

### Resource configurations (recommended in production environments)

To control pod resources by using requests and limits in Kubernetes, you can use `scalarAdminK8s.resources`.

You can configure requests and limits by using the same syntax as requests and limits in Kubernetes. For more details on requests and limits in Kubernetes, see [Resource Management for Pods and Containers](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/).

```yaml
scalarAdminK8s:
  resources:
    requests:
      cpu: 1000m
      memory: 2Gi
    limits:
      cpu: 2000m
      memory: 4Gi
```

### SecurityContext configurations (default value is recommended)

To set SecurityContext and PodSecurityContext for Scalar Admin k8s pods, you can use `scalarAdminK8s.securityContext` and `scalarAdminK8s.podSecurityContext`.

You can configure SecurityContext and PodSecurityContext by using the same syntax as SecurityContext and PodSecurityContext in Kubernetes. For more details on the SecurityContext and PodSecurityContext configurations in Kubernetes, see [Configure a Security Context for a Pod or Container](https://kubernetes.io/docs/tasks/configure-pod-container/security-context/).

```yaml
scalarAdminK8s:
  podSecurityContext:
    seccompProfile:
      type: RuntimeDefault
  securityContext:
    capabilities:
      drop:
        - ALL
    runAsNonRoot: true
    allowPrivilegeEscalation: false
```

### Image configurations (default value is recommended)

If you want to change the image repository, you can use `scalarAdminK8s.image.repository` to specify the container repository information of the Scalar Admin k8s image that you want to pull.

```yaml
scalarAdminK8s:
  image:
    repository: <SCALAR_ADMIN_K8S_CONTAINER_IMAGE>
```

### Taint and toleration configurations (optional based on your environment)

If you want to control pod deployment by using taints and tolerations in Kubernetes, you can use `scalarAdminK8s.tolerations`.

You can configure taints and tolerations by using the same syntax as the tolerations in Kubernetes. For details on configuring tolerations in Kubernetes, see the official Kubernetes documentation [Taints and Tolerations](https://kubernetes.io/docs/concepts/scheduling-eviction/taint-and-toleration/).

```yaml
scalarAdminK8s:
  tolerations:
    - effect: NoSchedule
      key: scalar-labs.com/dedicated-node
      operator: Equal
      value: scalardb-analytics-postgresql
```
