# Getting Started with Helm Charts (ScalarDB Analytics with PostgreSQL)

This document explains how to get started with ScalarDB Analytics with PostgreSQL using Helm Chart on a Kubernetes cluster as a test environment. Here, we assume that you already have a Mac or Linux environment for testing. We use **minikube** in this document, but the steps we will show should work in any Kubernetes cluster.

## What we create

We will deploy the following components on a Kubernetes cluster as follows.

```
+--------------------------------------------------------------------------------------------------------------------------------------+
| [Kubernetes cluster]                                                                                                                 |
|                                                                                                                                      |
|    [Pod]                                [Pod]                                               [Pod]                                    |
|                                                                                                                                      |
|                                       +------------------------------------+                                                         |
|                                 +---> | ScalarDB Analytics with PostgreSQL | ---+         +-----------------------------+            |
|                                 |     +------------------------------------+    |   +---> |  MySQL ("customer" schema)  | <---+      |
|                                 |                                               |   |     +-----------------------------+     |      |
|  +--------+      +---------+    |     +------------------------------------+    |   |                                         |      |
|  | Client | ---> | Service | ---+---> | ScalarDB Analytics with PostgreSQL | ---+---+                                         +---+  |
|  +--------+      +---------+    |     +------------------------------------+    |   |                                         |   |  |
|                                 |                                               |   |     +-----------------------------+     |   |  |
|                                 |     +------------------------------------+    |   +---> | PostgreSQL ("order" schema) | <---+   |  |
|                                 +---> | ScalarDB Analytics with PostgreSQL | ---+         +-----------------------------+         |  |
|                                       +------------------------------------+                                                      |  |
|                                                                                                                                   |  |
|  +-------------+                                                                                                                  |  |
|  | OLTP client | ---(Load sample data with a test OLTP workload)------------------------------------------------------------------+  |
|  +-------------+                                                                                                                     |
|                                                                                                                                      |
+--------------------------------------------------------------------------------------------------------------------------------------+
```

## Step 1. Start a Kubernetes cluster

First, you need to prepare a Kubernetes cluster. If you use a **minikube** environment, please refer to the [Getting Started with Scalar Helm Charts](./getting-started-scalar-helm-charts.md). If you have already started a Kubernetes cluster, you can skip this step.

## Step 2. Start MySQL and PostgreSQL pods

ScalarDB including ScalarDB Analytics with PostgreSQL can use some kind of database system as a backend database. In this document, we use MySQL and PostgreSQL.

You can deploy MySQL and PostgreSQL on the Kubernetes cluster as follows.

1. Add the Bitnami helm repository.

   ```console
   helm repo add bitnami https://charts.bitnami.com/bitnami
   ```

1. Deploy MySQL.

   ```console
   helm install mysql-scalardb bitnami/mysql \
     --set auth.rootPassword=mysql \
     --set primary.persistence.enabled=false
   ```

1. Deploy PostgreSQL.

   ```console
   helm install postgresql-scalardb bitnami/postgresql \
     --set auth.postgresPassword=postgres \
     --set primary.persistence.enabled=false
   ```

1. Check if the MySQL and PostgreSQL pods are running.

   ```console
   kubectl get pod
   ```

   [Command execution result]

   ```console
   $ kubectl get pod
   NAME                    READY   STATUS    RESTARTS   AGE
   mysql-scalardb-0        1/1     Running   0          3m17s
   postgresql-scalardb-0   1/1     Running   0          3m12s
   ```

## Step 3. Create a working directory

We will create some configuration files locally. So, create a working directory for them.

1. Create a working directory.

   ```console
   mkdir -p ~/scalardb-analytics-postgresql-test/
   ```

## Step 4. Set the versions of ScalarDB, ScalarDB Analytics with PostgreSQL, and chart

Set the following three environment variables. If you want to use another version of ScalarDB and ScalarDB Analytics with PostgreSQL, please set the versions that you want to use.

```console
SCALARDB_VERSION=3.10.1
```
```console
SCAlARDB_ANALYTICS_WITH_POSTGRESQL_VERSION=3.10.3
```
```console
CHART_VERSION=$(helm search repo scalar-labs/scalardb-analytics-postgresql -l | grep  -e ${SCAlARDB_ANALYTICS_WITH_POSTGRESQL_VERSION} | awk '{print $2}' | sort --version-sort -r | head -n 1)
```

## Step 5. Load sample data to MySQL and PostgreSQL (run OLTP transactions)

Before we deploy ScalarDB Analytics with PostgreSQL, we run the OLTP transactions to create sample data.

