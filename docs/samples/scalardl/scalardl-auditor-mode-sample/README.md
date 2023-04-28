# ScalarDL Deployment Sample on Kubernetes (Auditor mode)

## Version

* ScalarDL Ledger v3.5.3
* ScalarDL Auditor v3.5.3
* Scalar Envoy v1.3.0
* ScalarDL Schema Loader v3.5.0
* PostgreSQL v14.4
* Helm Chart: scalar-labs/scalardl v4.3.3
* Helm Chart: scalar-labs/scalardl-audit v2.3.3
* Helm Chart: scalar-labs/envoy v2.2.0
* Helm Chart: scalar-labs/schema-loading v2.6.0
* Helm Chart: bitnami/postgresql v11.6.26

## Environment

This sample creates the following environment on Kubernetes cluster.

```
+-----------------------------------------------------------------------------------------------------------------------------+
| [Kubernetes Cluster]                                                                                                        |
|                                             [Pod]                                      [Pod]                   [Pod]        |
|                                                                                                                             |
|                                           +-------+                                 +---------+                             |
|                                     +---> | Envoy | ---+                      +---> | Ledger  | ---+                        |
|                                     |     +-------+    |                      |     +---------+    |                        |
|                                     |                  |                      |                    |                        |
|                      +---------+    |     +-------+    |     +-----------+    |     +---------+    |     +---------------+  |
|                +---> | Service | ---+---> | Envoy | ---+---> |  Service  | ---+---> | Ledger  | ---+---> |  PostgreSQL   |  |
|                |     | (Envoy) |    |     +-------+    |     | (Ledger)  |    |     +---------+    |     | (For Ledger)  |  |
|                |     +---------+    |                  |     +-----------+    |                    |     +---------------+  |
|                |                    |     +-------+    |                      |     +---------+    |                        |
|                |                    +---> | Envoy | ---+                      +---> | Ledger  | ---+                        |
|  +--------+    |                          +-------+                                 +---------+                             |
|  | Client | ---+                                                                                                            |
|  +--------+    |                          +-------+                                 +---------+                             |
|                |                    +---> | Envoy | ---+                      +---> | Auditor | ---+                        |
|                |                    |     +-------+    |                      |     +---------+    |                        |
|                |                    |                  |                      |                    |                        |
|                |     +---------+    |     +-------+    |     +-----------+    |     +---------+    |     +---------------+  |
|                +---> | Service | ---+---> | Envoy | ---+---> |  Service  | ---+---> | Auditor | ---+---> |  PostgreSQL   |  |
|                      | (Envoy) |    |     +-------+    |     | (Auditor) |    |     +---------+    |     | (For Auditor) |  |
|                      +---------+    |                  |     +-----------+    |                    |     +---------------+  |
|                                     |     +-------+    |                      |     +---------+    |                        |
|                                     +---> | Envoy | ---+                      +---> | Auditor | ---+                        |
|                                           +-------+                                 +---------+                             |
|                                                                                                                             |
+-----------------------------------------------------------------------------------------------------------------------------+
```

Note: To make Byzantine fault detection with auditing work properly, Ledger and Auditor should be deployed and managed in different administrative domains. However, for this samples, we deploy them in the same Kubernetes cluster.

# Preparation

