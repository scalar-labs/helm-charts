# Configure a custom values file for ScalarDB GraphQL

This document explains how to create your custom values file for the ScalarDB GraphQL chart. If you want to know the details of the parameters, please refer to the [README](https://github.com/scalar-labs/helm-charts/blob/main/charts/scalardb-graphql/README.md) of the ScalarDB GraphQL chart.

## Required configurations

### Ingress configuration

You must set `ingress` to listen the client requests. When you deploy multiple GraphQL servers, session affinity is required to handle transactions properly. This is because GraphQL servers keep the transactions in memory, so GraphQL queries that use continued transactions must be routed to the same server that started the transaction.

For example, if you use NGINX Ingress Controller, you can set ingress configurations as follows.

```yaml
ingress:
  enabled: true
  className: nginx
  annotations:
    nginx.ingress.kubernetes.io/session-cookie-path: /
    nginx.ingress.kubernetes.io/affinity: cookie
    nginx.ingress.kubernetes.io/session-cookie-name: INGRESSCOOKIE
    nginx.ingress.kubernetes.io/session-cookie-hash: sha1
    nginx.ingress.kubernetes.io/session-cookie-max-age: "300"
  hosts:
    - host: ""
      paths:
        - path: /graphql
          pathType: Exact
```

If you use ALB of AWS, you can set ingress configurations as follows.

```yaml
ingress:
  enabled: true
  className: alb
  annotations:
    alb.ingress.kubernetes.io/scheme: internal
    alb.ingress.kubernetes.io/target-group-attributes: stickiness.enabled=true,stickiness.lb_cookie.duration_seconds=60
    alb.ingress.kubernetes.io/target-type: ip
    alb.ingress.kubernetes.io/healthcheck-path: /graphql?query=%7B__typename%7D
  hosts:
    - host: ""
      paths:
        - path: /graphql
          pathType: Exact
```

### Image configurations

You must set `image.repository` and `image.tag`. Please specify the container repository information that you pull the ScalarDB GraphQL container image.

```yaml
image:
  repository: <Container image of ScalarDB GraphQL>
  tag: <Tag of image>
```

If you use AWS/Azure Marketplace, please refer to the following documents for more details.

* [How to install Scalar products through AWS Marketplace](https://github.com/scalar-labs/scalar-kubernetes/blob/master/docs/AwsMarketplaceGuide.md)
* [How to install Scalar products through Azure Marketplace](https://github.com/scalar-labs/scalar-kubernetes/blob/master/docs/AzureMarketplaceGuide.md)

### Database configurations

You must set `scalarDbGraphQlConfiguration`.

If you use ScalarDB Server with ScalarDB GraphQL (recommended), you must set the configuration to access the ScalarDB Server pods.

```yaml
scalarDbGraphQlConfiguration:
  contactPoints: <ScalarDB Server host>
  contactPort: 60051
  storage: "grpc"
  transactionManager: "grpc"
  namespaces: <Schema name includes tables>
```

## Optional configurations

### Resource configurations (Recommended in the production environment)

If you want to control pod resources using the requests and limits of Kubernetes, you can use `resources`.

Note that the resources for one pod of Scalar products are limited to 2vCPU / 4GB memory from the perspective of the commercial license. Also, when you get the pay-as-you-go containers provided from AWS Marketplace, you cannot run those containers with more than 2vCPU / 4GB memory configuration in the `resources.limits`. When you exceed this limitation, pods are automatically stopped.

You can configure them using the same syntax as the requests and limits of Kubernetes. So, please refer to the official document [Resource Management for Pods and Containers](https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/) for more details on the requests and limits of Kubernetes.

```yaml
resources:
  requests:
    cpu: 2000m
    memory: 4Gi
  limits:
    cpu: 2000m
    memory: 4Gi
```

### Affinity configurations (Recommended in the production environment)

If you want to control pod deployment using the affinity and anti-affinity of Kubernetes, you can use `affinity`.

You can configure them using the same syntax as the affinity of Kubernetes. So, please refer to the official document [Assigning Pods to Nodes](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/) for more details on the affinity configuration of Kubernetes.

```yaml
affinity:
  nodeAffinity:
    requiredDuringSchedulingIgnoredDuringExecution:
      nodeSelectorTerms:
        - matchExpressions:
            - key: scalar-labs.com/dedicated-node
              operator: In
              values:
                - scalardb
  podAntiAffinity:
    requiredDuringSchedulingIgnoredDuringExecution:
      - labelSelector:
          matchExpressions:
            - key: app.kubernetes.io/app
              operator: In
              values:
                - scalardb-graphql
        topologyKey: kubernetes.io/hostname
```

### Taints/Tolerations configurations (Recommended in the production environment)

If you want to control pod deployment using the taints and tolerations of Kubernetes, you can use `tolerations`.

You can configure them using the same syntax as the tolerations of Kubernetes. So, please refer to the official document [Taints and Tolerations](https://kubernetes.io/docs/concepts/scheduling-eviction/taint-and-toleration/) for more details on the tolerations configuration of Kubernetes.

```yaml
tolerations:
  - effect: NoSchedule
    key: scalar-labs.com/dedicated-node
    operator: Equal
    value: scalardb
```

### Prometheus/Grafana configurations (Recommended in the production environment)

If you want to monitor ScalarDB GraphQL pods using [kube-prometheus-stack](https://github.com/prometheus-community/helm-charts/tree/main/charts/kube-prometheus-stack), you can deploy a ConfigMap, a ServiceMonitor, and a PrometheusRule resource for kube-prometheus-stack using `grafanaDashboard.enabled`, `serviceMonitor.enabled`, and `prometheusRule.enabled`.

```yaml
grafanaDashboard:
  enabled: true
  namespace: monitoring
serviceMonitor:
  enabled: true
  namespace: monitoring
  interval: 15s
prometheusRule:
  enabled: true
  namespace: monitoring
```

### SecurityContext configurations (Default value is recommended)

If you want to set SecurityContext and PodSecurityContext for ScalarDB GraphQL pods, you can use `securityContext` and `podSecurityContext`.

You can configure them using the same syntax as SecurityContext and PodSecurityContext of Kubernetes. So, please refer to the official document [Configure a Security Context for a Pod or Container](https://kubernetes.io/docs/tasks/configure-pod-container/security-context/) for more details on the SecurityContext and PodSecurityContext configurations of Kubernetes.

```yaml
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

### GraphQL Server configurations (Optional based on your environment)

If you want to change the path to run the graphql queries, you can use `scalarDbGraphQlConfiguration.path`. By default, you can run the graphql queries using `http://<FQDN of ingress>:80/graphql`.

You can also enable/disable [GraphiQL](https://github.com/graphql/graphiql/tree/main/packages/graphiql) using `scalarDbGraphQlConfiguration.graphiql`.

```yaml
scalarDbGraphQlConfiguration:
  path: /graphql
  graphiql: "true"
```

### TLS configurations (Optional based on your environment)

If you want to use TLS between the client and the ingress, you can use `ingress.tls`.

You must create a Secret resource that includes a secret key and a certificate file. Please refer to the official document [Ingress - TLS](https://kubernetes.io/docs/concepts/services-networking/ingress/#tls) for more details on the Secret resource for Ingress.

```yaml
ingress:
  tls:
    - hosts:
        - foo.example.com
        - bar.example.com
        - bax.example.com
      secretName: graphql-ingress-tls
```

### Replica configurations (Optional based on your environment)

You can specify the number of replicas (pods) of ScalarDB GraphQL using `replicaCount`.

```yaml
replicaCount: 3
```

### Logging configurations (Optional based on your environment)

If you want to change the log level of ScalarDB GraphQL, you can use `scalarDbGraphQlConfiguration.logLevel`.

```yaml
scalarDbGraphQlConfiguration:
  logLevel: INFO
```
