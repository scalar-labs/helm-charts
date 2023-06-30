# Getting Started with Helm Charts (ScalarDL Ledger and Auditor / Auditor mode)

This document explains how to get started with ScalarDL Ledger and Auditor using Helm Chart on a Kubernetes cluster as a test environment. Here, we assume that you already have a Mac or Linux environment for testing. We use **Minikube** in this document, but the steps we will show should work in any Kubernetes cluster.

## Requirement

You need to subscribe to ScalarDL Ledger and ScalarDL Auditor in the [AWS Marketplace](https://aws.amazon.com/marketplace/pp/prodview-rzbuhxgvqf4d2) or [Azure Marketplace](https://azuremarketplace.microsoft.com/en/marketplace/apps/scalarinc.scalardb) to get the following container images.
   * AWS Marketplace
      * scalar-ledger
      * scalar-ledger-envoy
      * scalardl-schema-loader-ledger
      * scalar-auditor
      * scalar-auditor-envoy
      * scalardl-schema-loader-auditor
   * Azure Marketplace
      * scalar-ledger
      * scalar-auditor
      * scalardl-envoy
      * scalardl-schema-loader

Please refer to the following documents for more details.
   * [How to install Scalar products through AWS Marketplace](https://github.com/scalar-labs/scalar-kubernetes/blob/master/docs/AwsMarketplaceGuide.md)
   * [How to install Scalar products through Azure Marketplace](https://github.com/scalar-labs/scalar-kubernetes/blob/master/docs/AzureMarketplaceGuide.md)

## Note
To make Byzantine fault detection with auditing work properly, Ledger and Auditor should be deployed and managed in different administrative domains. However, in this guide, we will deploy Ledger and Auditor in the same Kubernetes cluster to make the test easier.  

## What we create

We will deploy the following components on a Kubernetes cluster as follows.

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

## Step 1. Start a Kubernetes cluster

First, you need to prepare a Kubernetes cluster. If you use a **minikube** environment, please refer to the [Getting Started with Scalar Helm Charts](./getting-started-scalar-helm-charts.md). If you have already started a Kubernetes cluster, you can skip this step.

## Step 2. Start PostgreSQL containers

ScalarDL Ledger and Auditor use some kind of database system as a backend database. In this document, we use PostgreSQL.

You can deploy PostgreSQL on the Kubernetes cluster as follows.

1. Add the Bitnami helm repository.
   ```console
   helm repo add bitnami https://charts.bitnami.com/bitnami
   ```

1. Deploy PostgreSQL for Ledger.
   ```console
   helm install postgresql-ledger bitnami/postgresql \
     --set auth.postgresPassword=postgres \
     --set primary.persistence.enabled=false
   ```

1. Deploy PostgreSQL for Auditor.
   ```console
   helm install postgresql-auditor bitnami/postgresql \
     --set auth.postgresPassword=postgres \
     --set primary.persistence.enabled=false
   ```

1. Check if the PostgreSQL containers are running.
   ```console
   kubectl get pod
   ```
   [Command execution result]
   ```console
   NAME                   READY   STATUS    RESTARTS   AGE
   postgresql-auditor-0   1/1     Running   0          11s
   postgresql-ledger-0    1/1     Running   0          16s
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
   cat << 'EOF' > ~/scalardl-test/certs/ledger.json
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

1. Create a JSON file that includes Auditor information.
   ```console
   cat << 'EOF' > ~/scalardl-test/certs/auditor.json
   {
       "CN": "auditor",
       "hosts": ["example.com","*.example.com"],
       "key": {
           "algo": "ecdsa",
           "size": 256
       },
       "names": [
           {
               "O": "auditor",
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
   cat << 'EOF' > ~/scalardl-test/certs/client.json
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

1. Create key/certificate files for the Auditor.
   ```console
   cfssl selfsign "" ./auditor.json | cfssljson -bare auditor
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
   auditor-key.pem
   auditor.csr
   auditor.json
   auditor.pem
   client-key.pem
   client.csr
   client.json
   client.pem
   ledger-key.pem
   ledger.csr
   ledger.json
   ledger.pem
   ```

# Step 5. Create DB schemas for ScalarDL Ledger using Helm Charts

We will deploy two ScalarDL Schema Loader pods on the Kubernetes cluster using Helm Charts.  
The ScalarDL Schema Loader will create the DB schemas for ScalarDL Ledger and Auditor in PostgreSQL.  

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

1. Create a custom values file for ScalarDL Schema Loader for Ledger (schema-loader-ledger-custom-values.yaml).
   * AWS Marketplace
     ```console
     cat << 'EOF' > ~/scalardl-test/schema-loader-ledger-custom-values.yaml
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
     cat << 'EOF' > ~/scalardl-test/schema-loader-ledger-custom-values.yaml
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

1. Create a custom values file for ScalarDL Schema Loader for Auditor (schema-loader-auditor-custom-values.yaml).
   * AWS Marketplace
     ```console
     cat << 'EOF' > ~/scalardl-test/schema-loader-auditor-custom-values.yaml
     schemaLoading:
       schemaType: "auditor"
       image:
         repository: "709825985650.dkr.ecr.us-east-1.amazonaws.com/scalar/scalardl-schema-loader-auditor"
         version: "3.6.0"
       imagePullSecrets:
         - name: "reg-ecr-mp-secrets"
       databaseProperties: |
         scalar.db.contact_points=jdbc:postgresql://postgresql-auditor.default.svc.cluster.local:5432/postgres
         scalar.db.username={{ default .Env.SCALAR_DL_AUDITOR_POSTGRES_USERNAME "" }}
         scalar.db.password={{ default .Env.SCALAR_DL_AUDITOR_POSTGRES_PASSWORD "" }}
         scalar.db.storage=jdbc
       secretName: "auditor-credentials-secret"
     EOF
     ```
   * Azure Marketplace
     ```console
     cat << 'EOF' > ~/scalardl-test/schema-loader-auditor-custom-values.yaml
     schemaLoading:
       schemaType: "auditor"
       image:
         repository: "<your private container registry>/scalarinc/scalardl-schema-loader"
         version: "3.6.0"
       imagePullSecrets:
         - name: "reg-acr-secrets"
       databaseProperties: |
         scalar.db.contact_points=jdbc:postgresql://postgresql-auditor.default.svc.cluster.local:5432/postgres
         scalar.db.username={{ default .Env.SCALAR_DL_AUDITOR_POSTGRES_USERNAME "" }}
         scalar.db.password={{ default .Env.SCALAR_DL_AUDITOR_POSTGRES_PASSWORD "" }}
         scalar.db.storage=jdbc
       secretName: "auditor-credentials-secret"
     EOF
     ```

1. Create a secret resource that includes a username and password for PostgreSQL for Ledger.
   ```console
   kubectl create secret generic ledger-credentials-secret \
     --from-literal=SCALAR_DL_LEDGER_POSTGRES_USERNAME=postgres \
     --from-literal=SCALAR_DL_LEDGER_POSTGRES_PASSWORD=postgres
   ```

1. Create a secret resource that includes a username and password for PostgreSQL for Auditor.
   ```console
   kubectl create secret generic auditor-credentials-secret \
     --from-literal=SCALAR_DL_AUDITOR_POSTGRES_USERNAME=postgres \
     --from-literal=SCALAR_DL_AUDITOR_POSTGRES_PASSWORD=postgres
   ```

1. Deploy the ScalarDL Schema Loader for Ledger.
   ```console
   helm install schema-loader-ledger scalar-labs/schema-loading -f ./schema-loader-ledger-custom-values.yaml
   ```

1. Deploy the ScalarDL Schema Loader for Auditor.
   ```console
   helm install schema-loader-auditor scalar-labs/schema-loading -f ./schema-loader-auditor-custom-values.yaml
   ```

1. Check if the ScalarDL Schema Loader pods are deployed and completed.
   ```console
   kubectl get pod
   ```
   [Command execution result]
   ```console
   NAME                                         READY   STATUS      RESTARTS   AGE
   postgresql-auditor-0                         1/1     Running     0          2m56s
   postgresql-ledger-0                          1/1     Running     0          3m1s
   schema-loader-auditor-schema-loading-dvc5r   0/1     Completed   0          6s
   schema-loader-ledger-schema-loading-mtllb    0/1     Completed   0          10s
   ```
   If the ScalarDL Schema Loader pods are **ContainerCreating** or **Running**, wait for the process will be completed (The STATUS will be **Completed**).

## Step 6. Deploy ScalarDL Ledger and Auditor on the Kubernetes cluster using Helm Charts

1. Create a custom values file for ScalarDL Ledger (scalardl-ledger-custom-values.yaml).
   * AWS Marketplace
     ```console
     cat << 'EOF' > ~/scalardl-test/scalardl-ledger-custom-values.yaml
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
         scalar.dl.ledger.auditor.enabled=true
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
     cat << 'EOF' > ~/scalardl-test/scalardl-ledger-custom-values.yaml
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

1. Create a custom values file for ScalarDL Auditor (scalardl-auditor-custom-values.yaml).
   * AWS Marketplace
     ```console
     cat << 'EOF' > ~/scalardl-test/scalardl-auditor-custom-values.yaml
     envoy:
       image:
         repository: "709825985650.dkr.ecr.us-east-1.amazonaws.com/scalar/scalar-auditor-envoy"
         version: "1.3.0"
       imagePullSecrets:
         - name: "reg-ecr-mp-secrets"
     
     auditor:
       image:
         repository: "709825985650.dkr.ecr.us-east-1.amazonaws.com/scalar/scalar-auditor"
         version: "3.6.0"
       imagePullSecrets:
         - name: "reg-ecr-mp-secrets"
       auditorProperties: |
         scalar.db.contact_points=jdbc:postgresql://postgresql-auditor.default.svc.cluster.local:5432/postgres
         scalar.db.username={{ default .Env.SCALAR_DL_AUDITOR_POSTGRES_USERNAME "" }}
         scalar.db.password={{ default .Env.SCALAR_DL_AUDITOR_POSTGRES_PASSWORD "" }}
         scalar.db.storage=jdbc
         scalar.dl.auditor.ledger.host=scalardl-ledger-envoy.default.svc.cluster.local
         scalar.dl.auditor.cert_path=/keys/certificate
         scalar.dl.auditor.private_key_path=/keys/private-key
       secretName: "auditor-credentials-secret"
       extraVolumes:
         - name: "auditor-keys"
           secret:
             secretName: "auditor-keys"
       extraVolumeMounts:
         - name: "auditor-keys"
           mountPath: "/keys"
           readOnly: true
     EOF
     ```
   * Azure Marketplace
     ```console
     cat << 'EOF' > ~/scalardl-test/scalardl-auditor-custom-values.yaml
     envoy:
       image:
         repository: "<your private container registry>/scalarinc/scalardl-envoy"
         version: "1.3.0"
       imagePullSecrets:
         - name: "reg-acr-secrets"
     
     auditor:
       image:
         repository: "<your private container registry>/scalarinc/scalar-auditor"
         version: "3.6.0"
       imagePullSecrets:
         - name: "reg-acr-secrets"
       auditorProperties: |
         scalar.db.contact_points=jdbc:postgresql://postgresql-auditor.default.svc.cluster.local:5432/postgres
         scalar.db.username={{ default .Env.SCALAR_DL_AUDITOR_POSTGRES_USERNAME "" }}
         scalar.db.password={{ default .Env.SCALAR_DL_AUDITOR_POSTGRES_PASSWORD "" }}
         scalar.db.storage=jdbc
         scalar.dl.auditor.ledger.host=scalardl-ledger-envoy.default.svc.cluster.local
         scalar.dl.auditor.cert_path=/keys/certificate
         scalar.dl.auditor.private_key_path=/keys/private-key
       secretName: "auditor-credentials-secret"
       extraVolumes:
         - name: "auditor-keys"
           secret:
             secretName: "auditor-keys"
       extraVolumeMounts:
         - name: "auditor-keys"
           mountPath: "/keys"
           readOnly: true
     EOF
     ```

1. Create secret resource `ledger-keys`.
   ```console
   kubectl create secret generic ledger-keys --from-file=certificate=./certs/ledger.pem --from-file=private-key=./certs/ledger-key.pem
   ```

1. Create secret resource `auditor-keys`.
   ```console
   kubectl create secret generic auditor-keys --from-file=certificate=./certs/auditor.pem --from-file=private-key=./certs/auditor-key.pem
   ```

1. Deploy the ScalarDL Ledger.
   ```console
   helm install scalardl-ledger scalar-labs/scalardl -f ./scalardl-ledger-custom-values.yaml
   ```

1. Deploy the ScalarDL Auditor.
   ```console
   helm install scalardl-auditor scalar-labs/scalardl-audit -f ./scalardl-auditor-custom-values.yaml
   ```

1. Check if the ScalarDL Ledger and Auditor pods are deployed.
   ```console
   kubectl get pod
   ```
   [Command execution result]
   ```console
   NAME                                         READY   STATUS      RESTARTS   AGE
   postgresql-auditor-0                         1/1     Running     0          14m
   postgresql-ledger-0                          1/1     Running     0          14m
   scalardl-auditor-auditor-5b885ff4c8-fwkpf    1/1     Running     0          18s
   scalardl-auditor-auditor-5b885ff4c8-g69cb    1/1     Running     0          18s
   scalardl-auditor-auditor-5b885ff4c8-nsmnq    1/1     Running     0          18s
   scalardl-auditor-envoy-689bcbdf65-5mn6v      1/1     Running     0          18s
   scalardl-auditor-envoy-689bcbdf65-fpq8j      1/1     Running     0          18s
   scalardl-auditor-envoy-689bcbdf65-lsz2t      1/1     Running     0          18s
   scalardl-ledger-envoy-547bbf7546-n7p5x       1/1     Running     0          26s
   scalardl-ledger-envoy-547bbf7546-p8nwp       1/1     Running     0          26s
   scalardl-ledger-envoy-547bbf7546-pskpb       1/1     Running     0          26s
   scalardl-ledger-ledger-6db5dc8774-5zsbj      1/1     Running     0          26s
   scalardl-ledger-ledger-6db5dc8774-vnmrw      1/1     Running     0          26s
   scalardl-ledger-ledger-6db5dc8774-wpjvs      1/1     Running     0          26s
   schema-loader-auditor-schema-loading-dvc5r   0/1     Completed   0          11m
   schema-loader-ledger-schema-loading-mtllb    0/1     Completed   0          11m
   ```
   If the ScalarDL Ledger and Auditor pods are deployed properly, you can see the STATUS are **Running**.  

1. Check if the ScalarDL Ledger and Auditor services are deployed.
   ```console
   kubectl get svc
   ```
   [Command execution result]
   ```console
   NAME                             TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)                         AGE
   kubernetes                       ClusterIP   10.96.0.1        <none>        443/TCP                         47d
   postgresql-auditor               ClusterIP   10.107.9.78      <none>        5432/TCP                        15m
   postgresql-auditor-hl            ClusterIP   None             <none>        5432/TCP                        15m
   postgresql-ledger                ClusterIP   10.108.241.181   <none>        5432/TCP                        15m
   postgresql-ledger-hl             ClusterIP   None             <none>        5432/TCP                        15m
   scalardl-auditor-envoy           ClusterIP   10.100.61.202    <none>        40051/TCP,40052/TCP             55s
   scalardl-auditor-envoy-metrics   ClusterIP   10.99.6.227      <none>        9001/TCP                        55s
   scalardl-auditor-headless        ClusterIP   None             <none>        40051/TCP,40053/TCP,40052/TCP   55s
   scalardl-auditor-metrics         ClusterIP   10.108.1.147     <none>        8080/TCP                        55s
   scalardl-ledger-envoy            ClusterIP   10.101.191.116   <none>        50051/TCP,50052/TCP             61s
   scalardl-ledger-envoy-metrics    ClusterIP   10.106.52.103    <none>        9001/TCP                        61s
   scalardl-ledger-headless         ClusterIP   None             <none>        50051/TCP,50053/TCP,50052/TCP   61s
   scalardl-ledger-metrics          ClusterIP   10.99.122.106    <none>        8080/TCP                        61s
   ```
   If the ScalarDL Ledger and Auditor services are deployed properly, you can see private IP addresses in the CLUSTER-IP column. (Note: `scalardl-ledger-headless` and `scalardl-auditor-headless` have no CLUSTER-IP.)  

## Step 7. Start a Client container

We will use certificate files in a Client container. So, we create a secret resource and mount it to a Client container.  

1. Create secret resource `client-keys`.
   ```
   kubectl create secret generic client-keys --from-file=certificate=./certs/client.pem --from-file=private-key=./certs/client-key.pem
   ```

1. Start a Client container on the Kubernetes cluster.
   ```console
   cat << 'EOF' | kubectl apply -f -
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
           - name: "ledger-keys"
             mountPath: "/keys/ledger"
             readOnly: true
           - name: "auditor-keys"
             mountPath: "/keys/auditor"
             readOnly: true
           - name: "client-keys"
             mountPath: "/keys/client"
             readOnly: true
     volumes:
       - name: "ledger-keys"
         secret:
           secretName: "ledger-keys"
       - name: "auditor-keys"
         secret:
           secretName: "auditor-keys"
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
   scalardl-client   1/1     Running   0          4s
   ```

## Step 8. Run ScalarDL sample contracts in the Client container

The following explains the minimum steps. If you want to know more details about ScalarDL Ledger and Auditor, please refer to the following documents.
   * [Getting Started with ScalarDL](https://github.com/scalar-labs/scalardl/blob/master/docs/getting-started.md)
   * [Getting Started with ScalarDL Auditor](https://github.com/scalar-labs/scalardl/blob/master/docs/getting-started-auditor.md)

When you use Auditor, you need to register the certificate for the Ledger and Auditor before starting the client application. Ledger needs to register its certificate to Auditor, and Auditor needs to register its certificate to Ledger.

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

1. Create a configuration file (ledger.as.client.properties) to register the certificate of Ledger to Auditor.
   ```console
   cat << 'EOF' > ledger.as.client.properties
   # Ledger
   scalar.dl.client.server.host=scalardl-ledger-envoy.default.svc.cluster.local
   
   # Auditor
   scalar.dl.client.auditor.enabled=true
   scalar.dl.client.auditor.host=scalardl-auditor-envoy.default.svc.cluster.local
   
   # Certificate
   scalar.dl.client.cert_holder_id=ledger
   scalar.dl.client.cert_path=/keys/ledger/certificate
   scalar.dl.client.private_key_path=/keys/ledger/private-key
   EOF
   ```

1. Create a configuration file (auditor.as.client.properties) to register the certificate of Auditor to Ledger.
   ```console
   cat << 'EOF' > auditor.as.client.properties
   # Ledger
   scalar.dl.client.server.host=scalardl-ledger-envoy.default.svc.cluster.local
   
   # Auditor
   scalar.dl.client.auditor.enabled=true
   scalar.dl.client.auditor.host=scalardl-auditor-envoy.default.svc.cluster.local
   
   # Certificate
   scalar.dl.client.cert_holder_id=auditor
   scalar.dl.client.cert_path=/keys/auditor/certificate
   scalar.dl.client.private_key_path=/keys/auditor/private-key
   EOF
   ```

1. Create a configuration file (client.properties) to access ScalarDL Ledger on the Kubernetes cluster.
   ```console
   cat << 'EOF' > client.properties
   # Ledger
   scalar.dl.client.server.host=scalardl-ledger-envoy.default.svc.cluster.local
   
   # Auditor
   scalar.dl.client.auditor.enabled=true
   scalar.dl.client.auditor.host=scalardl-auditor-envoy.default.svc.cluster.local
   
   # Certificate
   scalar.dl.client.cert_holder_id=client
   scalar.dl.client.cert_path=/keys/client/certificate
   scalar.dl.client.private_key_path=/keys/client/private-key
   EOF
   ```

1. Register the certificate file of Ledger.
   ```console
   ./scalardl-java-client-sdk-3.6.0/bin/register-cert --properties ./ledger.as.client.properties
   ```

1. Register the certificate file of Auditor.
   ```console
   ./scalardl-java-client-sdk-3.6.0/bin/register-cert --properties ./auditor.as.client.properties
   ```

1. Register the certificate file of client.
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

1. Register the contract `ValdateLedger` to execute a validate request.
   ```console
   ./scalardl-java-client-sdk-3.6.0/bin/register-contract --properties ./client.properties --contract-id validate-ledger --contract-binary-name com.scalar.dl.client.contract.ValidateLedger --contract-class-file ./build/classes/java/main/com/scalar/dl/client/contract/ValidateLedger.class
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
   * Reference information
      * If the asset data is not tampered with, the contract execution request (execute-contract command) returns `OK` as a result.
      * If the asset data is tampered with (e.g. the `state` value in the DB is tampered with), the contract execution request (execute-contract command) returns a value other than `OK`  (e.g. `INCONSISTENT_STATES`) as a result, like the following.  
        [Command execution result (If the asset data is tampered with)]
        ```console
        {
          "status_code" : "INCONSISTENT_STATES",
          "error_message" : "The results from Ledger and Auditor don't match"
        }
        ```
          * In this way, the ScalarDL can detect data tampering.

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
       "nonce" : "3533427d-03cf-41d1-bf95-4d31eb0cb24d",
       "hash" : "FiquvtPMKLlxKf4VGoccSAGsi9ptn4ozYVVTwdSzEQ0=",
       "signature" : "MEYCIQDiiXqzw6K+Ml4uvn8rK43o5wHWESU3hoXnZPi6/OeKVwIhAM+tFBcapl6zg47Uq0Uc8nVNGWNHZLBDBGve3F0xkzTR"
     },
     "Auditor" : {
       "id" : "test_asset",
       "age" : 0,
       "nonce" : "3533427d-03cf-41d1-bf95-4d31eb0cb24d",
       "hash" : "FiquvtPMKLlxKf4VGoccSAGsi9ptn4ozYVVTwdSzEQ0=",
       "signature" : "MEUCIQDLsfUR2PmxSvfpL3YvHJUkz00RDpjCdctkroZKXE8d5QIgH73FQH2e11jfnynD00Pp9DrIG1vYizxDsvxUsMPo9IU="
     }
   }
   ```
   * Reference information
      * If the asset data is not tampered with, the validation request (validate-ledger command) returns `OK` as a result.
      * If the asset data is tampered with (e.g. the `state` value in the DB is tampered with), the validation request (validate-ledger command) returns a value other than `OK` (e.g. `INVALID_OUTPUT`) as a result, like the following.  
        [Command execution result (If the asset data is tampered with)]
        ```console
        {
          "status_code" : "INCONSISTENT_STATES",
          "error_message" : "The results from Ledger and Auditor don't match"
        }
        ```
          * In this way, the ScalarDL Ledger can detect data tampering.

## Step 9. Delete all resources

After completing the ScalarDL Ledger tests on the Kubernetes cluster, remove all resources.

1. Uninstall ScalarDL Ledger, ScalarDL Schema Loader, and PostgreSQL.
   ```console
   helm uninstall scalardl-ledger schema-loader-ledger postgresql-ledger scalardl-auditor schema-loader-auditor postgresql-auditor
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
