# Getting Started with Helm Charts (Logging using Loki Stack)

This document explains how to get started with log aggregation for Scalar products on Kubernetes using Grafana Loki (with Promtail).

We assume that you already read the [getting-started](./getting-started-monitoring.md) for monitoring Scalar products and installed kube-prometheus-stack.

## Environment

We will create the `loki-stack` part of the following figure.

```
+--------------------------------------------------------------------------------------------------+
| +------------------------------------+                                                           |
| |             loki-stack             |                                                           |
| |                                    |                                       +-----------------+ |
| | +--------------+  +--------------+ | ---------------------(Logging)------> | Scalar Products | |
| | |     Loki     |  |   Promtail   | |                                       |                 | |
| | +--------------+  +--------------+ |                                       |  +-----------+  | |
| +------------------------------------+                                       |  | Scalar DB |  | |
|                                                                              |  +-----------+  | |
| +------------------------------------------------------+                     |                 | |
| |                kube-prometheus-stack                 |                     |  +-----------+  | |
| |                                                      |                     |  | Scalar DL |  | |
| | +--------------+  +--------------+  +--------------+ | ---(Monitoring)---> |  +-----------+  | |
| | |  Prometheus  |  | Alertmanager |  |   Grafana    | |                     +-----------------+ |
| | +-------+------+  +------+-------+  +------+-------+ |                                         |
| |         |                |                 |         |                                         |
| |         +----------------+-----------------+         |                                         |
| |                          |                           |                                         |
| +--------------------------+---------------------------+                                         |
|                            |                                                                     |
|                            |         Kubernetes (minikube)                                       |
+----------------------------+---------------------------------------------------------------------+
                             | <- expose to localhost (127.0.0.1)
                             |
              (Access Dashboard through HTTP)
                             |
                        +----+----+
                        | Browser |
                        +---------+
```

## Step 1. Prepare a custom values file

1. Get the sample file [scalar-loki-stack-custom-values.yaml](./conf/scalar-loki-stack-custom-values.yaml) for `loki-stack`.

## Step 2. Deploy `loki-stack`

1. Add the `grafana` helm repository.
   ```console
   helm repo add grafana https://grafana.github.io/helm-charts
   ```

1. Deploy the `loki-stack`.
   ```console
   helm install scalar-logging-loki grafana/loki-stack -n monitoring -f scalar-loki-stack-custom-values.yaml
   ```

## Step 3. Access Dashboards

1. Access log browser
   - Go to Grafana http://localhost:3000
   - Move to `Configuration` and choose `Data Sources`
   - Click `Add data source`
   - Select `Loki`
   - Input `http://scalar-logging-loki:3100` to URL
   - Click `Save and test`
   - Go to `Explore` to find the added Loki

## Step 4. Delete `loki-stack`

1. Uninstall `loki-stack` from minikube.
   ```console
   helm uninstall scalar-logging-loki -n monitoring
   ```
