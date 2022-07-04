# Getting Started with Helm Charts (Scalar Manager)
Scalar Manager is a web-based dashboard that allows users to:
* check the health of the Scalar products
* pause and unpause the Scalar products to backup or restore underlying databases
* check the metrics and logs of the Scalar products through Grafana dashboards

The users can pause or unpause Scalar products through Scalar Manager to backup or restore the underlying databases.  
Scalar Manager also embeds Grafana explorers by which the users can review the metrics or logs of the Scalar products.

## Assumption
This guide assumes that the users are aware of how to deploy Scalar products with the monitoring and logging tools to a Kubernetes cluster.
If not, please start with [Getting Started with Scalar Helm Charts](./getting-started-scalar-helm-charts.md) before this guide.

## Environment
In this guide, we will create the `scalar-manager` component in the following diagram.

```
+--------------------------------------------------------------------------------------------------+
| +----------------------+                                                                         |
| |    scalar-manager    |                                                                         |
| |                      |                                                                         |
| | +------------------+ | --------------------------(Manage)--------------------------+           |
| | |  Scalar Manager  | |                                                             |           |
| | +------------------+ |                                                             |           |
| +--+-------------------+                                                             |           |
|    |                                                                                 |           |
| +------------------------------------+                                               |           |
| |             loki-stack             |                                               V           |
| |                                    |                                       +-----------------+ |
| | +--------------+  +--------------+ | <----------------(Log)--------------- | Scalar Products | |
| | |     Loki     |  |   Promtail   | |                                       |                 | |
| | +--------------+  +--------------+ |                                       |  +-----------+  | |
| +------------------------------------+                                       |  | Scalar DB |  | |
|    |                                                                         |  +-----------+  | |
| +------------------------------------------------------+                     |                 | |
| |                kube-prometheus-stack                 |                     |  +-----------+  | |
| |                                                      |                     |  | Scalar DL |  | |
| | +--------------+  +--------------+  +--------------+ | -----(Monitor)----> |  +-----------+  | |
| | |  Prometheus  |  | Alertmanager |  |   Grafana    | |                     +-----------------+ |
| | +-------+------+  +------+-------+  +------+-------+ |                                         |
| |         |                |                 |         |                                         |
| |         +----------------+-----------------+         |                                         |
| |                          |                           |                                         |
| +--------------------------+---------------------------+                                         |
|    |                       |                                                                     |
|    |                       |         Kubernetes (minikube)                                       |
+----+-----------------------+---------------------------------------------------------------------+
     |                       |
  expose to localhost (127.0.0.1)
     |                       |
  (Access Dashboard through HTTP)
     |                       |
+----+----+             +----+----+
| Browser | <-(Embed)-- + Browser |
+---------+             +---------+
```

## Step 1. Upgrade the `kube-prometheus-stack` to allow Grafana to be embedded

1. Add or revise this value to the custom values file (e.g. scalar-prometheus-custom-values.yaml) of the `kube-prometheus-stack`
   ```yaml
   grafana:
     grafana-ini:
       security:
         allow_embedding: true
         cookie_samesite: disabled
   ```

1. Upgrade the Helm installation
   ```console
   helm upgrade scalar-monitoring prometheus-community/kube-prometheus-stack -n monitoring -f scalar-prometheus-custom-values.yaml
   ```

## Step 2. Prepare a custom values file for Scalar Manager

1. Get the sample file [scalar-manager-custom-values.yaml](./conf/scalar-manager-custom-values.yaml) for `scalar-manager`.

1. Add the targets that you would like to manage. For example, if we want to manage a ledger cluster, then we can add the values as follows.
   ```yaml
   scalarManager:
     targets:
       - name: my-ledgers-cluster
         adminSrv: _scalardl-admin._tcp.scalardl-headless.default.svc.cluster.local
         databaseType: cassandra
   ```

Note: the `adminSrv` is the DNS Service URL that returns SRV record of pods. Kubernetes creates this URL for the named port of the headless service of the Scalar product. The format is `_{port name}._{protocol}.{service name}.{namespace}.svc.{cluster domain name}`

1. Set the Grafana URL. For example, if your Grafana of the `kube-prometheus-stack` is exposed in `localhost:3000`, then we can set it as follows.
   ```yaml
   scalarManager:
     grafanaUrl: "http://localhost:3000"
   ```

1. Set the refresh interval that Scalar Manager checks the status of the products. The default value is `30` seconds, but we can change it like:
   ```yaml
   scalarManager:
     refreshInterval: 60 # one minute
   ```

## Step 3. Deploy `scalar-manager`

1. Deploy the `scalar-manager` Helm Chart.
   ```console
   helm install scalar-manager scalar-labs/scalar-manager -f scalar-manager-custom-values.yaml
   ```

## Step 4. Access Scalar Manager

1. Forward Scalar Manager's port 8000 to the host's port 8000
   ```console
   kubectl port-forward services/scalar-manager 8000
   ```

1. Open the browser with URL `http://localhost:8000`

## Step 5. Delete Scalar Manager
1. Uninstall `scalar-manager`
   ```console
   helm uninstall scalar-manager
   ```