1. Start an OLTP client pod on the Kubernetes cluster.

   ```console
   kubectl run oltp-client --image eclipse-temurin:8-jdk-jammy --env SCALARDB_VERSION=${SCALARDB_VERSION} -- sleep inf
   ```

1. Check if the OLTP client pod is running.

   ```console
   kubectl get pod oltp-client
   ```

   [Command execution result]

   ```console
   $ kubectl get pod oltp-client
   NAME          READY   STATUS    RESTARTS   AGE
   oltp-client   1/1     Running   0          17s
   ```

1. Run bash in the OLTP client pod.

   ```console
   kubectl exec -it oltp-client -- bash
   ```

   After this step, run each command in the OLTP client pod.

1. Install the git and curl commands in the OLTP client pod.

   ```console
   apt update && apt install -y curl git
   ```

1. Clone the ScalarDB samples repository.

   ```console
   git clone https://github.com/scalar-labs/scalardb-samples.git
   ```

1. Change the directory to `scalardb-samples/multi-storage-transaction-sample/`.

   ```console
   cd scalardb-samples/multi-storage-transaction-sample/
   ```

   ```console
   pwd
   ```

   [Command execution result]

   ```console
   # pwd
   /scalardb-samples/multi-storage-transaction-sample
   ```

1. Create a configuration file (`database.properties`) to access MySQL and PostgreSQL on the Kubernetes cluster.

   ```console
   cat << 'EOF' > database.properties
   scalar.db.storage=multi-storage
   scalar.db.multi_storage.storages=storage0,storage1
   
   # Storage 0
   scalar.db.multi_storage.storages.storage0.storage=jdbc
   scalar.db.multi_storage.storages.storage0.contact_points=jdbc:mysql://mysql-scalardb.default.svc.cluster.local:3306/
   scalar.db.multi_storage.storages.storage0.username=root
   scalar.db.multi_storage.storages.storage0.password=mysql
   
   # Storage 1
   scalar.db.multi_storage.storages.storage1.storage=jdbc
   scalar.db.multi_storage.storages.storage1.contact_points=jdbc:postgresql://postgresql-scalardb.default.svc.cluster.local:5432/postgres
   scalar.db.multi_storage.storages.storage1.username=postgres
   scalar.db.multi_storage.storages.storage1.password=postgres
   
   scalar.db.multi_storage.namespace_mapping=customer:storage0,order:storage1
   scalar.db.multi_storage.default_storage=storage1
   EOF
   ```

