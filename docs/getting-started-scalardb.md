# Getting Started with Helm Charts (ScalarDB Server)

This document explains how to get started with ScalarDB Server using Helm Chart on a Kubernetes cluster as a test environment. Here, we assume that you already have a Mac or Linux environment for testing. We use **Minikube** in this document, but the steps we will show should work in any Kubernetes cluster.

## Requirement

* You need to subscribe to ScalarDB in the [AWS Marketplace](https://aws.amazon.com/marketplace/pp/prodview-rzbuhxgvqf4d2) or [Azure Marketplace](https://azuremarketplace.microsoft.com/en/marketplace/apps/scalarinc.scalardb) to get container images (`scalardb-server` and `scalardb-envoy`). Please refer to the following documents for more details.
   * [How to install Scalar products through AWS Marketplace](https://github.com/scalar-labs/scalar-kubernetes/blob/master/docs/AwsMarketplaceGuide.md)
   * [How to install Scalar products through Azure Marketplace](https://github.com/scalar-labs/scalar-kubernetes/blob/master/docs/AzureMarketplaceGuide.md)

## What we create

We will deploy the following components on a Kubernetes cluster as follows.

```
+--------------------------------------------------------------------------------------------------------------------------------------+
| [Kubernetes Cluster]                                                                                                                 |
|                                                                                                                                      |
|    [Pod]                                [Pod]                                                  [Pod]                     [Pod]       |
|                                                                                                                                      |
|                                       +-------+                                         +-----------------+                          |
|                                 +---> | Envoy | ---+                              +---> | ScalarDB Server | ---+                     |
|                                 |     +-------+    |                              |     +-----------------+    |                     |
|                                 |                  |                              |                            |                     |
|  +--------+      +---------+    |     +-------+    |     +-------------------+    |     +-----------------+    |     +------------+  |
|  | Client | ---> | Service | ---+---> | Envoy | ---+---> |      Service      | ---+---> | ScalarDB Server | ---+---> | PostgreSQL |  |
|  +--------+      | (Envoy) |    |     +-------+    |     | (ScalarDB Server) |    |     +-----------------+    |     +------------+  |
|                  +---------+    |                  |     +-------------------+    |                            |                     |
|                                 |     +-------+    |                              |     +-----------------+    |                     |
|                                 +---> | Envoy | ---+                              +---> | ScalarDB Server | ---+                     |
|                                       +-------+                                         +-----------------+                          |
|                                                                                                                                      |
+--------------------------------------------------------------------------------------------------------------------------------------+
```

## Step 1. Start a Kubernetes cluster

First, you need to prepare a Kubernetes cluster. If you use a **minikube** environment, please refer to the [Getting Started with Scalar Helm Charts](./getting-started-scalar-helm-charts.md). If you have already started a Kubernetes cluster, you can skip this step.

## Step 2. Start a PostgreSQL container

ScalarDB uses some kind of database system as a backend database. In this document, we use PostgreSQL.

You can deploy PostgreSQL on the Kubernetes cluster as follows.

1. Add the Bitnami helm repository.
   ```console
   helm repo add bitnami https://charts.bitnami.com/bitnami
   ```

1. Deploy PostgreSQL.
   ```console
   helm install postgresql-scalardb bitnami/postgresql \
     --set auth.postgresPassword=postgres \
     --set primary.persistence.enabled=false
   ```

1. Check if the PostgreSQL container is running.
   ```console
   kubectl get pod
   ```
   [Command execution result]
   ```console
   NAME                    READY   STATUS    RESTARTS   AGE
   postgresql-scalardb-0   1/1     Running   0          2m42s
   ```

## Step 3. Deploy ScalarDB Server on the Kubernetes cluster using Helm Charts

1. Add the Scalar helm repository.
   ```console
   helm repo add scalar-labs https://scalar-labs.github.io/helm-charts
   ```

1. Create a secret resource to pull the ScalarDB container images from AWS/Azure Marketplace.
   * AWS Marketplace
     ```console
     kubectl create secret docker-registry reg-ecr-mp-secrets \
       --docker-server=709825985650.dkr.ecr.us-east-1.amazonaws.com \
       --docker-username=AWS \
       --docker-password=$(aws ecr get-login-password --region us-east-1)
     ```
   * Azure Marketplace
     ```console
     kubectl create secret docker-registry reg-acr-secrets \
       --docker-server=<your private container registry login server> \
       --docker-username=<Service principal ID> \
       --docker-password=<Service principal password>
     ```

   Please refer to the following documents for more details.
   
   * [How to install Scalar products through AWS Marketplace](https://github.com/scalar-labs/scalar-kubernetes/blob/master/docs/AwsMarketplaceGuide.md)
   * [How to install Scalar products through Azure Marketplace](https://github.com/scalar-labs/scalar-kubernetes/blob/master/docs/AzureMarketplaceGuide.md)

1. Create a custom values file for ScalarDB Server (scalardb-custom-values.yaml).
   * AWS Marketplace
     ```console
     cat << 'EOF' > scalardb-custom-values.yaml
     envoy:
       image:
         repository: "709825985650.dkr.ecr.us-east-1.amazonaws.com/scalar/scalardb-envoy"
         version: "1.3.0"
       imagePullSecrets:
         - name: "reg-ecr-mp-secrets"
     
     scalardb:
       image:
         repository: "709825985650.dkr.ecr.us-east-1.amazonaws.com/scalar/scalardb-server"
         tag: "3.7.0"
       imagePullSecrets:
         - name: "reg-ecr-mp-secrets"
       databaseProperties: |
         scalar.db.storage=jdbc
         scalar.db.contact_points=jdbc:postgresql://postgresql-scalardb.default.svc.cluster.local:5432/postgres
         scalar.db.username={{ default .Env.SCALAR_DB_POSTGRES_USERNAME "" }}
         scalar.db.password={{ default .Env.SCALAR_DB_POSTGRES_PASSWORD "" }}
       secretName: "scalardb-credentials-secret"
     EOF
     ```
   * Azure Marketplace
     ```console
     cat << 'EOF' > scalardb-custom-values.yaml
     envoy:
       image:
         repository: "<your private container registry>/scalarinc/scalardb-envoy"
         version: "1.3.0"
       imagePullSecrets:
         - name: "reg-acr-secrets"
     
     scalardb:
       image:
         repository: "<your private container registry>/scalarinc/scalardb-server"
         tag: "3.7.0"
       imagePullSecrets:
         - name: "reg-acr-secrets"
       databaseProperties: |
         scalar.db.storage=jdbc
         scalar.db.contact_points=jdbc:postgresql://postgresql-scalardb.default.svc.cluster.local:5432/postgres
         scalar.db.username={{ default .Env.SCALAR_DB_POSTGRES_USERNAME "" }}
         scalar.db.password={{ default .Env.SCALAR_DB_POSTGRES_PASSWORD "" }}
       secretName: "scalardb-credentials-secret"
        EOF
     ```

1. Create a Secret resource that includes a username and password for PostgreSQL.
   ```console
   kubectl create secret generic scalardb-credentials-secret \
     --from-literal=SCALAR_DB_POSTGRES_USERNAME=postgres \
     --from-literal=SCALAR_DB_POSTGRES_PASSWORD=postgres
   ```

1. Deploy ScalarDB Server.
   ```console
   helm install scalardb scalar-labs/scalardb -f ./scalardb-custom-values.yaml
   ```

1. Check if the ScalarDB Server pods are deployed.
   ```console
   kubectl get pod
   ```
   [Command execution result]
   ```console
   NAME                              READY   STATUS    RESTARTS   AGE
   postgresql-scalardb-0             1/1     Running   0          9m48s
   scalardb-765598848b-75csp         1/1     Running   0          6s
   scalardb-765598848b-w864f         1/1     Running   0          6s
   scalardb-765598848b-x8rqj         1/1     Running   0          6s
   scalardb-envoy-84c475f77b-kpz2p   1/1     Running   0          6s
   scalardb-envoy-84c475f77b-n74tk   1/1     Running   0          6s
   scalardb-envoy-84c475f77b-zbrwz   1/1     Running   0          6s
   ```
   If the ScalarDB Server Pods are deployed properly, you can see the STATUS are **Running**.  

1. Check if the ScalarDB Server services are deployed.
   ```console
   kubectl get svc
   ```
   [Command execution result]
   ```console
   NAME                     TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)     AGE
   kubernetes               ClusterIP   10.96.0.1        <none>        443/TCP     47d
   postgresql-scalardb      ClusterIP   10.109.118.122   <none>        5432/TCP    10m
   postgresql-scalardb-hl   ClusterIP   None             <none>        5432/TCP    10m
   scalardb-envoy           ClusterIP   10.110.110.250   <none>        60051/TCP   41s
   scalardb-envoy-metrics   ClusterIP   10.107.98.227    <none>        9001/TCP    41s
   scalardb-headless        ClusterIP   None             <none>        60051/TCP   41s
   scalardb-metrics         ClusterIP   10.108.188.10    <none>        8080/TCP    41s
   ```
   If the ScalarDB Server services are deployed properly, you can see private IP addresses in the CLUSTER-IP column. (Note: `scalardb-headless` has no CLUSTER-IP.)  

## Step 4. Start a Client container

1. Start a Client container on the Kubernetes cluster.
   ```console
   kubectl run scalardb-client --image eclipse-temurin:8 --command sleep inf
   ```

1. Check if the Client container is running.
   ```console
   kubectl get pod scalardb-client
   ```
   [Command execution result]
   ```console
   NAME              READY   STATUS    RESTARTS   AGE
   scalardb-client   1/1     Running   0          23s
   ```

## Step 5. Run ScalarDB sample applications in the Client container

The following explains the minimum steps. If you want to know more details about ScalarDB, please refer to the [Getting Started with ScalarDB](https://github.com/scalar-labs/scalardb/blob/master/docs/getting-started-with-scalardb.md).

1. Run bash in the Client container.
   ```console
   kubectl exec -it scalardb-client -- bash
   ```
   After this step, run each command in the Client container.  

1. Install the git and curl commands in the Client container.
   ```console
   apt update && apt install -y git curl
   ```

1. Clone ScalarDB git repository.
   ```console
   git clone https://github.com/scalar-labs/scalardb.git
   ```

1. Change the directory to `scalardb/`.
   ```console
   cd scalardb/
   ```
   ```console
   pwd
   ```
   [Command execution result]
   ```console
   /scalardb
   ```

1. Change branch to arbitrary version.
   ```console
   git checkout -b v3.7.0 refs/tags/v3.7.0
   ```
   ```console
   git branch
   ```
   [Command execution result]
   ```console
     master
   * v3.7.0
   ```
   If you want to use another version, please specify the version (tag) you want to use.

1. Change the directory to `docs/getting-started/`.
   ```console
   cd docs/getting-started/
   ```
   ```console
   pwd
   ```
   [Command execution result]
   ```console
   /scalardb/docs/getting-started
   ```

1. Download Schema Loader from [ScalarDB Releases](https://github.com/scalar-labs/scalardb/releases).
   ```console
   curl -OL https://github.com/scalar-labs/scalardb/releases/download/v3.7.0/scalardb-schema-loader-3.7.0.jar
   ```
   You need to use the same version of ScalarDB and Schema Loader.

1. Create a configuration file (scalardb.properties) to access ScalarDB Server on the Kubernetes cluster.
   ```console
   cat << 'EOF' > scalardb.properties
   scalar.db.contact_points=scalardb-envoy.default.svc.cluster.local
   scalar.db.contact_port=60051
   scalar.db.storage=grpc
   scalar.db.transaction_manager=grpc
   EOF
   ```

1. Create a JSON file (emoney-transaction.json) that defines DB Schema for the sample applications.
   ```console
   cat << 'EOF' > emoney-transaction.json
   {
     "emoney.account": {
       "transaction": true,
       "partition-key": [
         "id"
       ],
       "clustering-key": [],
       "columns": {
         "id": "TEXT",
         "balance": "INT"
       }
     }
   }
   EOF
   ```

1. Run Schema Loader (Create sample TABLE).
   ```console
   java -jar ./scalardb-schema-loader-3.7.0.jar --config ./scalardb.properties -f emoney-transaction.json --coordinator
   ```

1. Run the sample applications.
   * Charge `1000` to `user1`:
     ```console
     ./gradlew run --args="-action charge -amount 1000 -to user1"
     ```
   * Charge `0` to `merchant1` (Just create an account for `merchant1`):
     ```console
     ./gradlew run --args="-action charge -amount 0 -to merchant1"
     ```
   * Pay `100` from `user1` to `merchant1`:
     ```console
     ./gradlew run --args="-action pay -amount 100 -from user1 -to merchant1"
     ```
   * Get the balance of `user1`:
     ```console
     ./gradlew run --args="-action getBalance -id user1"
     ```
   * Get the balance of `merchant1`:
     ```console
     ./gradlew run --args="-action getBalance -id merchant1"
     ```

1. (Optional) You can see the inserted and modified (INSERT/UPDATE) data through the sample applications using the following command. (This command needs to run on your localhost, not on the Client container.)  
   ```console
   kubectl exec -it postgresql-scalardb-0 -- bash -c 'export PGPASSWORD=postgres && psql -U postgres -d postgres -c "SELECT * FROM emoney.account"'
   ```
   [Command execution result]
   ```sql
       id     | balance |                tx_id                 | tx_state | tx_version | tx_prepared_at | tx_committed_at |             before_tx_id             | before_tx_state | before_tx_version | before_tx_prepared_at | before_tx_committed_at | before_balance
   -----------+---------+--------------------------------------+----------+------------+----------------+-----------------+--------------------------------------+-----------------+-------------------+-----------------------+------------------------+----------------
    merchant1 |     100 | 65a90225-0846-4e97-b729-151f76f6ca2f |        3 |          2 |  1667361909634 |1667361909679    | 3633df99-a8ed-4301-a8b9-db1344807d7b |               3 |                 1 |         1667361902466 |          1667361902485 |              0
    user1     |     900 | 65a90225-0846-4e97-b729-151f76f6ca2f |        3 |          2 |  1667361909634 |1667361909679    | 5520cba4-625a-4886-b81f-6089bf846d18 |               3 |                 1 |         1667361897283 |          1667361897317 |           1000
   (2 rows)
   ```
   * Note:
       * Usually, you need to access data (records) through ScalarDB. The above command is used to explain and confirm the working of the sample applications.

## Step 6. Delete all resources

After completing the ScalarDB Server tests on the Kubernetes cluster, remove all resources.

1. Uninstall ScalarDB Server and PostgreSQL.
   ```console
   helm uninstall scalardb postgresql-scalardb
   ```

1. Remove the Client container.
   ```
   kubectl delete pod scalardb-client --force --grace-period 0
   ```

## Further reading

You can see how to get started with monitoring or logging for Scalar products in the following documents.

* [Getting Started with Helm Charts (Monitoring using Prometheus Operator)](./getting-started-monitoring.md)
* [Getting Started with Helm Charts (Logging using Loki Stack)](./getting-started-logging.md)
* [Getting Started with Helm Charts (Scalar Manager)](./getting-started-scalar-manager.md)
