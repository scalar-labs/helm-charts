# Configure a custom values file for Scalar Manager

This document explains how to create your custom values file for the Scalar Manager chart. If you want to know the details of the parameters, please refer to the [README](https://github.com/scalar-labs/helm-charts/blob/main/charts/scalar-manager/README.md) of the Scalar Manager chart.

## Required configurations

### Service configurations

You must set `service.type` to specify the Service resource type of Kubernetes. If you want to use a load balancer provided by could providers, you need to set `service.type` to `LoadBalancer`.

```yaml
service:
  type: LoadBalancer
```

### Image configurations

You must set `image.repository` and `image.tag`. Please specify the container repository information that you pull the Scalar Manager container image.

```yaml
image:
  repository: <Container image of Scalar Manager>
  tag: <Tag of image>
```

### Targets configurations

You must set `scalarManager.targets`. Please set the DNS Service URL that returns the SRV record of pods. Kubernetes creates this URL for the named port of the headless service of the Scalar product. The format is `_{port name}._{protocol}.{service name}.{namespace}.svc.{cluster domain name}`.

```yaml
scalarManager:
  targets: 
    - name: Ledger
      adminSrv: _scalardl-admin._tcp.scalardl-headless.default.svc.cluster.local
      databaseType: cassandra
    - name: Auditor
      adminSrv: _scalardl-auditor-admin._tcp.scalardl-auditor-headless.default.svc.cluster.local
      databaseType: cassandra
```

### Grafana configurations

You must set the `scalarManager.grafanaUrl`. Please specify your Grafana URL.

```yaml
scalarManager:
  grafanaUrl: "http://localhost:3000"
```

## Optional configurations

### Replica configurations (Optional based on your environment)

You can specify the number of replicas (pods) of Scalar Manager using `replicaCount`.

```yaml
replicaCount: 3
```

### Refresh interval configurations (Optional based on your environment)

You can specify the refresh interval that Scalar Manager checks the status of the products using `scalarManager.refreshInterval`.

```yaml
scalarManager:
  refreshInterval: 30
```
