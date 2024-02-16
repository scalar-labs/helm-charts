# Configure a custom values file for Scalar Admin for Kubernetes

This document explains how to create your custom values file for the Scalar Admin for Kubernetes chart. For details on the parameters, see the [README](https://github.com/scalar-labs/helm-charts/blob/main/charts/scalar-admin-for-kubernetes/README.md) of the Scalar Admin for Kubernetes chart.

## Required configurations

This section explains the required configurations when setting up a custom values file for Scalar Admin for Kubernetes.

### Flag configurations

You must specify several flags to `scalarAdminForKubernetes.commandArgs` as an array to run Scalar Admin for Kubernetes. For more details on the flags, see [README](https://github.com/scalar-labs/scalar-admin-for-kubernetes/blob/main/README.md) of Scalar Admin for Kubernetes.

```yaml
scalarAdminForKubernetes:
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

This section explains the optional configurations when setting up a custom values file for Scalar Admin for Kubernetes.

### CronJob configurations (optional based on your environment)

By default, the Scalar Admin for Kubernetes chart creates a [Job](https://kubernetes.io/docs/concepts/workloads/controllers/job/) resource to run the Scalar Admin for Kubernetes CLI tool once. If you want to run the Scalar Admin for Kubernetes CLI tool periodically by using [CronJob](https://kubernetes.io/docs/concepts/workloads/controllers/cron-jobs/), you can set `scalarAdminForKubernetes.jobType` to `cronjob`. Also, you can set some configurations for the CronJob resource.

```yaml
scalarAdminForKubernetes:
  cronJob:
    timeZone: "Etc/UTC"
    schedule: "0 0 * * *"
```

### Resource configurations (recommended in production environments)

To control pod resources by using requests and limits in Kubernetes, you can use `scalarAdminForKubernetes.resources`.

You can configure requests and limits by using the same syntax as requests and limits in Kubernetes. For more details on requests and limits in Kubernetes, see [Resource Management for Pods and Containers](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/).

```yaml
scalarAdminForKubernetes:
  resources:
    requests:
      cpu: 1000m
      memory: 2Gi
    limits:
      cpu: 2000m
      memory: 4Gi
```

### SecurityContext configurations (default value is recommended)

To set SecurityContext and PodSecurityContext for Scalar Admin for Kubernetes pods, you can use `scalarAdminForKubernetes.securityContext` and `scalarAdminForKubernetes.podSecurityContext`.

You can configure SecurityContext and PodSecurityContext by using the same syntax as SecurityContext and PodSecurityContext in Kubernetes. For more details on the SecurityContext and PodSecurityContext configurations in Kubernetes, see [Configure a Security Context for a Pod or Container](https://kubernetes.io/docs/tasks/configure-pod-container/security-context/).

```yaml
scalarAdminForKubernetes:
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

If you want to change the image repository, you can use `scalarAdminForKubernetes.image.repository` to specify the container repository information of the Scalar Admin for Kubernetes image that you want to pull.

```yaml
scalarAdminForKubernetes:
  image:
    repository: <SCALAR_ADMIN_FOR_KUBERNETES_CONTAINER_IMAGE>
```

### Taint and toleration configurations (optional based on your environment)

If you want to control pod deployment by using taints and tolerations in Kubernetes, you can use `scalarAdminForKubernetes.tolerations`.

You can configure taints and tolerations by using the same syntax as the tolerations in Kubernetes. For details on configuring tolerations in Kubernetes, see the official Kubernetes documentation [Taints and Tolerations](https://kubernetes.io/docs/concepts/scheduling-eviction/taint-and-toleration/).

```yaml
scalarAdminForKubernetes:
  tolerations:
    - effect: NoSchedule
      key: scalar-labs.com/dedicated-node
      operator: Equal
      value: scalardb-analytics-postgresql
```