1. Download Schema Loader from [ScalarDB Releases](https://github.com/scalar-labs/scalardb/releases).

   ```console
   curl -OL https://github.com/scalar-labs/scalardb/releases/download/v${SCALARDB_VERSION}/scalardb-schema-loader-${SCALARDB_VERSION}.jar
   ```

1. Run Schema Loader (Create sample tables).

   ```console
   java -jar scalardb-schema-loader-${SCALARDB_VERSION}.jar --config database.properties --schema-file schema.json --coordinator
   ```

1. Load initial data for the sample workload.

   ```console
   ./gradlew run --args="LoadInitialData"
   ```

1. Run the sample workload (OLTP transactions).

   ```console
   ./gradlew run --args="PlaceOrder 1 1:3,2:2"
   ```

   ```console
   ./gradlew run --args="PlaceOrder 1 5:1"
   ```

   ```console
   ./gradlew run --args="PlaceOrder 2 3:1,4:1"
   ```

   ```console
   ./gradlew run --args="PlaceOrder 2 2:1"
   ```

   ```console
   ./gradlew run --args="PlaceOrder 3 1:1"
   ```

   ```console
   ./gradlew run --args="PlaceOrder 3 2:1"
   ```

   ```console
   ./gradlew run --args="PlaceOrder 3 3:1"
   ```

   ```console
   ./gradlew run --args="PlaceOrder 3 5:1"
   ```

   These commands create several `order` information as sample data.

1. Exit from OLTP client.

   ```console
   exit
   ```

## Step 6. Deploy ScalarDB Analytics with PostgreSQL

After creating sample data via ScalarDB in the backend databases, deploy ScalarDB Analytics with PostgreSQL.

1. Create a custom values file for ScalarDB Analytics with PostgreSQL (`scalardb-analytics-postgresql-custom-values.yaml`).

   ```console
   cat << 'EOF' > ~/scalardb-analytics-postgresql-test/scalardb-analytics-postgresql-custom-values.yaml
   scalardbAnalyticsPostgreSQL:
     databaseProperties: |
       scalar.db.storage=multi-storage
       scalar.db.multi_storage.storages=storage0,storage1
       
       # Storage 0
       scalar.db.multi_storage.storages.storage0.storage=jdbc
       scalar.db.multi_storage.storages.storage0.contact_points=jdbc:mysql://mysql-scalardb.default.svc.cluster.local:3306/
       scalar.db.multi_storage.storages.storage0.username=root
       scalar.db.multi_storage.storages.storage0.password=mysql
       
       # Storage 1
       scalar.db.multi_storage.storages.storage1.storage=jdbc
       scalar.db.multi_storage.storages.storage1.contact_points=jdbc:postgresql://postgresql-scalardb.default.svc.cluster.local:5432/postgres
       scalar.db.multi_storage.storages.storage1.username=postgres
       scalar.db.multi_storage.storages.storage1.password=postgres
       
       scalar.db.multi_storage.namespace_mapping=customer:storage0,order:storage1
       scalar.db.multi_storage.default_storage=storage1
   schemaImporter:
     namespaces:
       - customer
       - order
   EOF
   ```

1. Create a secret resource to set a superuser password of PostgreSQL.

   ```console
   kubectl create secret generic scalardb-analytics-postgresql-superuser-password --from-literal=POSTGRES_PASSWORD=scalardb-analytics
   ```


1. Deploy ScalarDB Analytics with PostgreSQL.

   ```console
   helm install scalardb-analytics-postgresql scalar-labs/scalardb-analytics-postgresql -n default -f ~/scalardb-analytics-postgresql-test/scalardb-analytics-postgresql-custom-values.yaml --version ${CHART_VERSION}
   ```

## Step 7. Run a client pod

To run some queries via ScalarDB Analytics with PostgreSQL, run a client pod.

1. Start a client pod on the Kubernetes cluster.

   ```console
   kubectl run client --image postgres:latest -- sleep inf
   ```

1. Check if the client pod is running.

   ```console
   kubectl get pod client
   ```

   [Command execution result]

   ```console
   $ kubectl get pod client
   NAME     READY   STATUS    RESTARTS   AGE
   client   1/1     Running   0          21s
   ```

## Step 8. Run sample queries via ScalarDB Analytics with PostgreSQL

After running the client pod, you can run some queries via ScalarDB Analytics with PostgreSQL.

1. Run bash in the client pod.

   ```console
   kubectl exec -it client -- bash
   ```

   After this step, run each command in the client pod.

1. Run the psql command to access ScalarDB Analytics with PostgreSQL.

   ```console
   psql -h scalardb-analytics-postgresql -p 5432 -U postgres -d scalardb
   ```

   The password is `scalardb-analytics`.

1. Read sample data in the `customer.customers` table.

   ```sql
   SELECT * FROM customer.customers;
   ```

   [Command execution result]

   ```sql
    customer_id |     name      | credit_limit | credit_total
   -------------+---------------+--------------+--------------
              1 | Yamada Taro   |        10000 |        10000
              2 | Yamada Hanako |        10000 |         9500
              3 | Suzuki Ichiro |        10000 |         8500
   (3 rows)
   ```

1. Read sample data in the `order.orders` table.

   ```sql
   SELECT * FROM "order".orders;
   ```

   [Command execution result]

   ```sql
   scalardb=# SELECT * FROM "order".orders;
    customer_id |   timestamp   |               order_id
   -------------+---------------+--------------------------------------
              1 | 1700124015601 | 5ae2a41b-990d-4a16-9700-39355e29adf8
              1 | 1700124021273 | f3f23d93-3862-48be-8a57-8368b7c8689e
              2 | 1700124028182 | 696a895a-8998-4c3b-b112-4d5763bfcfd8
              2 | 1700124036158 | 9215d63a-a9a2-4471-a990-45897f091ca5
              3 | 1700124043744 | 9be70cd4-4f93-4753-9d89-68e250b2ac51
              3 | 1700124051162 | 4e8ce2d2-488c-40d6-aa52-d9ecabfc68a8
              3 | 1700124058096 | 658b6682-2819-41f2-91ee-2802a1f02857
              3 | 1700124071240 | 4e2f94f4-53ec-4570-af98-7c648d8ed80f
   (8 rows)
   ```

1. Read sample data in the `order.statements` table.

   ```sql
   SELECT * FROM "order".statements;
   ```

   [Command execution result]

   ```sql
   scalardb=# SELECT * FROM "order".statements;
                  order_id               | item_id | count
   --------------------------------------+---------+-------
    5ae2a41b-990d-4a16-9700-39355e29adf8 |       2 |     2
    5ae2a41b-990d-4a16-9700-39355e29adf8 |       1 |     3
    f3f23d93-3862-48be-8a57-8368b7c8689e |       5 |     1
    696a895a-8998-4c3b-b112-4d5763bfcfd8 |       4 |     1
    696a895a-8998-4c3b-b112-4d5763bfcfd8 |       3 |     1
    9215d63a-a9a2-4471-a990-45897f091ca5 |       2 |     1
    9be70cd4-4f93-4753-9d89-68e250b2ac51 |       1 |     1
    4e8ce2d2-488c-40d6-aa52-d9ecabfc68a8 |       2 |     1
    658b6682-2819-41f2-91ee-2802a1f02857 |       3 |     1
    4e2f94f4-53ec-4570-af98-7c648d8ed80f |       5 |     1
   (10 rows)
   ```

1. Read sample data in the `order.items` table.

   ```sql
   SELECT * FROM "order".items;
   ```

   [Command execution result]

   ```sql
   scalardb=# SELECT * FROM "order".items;
    item_id |  name  | price
   ---------+--------+-------
          5 | Melon  |  3000
          2 | Orange |  2000
          4 | Mango  |  5000
          1 | Apple  |  1000
          3 | Grape  |  2500
   (5 rows)
   ```

1. Run the `JOIN` query.

   For example, you can see the order history of each user as follows.

   ```sql
   SELECT 
     c.customer_id,
     c.name,
     o.order_id,
     i.name,
     s.count
   FROM
     customer.customers AS c
     LEFT OUTER JOIN
       "order".orders AS o
       ON c.customer_id = o.customer_id
         LEFT OUTER JOIN
           "order".statements AS s
           ON o.order_id = s.order_id
             LEFT OUTER JOIN
               "order".items AS i
               ON s.item_id = i.item_id
   ORDER BY c.customer_id, o.timestamp, o.order_id;
   ```

   [Command execution result]

   ```sql
   scalardb=# SELECT
   scalardb-#   c.customer_id,
   scalardb-#   c.name,
   scalardb-#   o.order_id,
   scalardb-#   i.name,
   scalardb-#   s.count
   scalardb-# FROM
   scalardb-#   customer.customers AS c
   scalardb-#   LEFT OUTER JOIN
   scalardb-#     "order".orders AS o
   scalardb-#     ON c.customer_id = o.customer_id
   scalardb-#       LEFT OUTER JOIN
   scalardb-#         "order".statements AS s
   scalardb-#         ON o.order_id = s.order_id
   scalardb-#           LEFT OUTER JOIN
   scalardb-#             "order".items AS i
   scalardb-#             ON s.item_id = i.item_id
   scalardb-# ORDER BY c.customer_id, o.timestamp, o.order_id;
    customer_id |     name      |               order_id               |  name  | count
   -------------+---------------+--------------------------------------+--------+-------
              1 | Yamada Taro   | 5ae2a41b-990d-4a16-9700-39355e29adf8 | Orange |     2
              1 | Yamada Taro   | 5ae2a41b-990d-4a16-9700-39355e29adf8 | Apple  |     3
              1 | Yamada Taro   | f3f23d93-3862-48be-8a57-8368b7c8689e | Melon  |     1
              2 | Yamada Hanako | 696a895a-8998-4c3b-b112-4d5763bfcfd8 | Mango  |     1
              2 | Yamada Hanako | 696a895a-8998-4c3b-b112-4d5763bfcfd8 | Grape  |     1
              2 | Yamada Hanako | 9215d63a-a9a2-4471-a990-45897f091ca5 | Orange |     1
              3 | Suzuki Ichiro | 9be70cd4-4f93-4753-9d89-68e250b2ac51 | Apple  |     1
              3 | Suzuki Ichiro | 4e8ce2d2-488c-40d6-aa52-d9ecabfc68a8 | Orange |     1
              3 | Suzuki Ichiro | 658b6682-2819-41f2-91ee-2802a1f02857 | Grape  |     1
              3 | Suzuki Ichiro | 4e2f94f4-53ec-4570-af98-7c648d8ed80f | Melon  |     1
   (10 rows)
   ```

1. Exit from the psql command.

   ```console
   \q
   ```

1. Exit from the client pod.

   ```console
   exit
   ```

## Step 9. Delete all resources  

After completing the ScalarDB Analytics with PostgreSQL tests on the Kubernetes cluster, remove all resources.

1. Uninstall MySQL, PostgreSQL, and ScalarDB Analytics with PostgreSQL.

   ```console
   helm uninstall mysql-scalardb postgresql-scalardb scalardb-analytics-postgresql
   ```

1. Remove the client pods.

   ```console
   kubectl delete pod oltp-client client --grace-period 0
   ```

1. Remove the secret resource.

   ```console
   kubectl delete secrets scalardb-analytics-postgresql-superuser-password
   ```

1. Remove the working directory and sample files.

   ```console
   cd ~
   ```

   ```console
   rm -rf ~/scalardb-analytics-postgresql-test/
   ```
