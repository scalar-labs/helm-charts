# Getting Started with Helm Charts (Logging using Loki Stack)

This document explains how to get started with log aggregation for Scalar products on Kubernetes using Grafana Loki (with Promtail).

We assume that you have already read the [getting-started with monitoring](./getting-started-monitoring.md) for Scalar products and installed kube-prometheus-stack.

## What we create

We will deploy the following components on a Kubernetes cluster as follows.

```
+--------------------------------------------------------------------------------------------------+
| +------------------------------------+                                                           |
| |             loki-stack             |                                                           |
| |                                    |                                       +-----------------+ |
| | +--------------+  +--------------+ | <-----------------(Log)-------------- | Scalar Products | |
| | |     Loki     |  |   Promtail   | |                                       |                 | |
| | +--------------+  +--------------+ |                                       |  +-----------+  | |
| +------------------------------------+                                       |  | ScalarDB  |  | |
|                                                                              |  +-----------+  | |
| +------------------------------------------------------+                     |                 | |
| |                kube-prometheus-stack                 |                     |  +-----------+  | |
| |                                                      |                     |  | ScalarDL  |  | |
| | +--------------+  +--------------+  +--------------+ | -----(Monitor)----> |  +-----------+  | |
| | |  Prometheus  |  | Alertmanager |  |   Grafana    | |                     +-----------------+ |
| | +-------+------+  +------+-------+  +------+-------+ |                                         |
| |         |                |                 |         |                                         |
| |         +----------------+-----------------+         |                                         |
| |                          |                           |                                         |
| +--------------------------+---------------------------+                                         |
|                            |                                                                     |
|                            |         Kubernetes                                                  |
+----------------------------+---------------------------------------------------------------------+
                             | <- expose to localhost (127.0.0.1) or use load balancer etc to access
                             |
              (Access Dashboard through HTTP)
                             |
                        +----+----+
                        | Browser |
                        +---------+
```

## Step 1. Prepare a custom values file

1. Get the sample file [scalar-loki-stack-custom-values.yaml](./conf/scalar-loki-stack-custom-values.yaml) for the `loki-stack` helm chart.

## Step 2. Deploy `loki-stack`

1. Add the `grafana` helm repository.
   ```console
   helm repo add grafana https://grafana.github.io/helm-charts
   ```

1. Deploy the `loki-stack` helm chart.
   ```console
   helm install scalar-logging-loki grafana/loki-stack -n monitoring -f scalar-loki-stack-custom-values.yaml
   ```

## Step 3. Add a Loki data source in the Grafana configuration

1. Add a configuration of the Loki data source in the `scalar-prometheus-custom-values.yaml` file.
   ```yaml
   grafana:
     additionalDataSources:
     - name: Loki
       type: loki
       uid: loki
       url: http://scalar-logging-loki:3100/
       access: proxy
       editable: false
       isDefault: false
   ```

1. Apply the configuration (upgrade the deployment of `kube-prometheus-stack`).
   ```console
   helm upgrade scalar-monitoring prometheus-community/kube-prometheus-stack -n monitoring -f scalar-prometheus-custom-values.yaml
   ```

## Step 4. Access the Grafana dashboard

1. Add Loki as a data source
   - Go to Grafana http://localhost:3000 (If you use minikube)
   - Go to `Explore` to find the added Loki
   - You can see the collected logs in the `Explore` page

## Step 5. Delete the `loki-stack` helm chart

1. Uninstall `loki-stack`.
   ```console
   helm uninstall scalar-logging-loki -n monitoring
   ```
