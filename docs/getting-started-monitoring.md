# Getting Started with Helm Charts (Monitoring using Prometheus Operator)

This document explains how to get started with Scalar products monitoring on Kubernetes using Prometheus Operator (kube-prometheus-stack). Here, we assume that you already have a Mac or Linux environment for testing.  

## Environment

We will create the following environment in your local by using Docker and minikube.  

```
+--------------------------------------------------------------------------------------------------+
| +------------------------------------------------------+                     +-----------------+ |
| |                kube-prometheus-stack                 |                     | Scalar Products | |
| |                                                      |                     |                 | |
| | +--------------+  +--------------+  +--------------+ | ---(Monitoring)---> |  +-----------+  | |
| | |  Prometheus  |  | Alertmanager |  |   Grafana    | |                     |  | Scalar DB |  | |
| | +-------+------+  +------+-------+  +------+-------+ |                     |  +-----------+  | |
| |         |                |                 |         |                     |  +-----------+  | |
| |         +----------------+-----------------+         |                     |  | Scalar DL |  | |
| |                          |                           |                     |  +-----------+  | |
| +--------------------------+---------------------------+                     +-----------------+ |
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

## Step 1. Start minikube

First, you need to prepare a `minikube` environment according to [Getting Started with Scalar Helm Charts](./getting-started-scalar-helm-charts.md). If you have already started the `minikube`, you can skip this step.

## Step 2. Prepare a custom values file

1. Get the sample file [scalar-prometheus-custom-values.yaml](./conf/scalar-prometheus-custom-values.yaml) for `kube-prometheus-stack`.  

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
       * If you want to customize the Prometheus Operator deployment using Helm Charts, you need to set the following configuration for monitoring Scalar products.
           * The `serviceMonitorSelectorNilUsesHelmValues` and `ruleSelectorNilUsesHelmValues` must be set to `false` (`true` by default) to make Prometheus Operator detects `ServiceMonitor` and `PrometheusRule` of Scalar products.



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
   * The following explains the minimum steps. If you want to know more details about the deployment of Scalar DB and Scalar DL, please refer to the following documents.
       * [Getting Started with Helm Charts (Scalar DB Server)](./getting-started-scalardb.md)
       * [Getting Started with Helm Charts (Scalar DL Ledger)](./getting-started-scalardl-ledger.md)
       * [Getting Started with Helm Charts (Scalar DL Auditor)](./getting-started-scalardl-auditor.md)

1. To enable Prometheus monitoring of Scalar products, set `true` to the following configurations in the custom values file.
   * Configurations
       * `*.prometheusRule.enabled`
       * `*.grafanaDashboard.enabled`
       * `*.serviceMonitor.enabled`
   * Sample configuration files
       * Scalar DB (scalardb-custom-values.yaml)
         ```yaml
         envoy:
           service:
             type: "NodePort"
           prometheusRule:
             enabled: true
           grafanaDashboard:
             enabled: true
           serviceMonitor:
             enabled: true
         
         scalardb:
           storageConfiguration:
             contactPoints: "cassandra-scalardb"
             username: "cassandra"
             password: "cassandra"
             storage: "cassandra"
           prometheusRule:
             enabled: true
           grafanaDashboard:
             enabled: true
           serviceMonitor:
             enabled: true
         ```
       * Scalar DL Ledger (scalardl-ledger-custom-values.yaml)
         ```yaml
         envoy:
           service:
             type: "NodePort"
           prometheusRule:
             enabled: true
           grafanaDashboard:
             enabled: true
           serviceMonitor:
             enabled: true
         
         ledger:
           scalarLedgerConfiguration:
             dbStorage: "cassandra"
             dbContactPoints: "cassandra-ledger"
             dbUsername: "cassandra"
             dbPassword: "cassandra"
             ledgerProofEnabled: true
           # ledgerAuditorEnabled: true
           prometheusRule:
             enabled: true
           grafanaDashboard:
             enabled: true
           serviceMonitor:
             enabled: true
         ```
       * Scalar DL Auditor (scalardl-auditor-custom-values.yaml)
         ```yaml
         envoy:
           service:
             type: "NodePort"
           prometheusRule:
             enabled: true
           grafanaDashboard:
             enabled: true
           serviceMonitor:
             enabled: true
         
         auditor:
           scalarAuditorConfiguration:
             dbStorage: "cassandra"
             dbContactPoints: "cassandra-auditor"
             dbUsername: "cassandra"
             dbPassword: "cassandra"
             auditorLedgerHost: "scalardl-ledger-envoy"
           prometheusRule:
             enabled: true
           grafanaDashboard:
             enabled: true
           serviceMonitor:
             enabled: true
         ```

1. Deploy (or Upgrade) Scalar products using Helm Charts with the above custom values file.
   * Examples
       * Scalar DB
         ```console
         helm install scalardb scalar-labs/scalardb -f ./scalardb-custom-values.yaml
         ```
         ```console
         helm upgrade scalardb scalar-labs/scalardb -f ./scalardb-custom-values.yaml
         ```
       * Scalar DL Ledger
         ```console
         helm install scalardl-ledger scalar-labs/scalardl -f ./scalardl-ledger-custom-values.yaml
         ```
         ```console
         helm upgrade scalardl-ledger scalar-labs/scalardl -f ./scalardl-ledger-custom-values.yaml
         ```
       * Scalar DL Auditor
         ```console
         helm install scalardl-auditor scalar-labs/scalardl-audit -f ./scalardl-auditor-custom-values.yaml
         ```
         ```console
         helm upgrade scalardl-auditor scalar-labs/scalardl-audit -f ./scalardl-auditor-custom-values.yaml
         ```

## Step 5. Access Dashboards

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

## Step 6. Delete all resources

After completing the Monitoring tests on minikube, remove all resources.

1. Terminate the `minikube tunnel` command.
   ```console
   Ctrl + C
   ```

1. Uninstall `kube-prometheus-stack` from minikube.
   ```console
   helm uninstall scalar-monitoring -n monitoring
   ```

1. (Optional) Delete minikube.
   ```console
   minikube delete --all
   ```
   * Note:
       * If you deploy the Scalar DB or Scalar DL, you need to remove them before deleting minikube.
