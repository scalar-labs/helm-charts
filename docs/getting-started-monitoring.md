# Getting Started with Helm Charts (Monitoring using Prometheus Operator)

This document explains how to get started with Scalar products monitoring on Kubernetes using Prometheus Operator (kube-prometheus-stack). Here, we assume that you already have a Mac or Linux environment for testing. We use **Minikube** in this document, but the steps we will show should work in any Kubernetes cluster.

## What we create

We will deploy the following components on a Kubernetes cluster as follows.

```
+--------------------------------------------------------------------------------------------------+
| +------------------------------------------------------+                     +-----------------+ |
| |                kube-prometheus-stack                 |                     | Scalar Products | |
| |                                                      |                     |                 | |
| | +--------------+  +--------------+  +--------------+ | -----(Monitor)----> |  +-----------+  | |
| | |  Prometheus  |  | Alertmanager |  |   Grafana    | |                     |  | ScalarDB  |  | |
| | +-------+------+  +------+-------+  +------+-------+ |                     |  +-----------+  | |
| |         |                |                 |         |                     |  +-----------+  | |
| |         +----------------+-----------------+         |                     |  | ScalarDL  |  | |
| |                          |                           |                     |  +-----------+  | |
| +--------------------------+---------------------------+                     +-----------------+ |
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

## Step 1. Start a Kubernetes cluster

First, you need to prepare a Kubernetes cluster. If you use a **minikube** environment, please refer to the [Getting Started with Scalar Helm Charts](./getting-started-scalar-helm-charts.md). If you have already started a Kubernetes cluster, you can skip this step.

## Step 2. Prepare a custom values file

1. Save the sample file [scalar-prometheus-custom-values.yaml](./conf/scalar-prometheus-custom-values.yaml) for `kube-prometheus-stack`.

1. Add custom values in the `scalar-prometheus-custom-values.yaml` as follows.
   * settings
       * `prometheus.service.type` to `LoadBalancer`
       * `alertmanager.service.type` to `LoadBalancer`
       * `grafana.service.type` to `LoadBalancer`
       * `grafana.service.port` to `3000`
   * Example
     ```yaml
     alertmanager:

       service:
         type: LoadBalancer

     ...

     grafana:

       service:
         type: LoadBalancer
         port: 3000

     ...

     prometheus:

       service:
         type: LoadBalancer

     ...
     ```
   * Note:
       * If you want to customize the Prometheus Operator deployment by using Helm Charts, you'll need to set the following configurations to monitor Scalar products:
           * Set `serviceMonitorSelectorNilUsesHelmValues` and `ruleSelectorNilUsesHelmValues` to `false` (`true` by default) so that Prometheus Operator can detect `ServiceMonitor` and `PrometheusRule` for Scalar products.

       * If you want to use Scalar Manager, you'll need to set the following configurations to enable Scalar Manager to collect CPU and memory resources:
           * Set `kubeStateMetrics.enabled`, `nodeExporter.enabled`, and `kubelet.enabled` to `true`.

## Step 3. Deploy `kube-prometheus-stack`

1. Add the `prometheus-community` helm repository.
   ```console
   helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
   ```

1. Create a namespace `monitoring` on the Kubernetes.
   ```console
   kubectl create namespace monitoring
   ```

1. Deploy the `kube-prometheus-stack`.
   ```console
   helm install scalar-monitoring prometheus-community/kube-prometheus-stack -n monitoring -f scalar-prometheus-custom-values.yaml
   ```

## Step 4. Deploy (or Upgrade) Scalar products using Helm Charts

* Note:
   * The following explains the minimum steps. If you want to know more details about the deployment of ScalarDB and ScalarDL, please refer to the following documents.
       * [Getting Started with Helm Charts (ScalarDB Server)](./getting-started-scalardb.md)
       * [Getting Started with Helm Charts (ScalarDL Ledger / Ledger only)](./getting-started-scalardl-ledger.md)
       * [Getting Started with Helm Charts (ScalarDL Ledger and Auditor / Auditor mode)](./getting-started-scalardl-auditor.md)

1. To enable Prometheus monitoring of Scalar products, set `true` to the following configurations in the custom values file.
   * Configurations
       * `*.prometheusRule.enabled`
       * `*.grafanaDashboard.enabled`
       * `*.serviceMonitor.enabled`
   * Sample configuration files
       * ScalarDB (scalardb-custom-values.yaml)
         ```yaml
         envoy:
           prometheusRule:
             enabled: true
           grafanaDashboard:
             enabled: true
           serviceMonitor:
             enabled: true

         scalardb:
           prometheusRule:
             enabled: true
           grafanaDashboard:
             enabled: true
           serviceMonitor:
             enabled: true
         ```
       * ScalarDL Ledger (scalardl-ledger-custom-values.yaml)
         ```yaml
         envoy:
           prometheusRule:
             enabled: true
           grafanaDashboard:
             enabled: true
           serviceMonitor:
             enabled: true

         ledger:
           prometheusRule:
             enabled: true
           grafanaDashboard:
             enabled: true
           serviceMonitor:
             enabled: true
         ```
       * ScalarDL Auditor (scalardl-auditor-custom-values.yaml)
         ```yaml
         envoy:
           prometheusRule:
             enabled: true
           grafanaDashboard:
             enabled: true
           serviceMonitor:
             enabled: true

         auditor:
           prometheusRule:
             enabled: true
           grafanaDashboard:
             enabled: true
           serviceMonitor:
             enabled: true
         ```

1. Deploy (or Upgrade) Scalar products using Helm Charts with the above custom values file.
   * Examples
       * ScalarDB
         ```console
         helm install scalardb scalar-labs/scalardb -f ./scalardb-custom-values.yaml
         ```
         ```console
         helm upgrade scalardb scalar-labs/scalardb -f ./scalardb-custom-values.yaml
         ```
       * ScalarDL Ledger
         ```console
         helm install scalardl-ledger scalar-labs/scalardl -f ./scalardl-ledger-custom-values.yaml
         ```
         ```console
         helm upgrade scalardl-ledger scalar-labs/scalardl -f ./scalardl-ledger-custom-values.yaml
         ```
       * ScalarDL Auditor
         ```console
         helm install scalardl-auditor scalar-labs/scalardl-audit -f ./scalardl-auditor-custom-values.yaml
         ```
         ```console
         helm upgrade scalardl-auditor scalar-labs/scalardl-audit -f ./scalardl-auditor-custom-values.yaml
         ```

## Step 5. Access Dashboards

### If you use minikube

1. To expose each service resource as your `localhost (127.0.0.1)`, open another terminal, and run the `minikube tunnel` command.
   ```console
   minikube tunnel
   ```

   After running the `minikube tunnel` command, you can see the EXTERNAL-IP of each service resource as `127.0.0.1`.
   ```console
   kubectl get svc -n monitoring scalar-monitoring-kube-pro-prometheus scalar-monitoring-kube-pro-alertmanager scalar-monitoring-grafana
   ```
   [Command execution result]
   ```console
   NAME                                      TYPE           CLUSTER-IP     EXTERNAL-IP   PORT(S)          AGE
   scalar-monitoring-kube-pro-prometheus     LoadBalancer   10.98.11.12    127.0.0.1     9090:30550/TCP   26m
   scalar-monitoring-kube-pro-alertmanager   LoadBalancer   10.98.151.66   127.0.0.1     9093:31684/TCP   26m
   scalar-monitoring-grafana                 LoadBalancer   10.103.19.4    127.0.0.1     3000:31948/TCP   26m
   ```

1. Access each Dashboard.
   * Prometheus
     ```console
     http://localhost:9090/
     ```
   * Alertmanager
     ```console
     http://localhost:9093/
     ```
   * Grafana
     ```console
     http://localhost:3000/
     ```
       * Note:
           * You can see the user and password of Grafana as follows.
               * user
                 ```console
                 kubectl get secrets scalar-monitoring-grafana -n monitoring -o jsonpath='{.data.admin-user}' | base64 -d
                 ```
               * password
                 ```console
                 kubectl get secrets scalar-monitoring-grafana -n monitoring -o jsonpath='{.data.admin-password}' | base64 -d
                 ```

### If you use other Kubernetes than minikube

If you use a Kubernetes cluster other than minikube, you need to access the LoadBalancer service according to the manner of each Kubernetes cluster. For example, using a Load Balancer provided by cloud service or the `kubectl port-forward` command.

## Step 6. Delete all resources

After completing the Monitoring tests on the Kubernetes cluster, remove all resources.

1. Terminate the `minikube tunnel` command. (If you use minikube)
   ```console
   Ctrl + C
   ```

1. Uninstall `kube-prometheus-stack`.
   ```console
   helm uninstall scalar-monitoring -n monitoring
   ```

1. Delete minikube. (Optional / If you use minikube)
   ```console
   minikube delete --all
   ```
   * Note:
       * If you deploy the ScalarDB or ScalarDL, you need to remove them before deleting minikube.
