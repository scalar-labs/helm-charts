# ScalarDB Deployment Sample on Kubernetes (Multi-Storage Transactions)

## Version

This sample uses the following versions of each product.

* ScalarDB Server v3.6.0
* ScalarDB SQL CLI v3.6.0
* Scalar Envoy v1.2.0
* MySQL v8.0.30
* PostgreSQL v14.4
* Helm Chart: scalar-labs/scalardb v2.3.0
* Helm Chart: scalar-labs/envoy v2.0.1
* Helm Chart: bitnami/mysql v9.2.6
* Helm Chart: bitnami/postgresql v11.6.26

## Environment

This sample creates the following environment on Kubernetes cluster.

```
+----------------------------------------------------------------------------------------------------------------------------------------------+
| [Kubernetes Cluster]                                                                                                                         |
|                                         [Pod]                                                 [Pod]                            [Pod]         |
|                                                                                                                                              |
|                                       +-------+                                         +-----------------+                                  |
|                                 +---> | Envoy | ---+                              +---> | ScalarDB Server | ---+         +----------------+  |
|                                 |     +-------+    |                              |     +-----------------+    |         |     MySQL      |  |
|                                 |                  |                              |                            |   +---> | (schema0.tbl0) |  |
|  +--------+      +---------+    |     +-------+    |     +-------------------+    |     +-----------------+    |   |     +----------------+  |
|  | Client | ---> | Service | ---+---> | Envoy | ---+---> |      Service      | ---+---> | ScalarDB Server | ---+---+                         |
|  +--------+      | (Envoy) |    |     +-------+    |     | (ScalarDB Server) |    |     +-----------------+    |   |     +----------------+  |
|                  +---------+    |                  |     +-------------------+    |                            |   +---> |   PostgreSQL   |  |
|                                 |     +-------+    |                              |     +-----------------+    |         | (schema1.tbl1) |  |
|                                 +---> | Envoy | ---+                              +---> | ScalarDB Server | ---+         +----------------+  |
|                                       +-------+                                         +-----------------+                                  |
|                                                                                                                                              |
+----------------------------------------------------------------------------------------------------------------------------------------------+
```

# Preparation

1. Get sample files.
   ```console
   git clone https://github.com/scalar-labs/helm-charts.git
   cd helm-charts/docs/samples/scalardb/scalardb-multi-storage-sample/
   ```

1. Add Helm repositories.
   ```console
   helm repo add bitnami https://charts.bitnami.com/bitnami
   ```
   ```console
   helm repo add scalar-labs https://scalar-labs.github.io/helm-charts
   ```

1. Create a secret resource to access private container registry (GitHub Packages).
   ```console
   kubectl create secret docker-registry reg-docker-secrets \
     --docker-server=ghcr.io \
     --docker-username=<USERNAME> \
     --docker-password=<GITHUB_PERSONAL_ACCESS_TOKEN>
   ```

1. Deploy MySQL.
   ```console
   helm install mysql-scalardb bitnami/mysql \
     --set auth.rootPassword=mysql \
     --set primary.persistence.enabled=false \
     --version 9.2.6
   ```

1. Deploy PostgreSQL.
   ```console
   helm install postgresql-scalardb bitnami/postgresql \
     --set auth.postgresPassword=postgres \
     --set primary.persistence.enabled=false \
     --version 11.6.26
   ```

# Deploy ScalarDB Server

1. Create a secret resource that includes DB credentials.
   ```console
   kubectl create secret generic scalardb-credentials-secret \
     --from-literal=SCALAR_DB_MYSQL_USERNAME=root \
     --from-literal=SCALAR_DB_MYSQL_PASSWORD=mysql \
     --from-literal=SCALAR_DB_POSTGRES_USERNAME=postgres \
     --from-literal=SCALAR_DB_POSTGRES_PASSWORD=postgres
   ```

1. Deploy ScalarDB Server
   ```console
   helm install scalardb scalar-labs/scalardb \
     -f ./scalardb-server.yaml \
     --version 2.3.0
   ```

# Deploy Client (ScalarDB SQL CLI container)

1. Create a configmap resource that includes `database.properties`.
   ```console
   kubectl create configmap database-properties \
     --from-file=./database.properties
   ```

1. Deploy ScalarDB SQL CLI container.
   ```console
   kubectl apply -f ./scalardb-sql-cli.yaml
   ```

# Run SQL using ScalarDB SQL CLI

1. Run ScalarDB SQL CLI.
   ```console
   kubectl exec -it scalardb-sql-cli -- java -jar /app.jar --config /conf/database.properties
   ```

1. Create coordinator tables.
   ```sql
   CREATE COORDINATOR TABLES;
   ```

1. Create namespaces.
   ```sql
   CREATE NAMESPACE schema0;
   ```
   ```sql
   CREATE NAMESPACE schema1;
   ```

1. Create tables.
   ```sql
   CREATE TABLE schema0.t0 (
       c1 INT PRIMARY KEY,
       c2 INT,
       c3 TEXT
   );
   ```
   ```sql
   CREATE TABLE schema1.t1 (
       c1 INT PRIMARY KEY,
       c2 INT,
       c3 TEXT
   );
   ```

1. INSERT records.
   ```sql
   INSERT INTO schema0.t0 VALUES (1, 11, 'A');
   ```
   ```sql
   INSERT INTO schema1.t1 VALUeS (2, 22, 'B');
   ```
   ```sql
   BEGIN;
   INSERT INTO schema0.t0 VALUES (3, 33, 'C');
   INSERT INTO schema1.t1 VALUeS (4, 44, 'D');
   COMMIT;
   ```

1. SELECT all records.
   ```sql
   SELECT * FROM schema0.t0;
   ```
   ```sql
   SELECT * FROM schema1.t1;
   ```

# Confirm the records in the backend DB (For testing only. Retrieving record from backend DB directly is NOT recommended in production environment.)

1. SELECT records from MySQL (Backend DB 0).
   ```sql
   kubectl exec -it mysql-scalardb-0 -- mysql -u root -p schema0 -e "SELECT c1, c2, c3, tx_id FROM t0"
   ```
   * Password is `mysql`.

1. SELECT records from PostgreSQL (Backend DB 1).
   ```sql
   kubectl exec -it postgresql-scalardb-0 -- psql -U postgres -c "SELECT c1, c2, c3, tx_id FROM schema1.t1"
   ```
   * Password is `postgres`.
