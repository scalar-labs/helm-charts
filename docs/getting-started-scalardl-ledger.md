# Getting Started with Helm Charts (ScalarDL Ledger / Ledger only)

This document explains how to get started with ScalarDL Ledger using Helm Chart on a Kubernetes cluster as a test environment. Here, we assume that you already have a Mac or Linux environment for testing. We use **Minikube** in this document, but the steps we will show should work in any Kubernetes cluster.

## Requirement

You need to subscribe to ScalarDL Ledger in the [AWS Marketplace](https://aws.amazon.com/marketplace/pp/prodview-rzbuhxgvqf4d2) or [Azure Marketplace](https://azuremarketplace.microsoft.com/en/marketplace/apps/scalarinc.scalardb) to get the following container images.
   * AWS Marketplace
      * scalar-ledger
      * scalar-ledger-envoy
      * scalardl-schema-loader-ledger
   * Azure Marketplace
      * scalar-ledger
      * scalardl-envoy
      * scalardl-schema-loader

Please refer to the following documents for more details.
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
|                                 +---> | Envoy | ---+                              +---> | ScalarDL Ledger | ---+                     |
|                                 |     +-------+    |                              |     +-----------------+    |                     |
|                                 |                  |                              |                            |                     |
|  +--------+      +---------+    |     +-------+    |     +-------------------+    |     +-----------------+    |     +------------+  |
|  | Client | ---> | Service | ---+---> | Envoy | ---+---> |      Service      | ---+---> | ScalarDL Ledger | ---+---> | PostgreSQL |  |
|  +--------+      | (Envoy) |    |     +-------+    |     | (ScalarDL Ledger) |    |     +-----------------+    |     +------------+  |
|                  +---------+    |                  |     +-------------------+    |                            |                     |
|                                 |     +-------+    |                              |     +-----------------+    |                     |
|                                 +---> | Envoy | ---+                              +---> | ScalarDL Ledger | ---+                     |
|                                       +-------+                                         +-----------------+                          |
|                                                                                                                                      |
+--------------------------------------------------------------------------------------------------------------------------------------+
```

## Step 1. Start a Kubernetes cluster

First, you need to prepare a Kubernetes cluster. If you use a **minikube** environment, please refer to the [Getting Started with Scalar Helm Charts](./getting-started-scalar-helm-charts.md). If you have already started a Kubernetes cluster, you can skip this step.

## Step 2. Start a PostgreSQL container

ScalarDL Ledger uses some kind of database system as a backend database. In this document, we use PostgreSQL.

You can deploy PostgreSQL on the Kubernetes cluster as follows.

1. Add the Bitnami helm repository.
   ```console
   helm repo add bitnami https://charts.bitnami.com/bitnami
   ```

1. Deploy PostgreSQL.
   ```console
   helm install postgresql-ledger bitnami/postgresql \
     --set auth.postgresPassword=postgres \
     --set primary.persistence.enabled=false
   ```

1. Check if the PostgreSQL container is running.
   ```console
   kubectl get pod
   ```
   [Command execution result]
   ```console
   NAME                  READY   STATUS    RESTARTS   AGE
   postgresql-ledger-0   1/1     Running   0          11s
   ```

## Step 3. Create a working directory

We will create some configuration files and key/certificate files locally. So, create a working directory for them.

1. Create a working directory.
   ```console
   mkdir -p ~/scalardl-test/certs/
   ```

## Step 4. Create key/certificate files

Note: In this guide, we will use self-sign certificates for the test. However, it is strongly recommended that these certificates NOT be used in production.

1. Change the working directory to `~/scalardl-test/certs/` directory.
   ```console
   cd ~/scalardl-test/certs/
   ```

1. Create a JSON file that includes Ledger information.
   ```console
   cat << EOF > ~/scalardl-test/certs/ledger.json
   {
       "CN": "ledger",
       "hosts": ["example.com","*.example.com"],
       "key": {
           "algo": "ecdsa",
           "size": 256
       },
       "names": [
           {
               "O": "ledger",
               "OU": "test team",
               "L": "Shinjuku",
               "ST": "Tokyo",
               "C": "JP"
           }
       ]
   }
   EOF
   ```

1. Create a JSON file that includes Client information.
   ```console
   cat << EOF > ~/scalardl-test/certs/client.json
   {
       "CN": "client",
       "hosts": ["example.com","*.example.com"],
       "key": {
           "algo": "ecdsa",
           "size": 256
       },
       "names": [
           {
               "O": "client",
               "OU": "test team",
               "L": "Shinjuku",
               "ST": "Tokyo",
               "C": "JP"
           }
       ]
   }
   EOF
   ```

1. Create key/certificate files for the Ledger.
   ```console
   cfssl selfsign "" ./ledger.json | cfssljson -bare ledger
   ```

1. Create key/certificate files for the Client.
   ```console
   cfssl selfsign "" ./client.json | cfssljson -bare client
   ```

1. Confirm key/certificate files are created.
   ```console
   ls -1
   ```
   [Command execution result]
   ```console
   client-key.pem
   client.csr
   client.json
   client.pem
   ledger-key.pem
   ledger.csr
   ledger.json
   ledger.pem
   ```

## Step 5. Create DB schemas for ScalarDL Ledger using Helm Charts

We will deploy a ScalarDL Schema Loader on the Kubernetes cluster using Helm Charts.  
The ScalarDL Schema Loader will create the DB schemas for ScalarDL Ledger in PostgreSQL.  

1. Change the working directory to `~/scalardl-test/`.
   ```console
   cd ~/scalardl-test/
   ```

1. Add the Scalar helm repository.
   ```console
   helm repo add scalar-labs https://scalar-labs.github.io/helm-charts
   ```

1. Create a secret resource to pull the ScalarDL container images from AWS/Azure Marketplace.
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

1. Create a custom values file for ScalarDL Schema Loader (schema-loader-ledger-custom-values.yaml).
   * AWS Marketplace
     ```console
     cat << EOF > ~/scalardl-test/schema-loader-ledger-custom-values.yaml
     schemaLoading:
       schemaType: "ledger"
       image:
         repository: "709825985650.dkr.ecr.us-east-1.amazonaws.com/scalar/scalardl-schema-loader-ledger"
         version: "3.6.0"
       imagePullSecrets:
         - name: "reg-ecr-mp-secrets"
       databaseProperties: |
         scalar.db.contact_points=jdbc:postgresql://postgresql-ledger.default.svc.cluster.local:5432/postgres
         scalar.db.username={{ default .Env.SCALAR_DL_LEDGER_POSTGRES_USERNAME "" }}
         scalar.db.password={{ default .Env.SCALAR_DL_LEDGER_POSTGRES_PASSWORD "" }}
         scalar.db.storage=jdbc
       secretName: "ledger-credentials-secret"
     EOF
     ```
   * Azure Marketplace
     ```console
     cat << EOF > ~/scalardl-test/schema-loader-ledger-custom-values.yaml
     schemaLoading:
       schemaType: "ledger"
       image:
         repository: "<your private container registry>/scalarinc/scalardl-schema-loader"
         version: "3.6.0"
       imagePullSecrets:
         - name: "reg-acr-secrets"
       databaseProperties: |
         scalar.db.contact_points=jdbc:postgresql://postgresql-ledger.default.svc.cluster.local:5432/postgres
         scalar.db.username={{ default .Env.SCALAR_DL_LEDGER_POSTGRES_USERNAME "" }}
         scalar.db.password={{ default .Env.SCALAR_DL_LEDGER_POSTGRES_PASSWORD "" }}
         scalar.db.storage=jdbc
       secretName: "ledger-credentials-secret"
     EOF
     ```

1. Create a secret resource that includes a username and password for PostgreSQL.
   ```console
   kubectl create secret generic ledger-credentials-secret \
     --from-literal=SCALAR_DL_LEDGER_POSTGRES_USERNAME=postgres \
     --from-literal=SCALAR_DL_LEDGER_POSTGRES_PASSWORD=postgres
   ```

1. Deploy the ScalarDL Schema Loader.
   ```console
   helm install schema-loader-ledger scalar-labs/schema-loading -f ./schema-loader-ledger-custom-values.yaml
   ```

1. Check if the ScalarDL Schema Loader pod is deployed and completed.
   ```console
   kubectl get pod
   ```
   [Command execution result]
   ```console
   NAME                                        READY   STATUS      RESTARTS   AGE
   postgresql-ledger-0                         1/1     Running     0          11m
   schema-loader-ledger-schema-loading-46rcr   0/1     Completed   0          3s
   ```
   If the ScalarDL Schema Loader pod is **ContainerCreating** or **Running**, wait for the process will be completed (The STATUS will be **Completed**).

## Step 6. Deploy ScalarDL Ledger on the Kubernetes cluster using Helm Charts

1. Create a custom values file for ScalarDL Ledger (scalardl-ledger-custom-values.yaml).
   * AWS Marketplace
     ```console
     cat << EOF > ~/scalardl-test/scalardl-ledger-custom-values.yaml
     envoy:
       image:
         repository: "709825985650.dkr.ecr.us-east-1.amazonaws.com/scalar/scalar-ledger-envoy"
         version: "1.3.0"
       imagePullSecrets:
         - name: "reg-ecr-mp-secrets"
     
     ledger:
       image:
         repository: "709825985650.dkr.ecr.us-east-1.amazonaws.com/scalar/scalar-ledger"
         version: "3.6.0"
       imagePullSecrets:
         - name: "reg-ecr-mp-secrets"
       ledgerProperties: |
         scalar.db.contact_points=jdbc:postgresql://postgresql-ledger.default.svc.cluster.local:5432/postgres
         scalar.db.username={{ default .Env.SCALAR_DL_LEDGER_POSTGRES_USERNAME "" }}
         scalar.db.password={{ default .Env.SCALAR_DL_LEDGER_POSTGRES_PASSWORD "" }}
         scalar.db.storage=jdbc
         scalar.dl.ledger.proof.enabled=true
         scalar.dl.ledger.proof.private_key_path=/keys/private-key
       secretName: "ledger-credentials-secret"
       extraVolumes:
         - name: "ledger-keys"
           secret:
             secretName: "ledger-keys"
       extraVolumeMounts:
         - name: "ledger-keys"
           mountPath: "/keys"
           readOnly: true
     EOF
     ```
   * Azure Marketplace
     ```console
     cat << EOF > ~/scalardl-test/scalardl-ledger-custom-values.yaml
     envoy:
       image:
         repository: "<your private container registry>/scalarinc/scalardl-envoy"
         version: "1.3.0"
       imagePullSecrets:
         - name: "reg-acr-secrets"
     
     ledger:
       image:
         repository: "<your private container registry>/scalarinc/scalar-ledger"
         version: "3.6.0"
       imagePullSecrets:
         - name: "reg-acr-secrets"
       ledgerProperties: |
         scalar.db.contact_points=jdbc:postgresql://postgresql-ledger.default.svc.cluster.local:5432/postgres
         scalar.db.username={{ default .Env.SCALAR_DL_LEDGER_POSTGRES_USERNAME "" }}
         scalar.db.password={{ default .Env.SCALAR_DL_LEDGER_POSTGRES_PASSWORD "" }}
         scalar.db.storage=jdbc
         scalar.dl.ledger.proof.enabled=true
         scalar.dl.ledger.proof.private_key_path=/keys/private-key
       secretName: "ledger-credentials-secret"
       extraVolumes:
         - name: "ledger-keys"
           secret:
             secretName: "ledger-keys"
       extraVolumeMounts:
         - name: "ledger-keys"
           mountPath: "/keys"
           readOnly: true
     EOF
     ```

1. Create secret resource `ledger-keys`.
   ```console
   kubectl create secret generic ledger-keys --from-file=private-key=./certs/ledger-key.pem
   ```

1. Deploy the ScalarDL Ledger.
   ```console
   helm install scalardl-ledger scalar-labs/scalardl -f ./scalardl-ledger-custom-values.yaml
   ```

1. Check if the ScalarDL Ledger pods are deployed.
   ```console
   kubectl get pod
   ```
   [Command execution result]
   ```console
   NAME                                        READY   STATUS      RESTARTS   AGE
   postgresql-ledger-0                         1/1     Running     0          14m
   scalardl-ledger-envoy-547bbf7546-6cn88      1/1     Running     0          52s
   scalardl-ledger-envoy-547bbf7546-rpg5p      1/1     Running     0          52s
   scalardl-ledger-envoy-547bbf7546-x2vlg      1/1     Running     0          52s
   scalardl-ledger-ledger-9bdf7f8bd-29bzm      1/1     Running     0          52s
   scalardl-ledger-ledger-9bdf7f8bd-9fklw      1/1     Running     0          52s
   scalardl-ledger-ledger-9bdf7f8bd-9tw5x      1/1     Running     0          52s
   schema-loader-ledger-schema-loading-46rcr   0/1     Completed   0          3m38s
   ```
   If the ScalarDL Ledger pods are deployed properly, you can see the STATUS are **Running**.  

1. Check if the ScalarDL Ledger services are deployed.
   ```console
   kubectl get svc
   ```
   [Command execution result]
   ```console
   NAME                            TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)                         AGE
   kubernetes                      ClusterIP   10.96.0.1        <none>        443/TCP                         47d
   postgresql-ledger               ClusterIP   10.109.253.150   <none>        5432/TCP                        15m
   postgresql-ledger-hl            ClusterIP   None             <none>        5432/TCP                        15m
   scalardl-ledger-envoy           ClusterIP   10.106.141.153   <none>        50051/TCP,50052/TCP             83s
   scalardl-ledger-envoy-metrics   ClusterIP   10.108.36.136    <none>        9001/TCP                        83s
   scalardl-ledger-headless        ClusterIP   None             <none>        50051/TCP,50053/TCP,50052/TCP   83s
   scalardl-ledger-metrics         ClusterIP   10.98.4.217      <none>        8080/TCP                        83s
   ```
   If the ScalarDL Ledger services are deployed properly, you can see private IP addresses in the CLUSTER-IP column. (Note: `scalardl-ledger-headless` has no CLUSTER-IP.)  

## Step 7. Start a Client container

We will use certificate files in a Client container. So, we create a secret resource and mount it to a Client container.  

1. Create secret resource `client-keys`.
   ```
   kubectl create secret generic client-keys --from-file=certificate=./certs/client.pem --from-file=private-key=./certs/client-key.pem
   ```

1. Start a Client container on the Kubernetes cluster.
   ```console
   cat << EOF | kubectl apply -f -
   apiVersion: v1
   kind: Pod
   metadata:
     name: "scalardl-client"
   spec:
     containers:
       - name: scalardl-client
         image: eclipse-temurin:8
         command: ['sleep']
         args: ['inf']
         volumeMounts:
           - name: "client-keys"
             mountPath: "/keys"
             readOnly: true
     volumes:
       - name: "client-keys"
         secret:
           secretName: "client-keys"
     restartPolicy: Never 
   EOF
   ```

1. Check if the Client container is running.
   ```console
   kubectl get pod scalardl-client
   ```
   [Command execution result]
   ```console
   NAME              READY   STATUS    RESTARTS   AGE
   scalardl-client   1/1     Running   0          11s
   ```

## Step 8. Run ScalarDL sample contracts in the Client container

The following explains the minimum steps. If you want to know more details about ScalarDL and the contract, please refer to the [Getting Started with ScalarDL](https://github.com/scalar-labs/scalardl/blob/master/docs/getting-started.md).

1. Run bash in the Client container.
   ```console
   kubectl exec -it scalardl-client -- bash
   ```
   After this step, run each command in the Client container.  

1. Install the git, curl and unzip commands in the Client container.
   ```console
   apt update && apt install -y git curl unzip
   ```

1. Clone ScalarDL Java Client SDK git repository.
   ```console
   git clone https://github.com/scalar-labs/scalardl-java-client-sdk.git
   ```

1. Change the directory to `scalardl-java-client-sdk/`.
   ```console
   cd scalardl-java-client-sdk/
   ```
   ```console
   pwd
   ```
   [Command execution result]
   ```console

   /scalardl-java-client-sdk
   ```

1. Change branch to arbitrary version.
   ```console
   git checkout -b v3.6.0 refs/tags/v3.6.0
   ```
   ```console
   git branch
   ```
   [Command execution result]
   ```console
     master
   * v3.6.0
   ```
   If you want to use another version, please specify the version (tag) you want to use. You need to use the same version of ScalarDL Ledger and ScalarDL Java Client SDK.

1. Build the sample contracts.
   ```console
   ./gradlew assemble
   ```

1. Download CLI tools of ScalarDL from [ScalarDL Java Client SDK Releases](https://github.com/scalar-labs/scalardl-java-client-sdk/releases).
   ```console
   curl -OL https://github.com/scalar-labs/scalardl-java-client-sdk/releases/download/v3.6.0/scalardl-java-client-sdk-3.6.0.zip
   ```
   You need to use the same version of CLI tools and ScalarDL Ledger.

1. Unzip the `scalardl-java-client-sdk-3.6.0.zip` file.
   ```console
   unzip ./scalardl-java-client-sdk-3.6.0.zip
   ```

1. Create a configuration file (client.properties) to access ScalarDL Ledger on the Kubernetes cluster.
   ```console
   cat << EOF > client.properties
   scalar.dl.client.server.host=scalardl-ledger-envoy.default.svc.cluster.local
   scalar.dl.client.cert_holder_id=client
   scalar.dl.client.cert_path=/keys/certificate
   scalar.dl.client.private_key_path=/keys/private-key
   EOF
   ```

1. Register the certificate file of the client.
   ```console
   ./scalardl-java-client-sdk-3.6.0/bin/register-cert --properties ./client.properties
   ```

1. Register the sample contract `StateUpdater`.
   ```console
   ./scalardl-java-client-sdk-3.6.0/bin/register-contract --properties ./client.properties --contract-id StateUpdater --contract-binary-name com.org1.contract.StateUpdater --contract-class-file ./build/classes/java/main/com/org1/contract/StateUpdater.class
   ```

1. Register the sample contract `StateReader`.
   ```console
   ./scalardl-java-client-sdk-3.6.0/bin/register-contract --properties ./client.properties --contract-id StateReader --contract-binary-name com.org1.contract.StateReader --contract-class-file ./build/classes/java/main/com/org1/contract/StateReader.class
   ```

1. Execute the contract `StateUpdater`.
   ```console
   ./scalardl-java-client-sdk-3.6.0/bin/execute-contract --properties ./client.properties --contract-id StateUpdater --contract-argument '{"asset_id": "test_asset", "state": 3}'
   ```
   This sample contract updates the `state` (value) of the asset named `test_asset` to `3`.  

1. Execute the contract `StateReader`.
   ```console
   ./scalardl-java-client-sdk-3.6.0/bin/execute-contract --properties ./client.properties --contract-id StateReader --contract-argument '{"asset_id": "test_asset"}'
   ```
   [Command execution result]
   ```console
   Contract result:
   {
     "id" : "test_asset",
     "age" : 0,
     "output" : {
       "state" : 3
     }
   }
   ```

1. Execute a validation request for the asset.
   ```console
   ./scalardl-java-client-sdk-3.6.0/bin/validate-ledger --properties ./client.properties --asset-id "test_asset"
   ```
   [Command execution result]
   ```console
   {
     "status_code" : "OK",
     "Ledger" : {
       "id" : "test_asset",
       "age" : 0,
       "nonce" : "f31599c6-e6b9-4b77-adc3-61cb5f119bd3",
       "hash" : "9ExfFl5Lg9IQwdXdW9b87Bi+PWccn3OSNRbhmI/dboo=",
       "signature" : "MEQCIG6Xa4WOWGMIIbA3PnCje4aAapYfCMerF54xRW0gaUuzAiBCA1nCAPoFWgxArB34/u9b+KeoxQBMALI/pOzMNoLExg=="
     },
     "Auditor" : null
   }
   ```
   * Reference information
       * If the asset data is not tampered with, the validation request (validate-ledger command) returns `OK` as a result.
       * If the asset data is tampered with (e.g. the `state` value in the DB is tampered with), the validation request (validate-ledger command) returns a value other than `OK` (e.g. `INVALID_OUTPUT`) as a result, like the following.  
         [Command execution result (If the asset data is tampered with)]
         ```console
         {
           "status_code" : "INVALID_OUTPUT",
           "Ledger" : {
             "id" : "test_asset",
             "age" : 0,
             "nonce" : "f31599c6-e6b9-4b77-adc3-61cb5f119bd3",
             "hash" : "9ExfFl5Lg9IQwdXdW9b87Bi+PWccn3OSNRbhmI/dboo=",
             "signature" : "MEQCIGtJerW7N93c/bvIBy/7NXxoQwGFznHMmV6RzsgHQg0dAiBu+eBxkfmMQKJY2d9fLNvCH+4b+9rl7gZ3OXJ2NYeVsA=="
           },
           "Auditor" : null
         }
         ```
           * In this way, the ScalarDL Ledger can detect data tampering.

## Step 9. Delete all resources

After completing the ScalarDL Ledger tests on the Kubernetes cluster, remove all resources.

1. Uninstall ScalarDL Ledger, ScalarDL Schema Loader, and PostgreSQL.
   ```console
   helm uninstall scalardl-ledger schema-loader-ledger postgresql-ledger
   ```

1. Remove the Client container.
   ```
   kubectl delete pod scalardl-client --force --grace-period 0
   ```

1. Remove the working directory and sample files (configuration file, key, and certificate).
   ```console
   cd ~
   ```
   ```console
   rm -rf ~/scalardl-test/
   ```

## Further reading

You can see how to get started with monitoring or logging for Scalar products in the following documents.

* [Getting Started with Helm Charts (Monitoring using Prometheus Operator)](./getting-started-monitoring.md)
* [Getting Started with Helm Charts (Logging using Loki Stack)](./getting-started-logging.md)
* [Getting Started with Helm Charts (Scalar Manager)](./getting-started-scalar-manager.md)