1. Get sample files.
   ```console
   git clone https://github.com/scalar-labs/helm-charts.git
   cd helm-charts/docs/samples/scalardl/scalardl-auditor-mode-sample/
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

1. Deploy PostgreSQL for Ledger.
   ```console
   helm install postgresql-ledger bitnami/postgresql \
     --set auth.postgresPassword=postgres \
     --set primary.persistence.enabled=false \
     --version 11.6.26
   ```

1. Deploy PostgreSQL for Auditor.
   ```console
   helm install postgresql-auditor bitnami/postgresql \
     --set auth.postgresPassword=postgres \
     --set primary.persistence.enabled=false \
     --version 11.6.26
   ```

# Deploy ScalarDL Ledger

1. Create a secret resource that includes DB credentials.
   ```console
   kubectl create secret generic ledger-credentials-secret \
     --from-literal=SCALAR_DB_USERNAME=postgres \
     --from-literal=SCALAR_DB_PASSWORD=postgres
   ```

1. Create a secret resource that includes private key file.
   ```console
   kubectl create secret generic ledger-key-secret \
     --from-file=ledger-key-file=./ledger-key.pem
   ```

1. Deploy ScalarDL Schema Loader to create schema on PostgreSQL for Ledger.
   ```console
   helm install schema-ledger scalar-labs/schema-loading \
     -f ./schema-loader-ledger-custom-values.yaml \
     --version 2.6.0
   ```

1. Deploy ScalarDL Ledger.
   ```console
   helm install scalardl-ledger scalar-labs/scalardl \
     -f ./scalardl-ledger-custom-values.yaml \
     --version 4.3.3
   ```

# Deploy ScalarDL Auditor

1. Create a secret resource that includes DB credentials.
   ```console
   kubectl create secret generic auditor-credentials-secret \
     --from-literal=SCALAR_DB_USERNAME=postgres \
     --from-literal=SCALAR_DB_PASSWORD=postgres
   ```

1. Create a secret resource that includes private key and certificate file.
   ```console
   kubectl create secret generic auditor-key-secret \
     --from-file=auditor-key-file=./auditor-key.pem \
     --from-file=auditor-cert-file=./auditor.pem
   ```

1. Deploy ScalarDL Schema Loader to create schema on PostgreSQL for Auditor.
   ```console
   helm install schema-auditor scalar-labs/schema-loading \
     -f ./schema-loader-auditor-custom-values.yaml \
     --version 2.6.0
   ```

1. Deploy ScalarDL Auditor.
   ```console
   helm install scalardl-auditor scalar-labs/scalardl-audit \
     -f ./scalardl-auditor-custom-values.yaml \
     --version 2.3.3
   ```

# Deploy Client

1. Create secret resources that include each private key and certificate file.
   ```console
   kubectl create secret generic client-ledger-key-secret \
     --from-file=ledger-key-file=./ledger-key.pem \
     --from-file=ledger-cert-file=./ledger.pem
   ```
   ```console
   kubectl create secret generic client-auditor-key-secret \
     --from-file=auditor-key-file=./auditor-key.pem \
     --from-file=auditor-cert-file=./auditor.pem
   ```
   ```console
   kubectl create secret generic client-key-secret \
     --from-file=client-key-file=./client-key.pem \
     --from-file=client-cert-file=./client.pem
   ```

1. Create configmap resources that include each properties file.
   ```console
   kubectl create configmap ledger-as-client-properties \
     --from-file=./ledger.as.client.properties
   ```
   ```console
   kubectl create configmap auditor-as-client-properties \
     --from-file=./auditor.as.client.properties
   ```
   ```console
   kubectl create configmap client-properties \
     --from-file=./client.properties
   ```

1. Deploy client.
   ```console
   kubectl apply -f ./scalardl-client.yaml
   ```

# Run sample contracts

1. Attach to client container with bash.
   ```console
   kubectl exec -it scalardl-client -- bash
   ```

1. Install some tools to build and run the sample contracts.
   ```console
   apt update && DEBIAN_FRONTEND="noninteractive" TZ="Etc/UTC" apt install -y git openjdk-8-jdk curl unzip
   ```

1. Clone ScalarDL Java Client SDK git repository and build sample contracts.
   ```console
   git clone https://github.com/scalar-labs/scalardl-java-client-sdk.git
   cd /scalardl-java-client-sdk/ 
   git checkout -b v3.5.3 refs/tags/v3.5.3
   ./gradlew assemble
   ```

1. Download CLI tools of ScalarDL and unzip them.
   ```console
   curl -OL https://github.com/scalar-labs/scalardl-java-client-sdk/releases/download/v3.5.3/scalardl-java-client-sdk-3.5.3.zip
   unzip ./scalardl-java-client-sdk-3.5.3.zip
   ```

1. Register the certificate file of Ledger, Auditor, and client.
   ```console
   ./scalardl-java-client-sdk-3.5.3/bin/register-cert --properties /conf/ledger/ledger.as.client.properties
   ./scalardl-java-client-sdk-3.5.3/bin/register-cert --properties /conf/auditor/auditor.as.client.properties
   ./scalardl-java-client-sdk-3.5.3/bin/register-cert --properties /conf/client/client.properties
   ```

1. Register the sample contract `StateUpdater`.
   ```console
   ./scalardl-java-client-sdk-3.5.3/bin/register-contract --properties /conf/client/client.properties --contract-id StateUpdater --contract-binary-name com.org1.contract.StateUpdater --contract-class-file ./build/classes/java/main/com/org1/contract/StateUpdater.class
   ```

1. Register the sample contract `StateReader`.
   ```console
   ./scalardl-java-client-sdk-3.5.3/bin/register-contract --properties /conf/client/client.properties --contract-id StateReader --contract-binary-name com.org1.contract.StateReader --contract-class-file ./build/classes/java/main/com/org1/contract/StateReader.class
   ```

1. Register the contract `ValidateLedger`.
   ```console
   ./scalardl-java-client-sdk-3.5.3/bin/register-contract --properties /conf/client/client.properties --contract-id validate-ledger --contract-binary-name com.scalar.dl.client.contract.ValidateLedger --contract-class-file ./build/classes/java/main/com/scalar/dl/client/contract/ValidateLedger.class
   ```

1. Execute the contract `StateUpdater`. This sample contract updates the `state` (value) of the asset named `test_asset` to `3`.
   ```console
   ./scalardl-java-client-sdk-3.5.3/bin/execute-contract --properties /conf/client/client.properties --contract-id StateUpdater --contract-argument '{"asset_id": "test_asset", "state": 3}'
   ```

1. Execute the contract `StateReader`.
   ```console
   ./scalardl-java-client-sdk-3.5.3/bin/execute-contract --properties /conf/client/client.properties --contract-id StateReader --contract-argument '{"asset_id": "test_asset"}'
   ```

1. Execute a validation request of the asset.
   ```console
   ./scalardl-java-client-sdk-3.5.3/bin/validate-ledger --properties /conf/client/client.properties --asset-id "test_asset"
   ```
