# Getting Started with Helm Charts (Scalar DL Auditor)

This document explains how to get started with Scalar DL Ledger and Auditor using the Helm Chart in your test environment. Here, we assume that you already have a Mac or Linux environment for testing.  

## Requirement

* You need the privileges to pull the Scalar DL containers (`scalar-ledger`, `scalar-auditor`, and `scalardl-schema-loader`) from [GitHub Packages](https://github.com/orgs/scalar-labs/packages).
* You must create a Github Personal Access Token (PAT) with `read:packages` scope according to the [GitHub document](https://docs.github.com/en/github/authenticating-to-github/keeping-your-account-and-data-secure/creating-a-personal-access-token) to pull the above containers.

## Note
To make Byzantine fault detection with auditing work properly, Ledger and Auditor should be deployed and managed in different administrative domains. However, in this guide, we will deploy Ledger and Auditor in the same Kubernetes (minikube) to make the test easier.  

## Tools

In this guide, we will use the following tools for testing.  

1. Docker
1. minikube
1. kubectl
1. Helm
1. cfssl / cfssljson

## Environment

In this guide, we will create the following environment in your local by using Docker and minikube.  

```
On the Docker Network (named minikube)

                   +---------------------------------------------+    +-----------+    +-----------+
  +-----------+    | +------------------+  +-------------------+ |    |           |    |           |
  |           |    | | Scalar DL Ledger |  | Scalar DL Auditor | |    | Cassandra |    | Cassandra |
  |  Client   |    | +------------------+  +-------------------+ |    | Container |    | Container |
  | Container |    |                                             |    | (Ledger)  |    | (Auditor) |
  |           |    |            Kubernetes (minikube)            |    |           |    |           |
  +-----+-----+    +----------------------+----------------------+    +-----+-----+    +-----+-----+
        |                                 |                                 |                |
*-------+---------------------------------+---------------------------------+----------------+-------*
             ------->                                           ------->
               gRPC                                          Cassandra Driver
```

## Step 1. Create the Scalar DL Ledger environment

First, you need to create a Scalar DL Ledger environment with Auditor configuration.  
Please refer to the `Step 1` ~ `Step 7` of [Getting Started with Helm Charts (Scalar DL Ledger)](./getting-started-scalardl-ledger.md) to create a Ledger environment.  
To enable Auditor configuration in the Scalar DL Ledger, set `true` to `ledger.scalarLedgerConfiguration.ledgerAuditorEnabled` in `Step 7` of the above guide.  

After this step, we will create (add) a Scalar DL Auditor environment into the above Scalar DL Ledger environment.  
Also, after this step, we call `Scalar DL Ledger` as `Ledger` and `Scalar DL Auditor` as `Auditor`.  

## Step 2. Start Cassandra container for Auditor

In this guide, we use Apache Cassandra as backend storage of the Auditor, it will be started on the same network of Auditor (pod on minikube) to enable proper communication.

1. Start Cassandra container for Auditor on the Docker Network `minikube`.
   ```console
   $ docker run --name cassandra-auditor --network minikube -d cassandra:3.11
   ```
   * Note: 
       * The Docker Network `minikube` was created by the `minikube start --driver=docker` command that we ran in Step 1.
       * Scalar DL uses Scalar DB in its internal. You need to specify the Scalar DB-supported Cassandra version (tag).
           * You can see the Scalar DB version of Scalar DL from the [build.gradle](https://github.com/scalar-labs/scalar/blob/master/build.gradle) file (see the value of `scalarDbVersion`).
           * Also, you can see the Scalar DB-supported Cassandra versions (tag) in [this document](https://github.com/scalar-labs/scalardb/blob/master/docs/scalardb-supported-databases.md).

1. Check the status of the Cassandra container.
   ```console
   $ docker ps -f name=cassandra-auditor
   CONTAINER ID   IMAGE            COMMAND                  CREATED          STATUS          PORTS                                         NAMES
   2a1d2770bf72   cassandra:3.11   "docker-entrypoint.s…"   6 seconds ago    Up 4 seconds    7000-7001/tcp, 7199/tcp, 9042/tcp, 9160/tcp   cassandra-auditor
   ```

1. Check the status of Cassandra.
   ```console
   $ docker exec -t cassandra-auditor cqlsh -e "show version"
   [cqlsh 5.0.1 | Cassandra 3.11.11 | CQL spec 3.4.4 | Native protocol v4]
   ```
   It may take some time to start Cassandra in the container. So, if this command returns an error, wait a moment and then re-run it.

## Step 3. Create key/certificate files for Auditor

In this section, we will create key/certificate files for Auditor.  

* Note: 
    * In this guide, we will use self-sign certificates for the test. However, it is strongly recommended that these certificates NOT be used in production.
    * We assume that you already made a working directory and create key/certificate files for Ledger and Client in the [Getting Started with Helm Charts (Scalar DL Ledger)](./getting-started-scalardl-ledger.md).

1. Change working directory to `certs/`.
   ```console
   $ cd ~/scalardl-test/certs/
   ```

1. Create a JSON file that includes Auditor information.
   ```console
   $ cat << EOF > ~/scalardl-test/certs/auditor.json
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

1. Create key/certificate files for the Auditor.
   ```console
   $ cfssl selfsign "" ./auditor.json | cfssljson -bare auditor
   ```

1. Confirm key/certificate files are created.
   ```console
   $ ls -1
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

## Step 4. Create DB schema for Auditor by Helm Charts

In this section, we will deploy Scalar DL Schema Loader on minikube by using Helm Charts.  
The Scalar DL Schema Loader will create the DB schema in the Cassandra for Auditor.  

1. Change working directory from `certs/`.
   ```console
   $ cd ~/scalardl-test/
   ```

1. Create a custom value file for Scalar DL Schema Loader for Auditor (schema-loader-auditor-custom-values.yaml).
   ```console
   $ cat << EOF > schema-loader-auditor-custom-values.yaml
   schemaLoading:
     database: "cassandra"
     contactPoints: "cassandra-auditor"
     username: "cassandra"
     password: "cassandra"
     schemaType: "auditor"
   EOF
   ```

1. Deploy Scalar DL Schema Loader for Auditor.
   ```console
   $ helm install schema-loader-auditor scalar-labs/schema-loading -f ./schema-loader-auditor-custom-values.yaml
   ```

1. Check the Scalar DL Schema Loader pod is deployed and completed.
   ```console
   $ kubectl get pod | grep schema-loader-auditor
   schema-loader-auditor-schema-loading-9v5m7   0/1     Completed   0          10m
   ```
   If the Scalar DL Schema Loader pod (schema-loader-auditor-schema-loading-xxxxx) is `ContainerCreating` or `Running`, wait for the process will be completed (The STATUS will be `Completed`).

## Step 5. Deploy Auditor on minikube by Helm Charts

In this section, we will deploy Auditor on minikube by using Helm Charts.  

1. Create a custom value file for Auditor (scalardl-auditor-custom-values.yaml).
   ```console
   $ cat << EOF > scalardl-auditor-custom-values.yaml
   envoy:
     service:
       type: "NodePort"
   
   auditor:
     scalarAuditorConfiguration:
       dbStorage: "cassandra"
       dbContactPoints: "cassandra-auditor"
       dbUsername: "cassandra"
       dbPassword: "cassandra"
       auditorLedgerHost: "scalardl-ledger-envoy"
   EOF
   ```
   * Note:
       * If you want to access Auditor from 127.0.0.1 (your localhost), set `LoadBalancer` to `envoy.service.type` like the following.
         ```yaml
         envoy:
           service:
             type: "LoadBalancer"
         
         auditor:
           scalarAuditorConfiguration:
             dbStorage: "cassandra"
             dbContactPoints: "cassandra-auditor"
             dbUsername: "cassandra"
             dbPassword: "cassandra"
             auditorLedgerHost: "scalardl-ledger-envoy"
         ```

1. Create secret resource `auditor-keys`.
   ```console
   $ kubectl create secret generic auditor-keys --from-file=certificate=./certs/auditor.pem --from-file=private-key=./certs/auditor-key.pem
   ```

1. Deploy Auditor.
   ```console
   $ helm install scalardl-auditor scalar-labs/scalardl-audit -f ./scalardl-auditor-custom-values.yaml
   ```

1. Check the Auditor pods are deployed.
   ```console
   $ kubectl get pod
   NAME                                         READY   STATUS      RESTARTS   AGE
   scalardl-auditor-auditor-99b94bb75-7fjmb     1/1     Running     0          3m1s
   scalardl-auditor-auditor-99b94bb75-jbp7c     1/1     Running     0          3m1s
   scalardl-auditor-auditor-99b94bb75-trq66     1/1     Running     0          3m1s
   scalardl-auditor-envoy-55bfcbb76b-4bkdp      1/1     Running     0          3m1s
   scalardl-auditor-envoy-55bfcbb76b-552hd      1/1     Running     0          3m1s
   scalardl-auditor-envoy-55bfcbb76b-cqx98      1/1     Running     0          3m1s
   scalardl-ledger-envoy-84dcc85b6d-jzkjr       1/1     Running     0          18m
   scalardl-ledger-envoy-84dcc85b6d-l4r66       1/1     Running     0          18m
   scalardl-ledger-envoy-84dcc85b6d-nz25m       1/1     Running     0          18m
   scalardl-ledger-ledger-6dbc56c7b5-nsmxv      1/1     Running     0          18m
   scalardl-ledger-ledger-6dbc56c7b5-rxnjz      1/1     Running     0          18m
   scalardl-ledger-ledger-6dbc56c7b5-szqc2      1/1     Running     0          18m
   schema-loader-auditor-schema-loading-9v5m7   0/1     Completed   0          15m
   schema-loader-ledger-schema-loading-dgksb    0/1     Completed   0          19m
   ```
   If the Auditor pods are deployed properly, you can see the STATUS are `Running`.  

1. Check the Auditor Services are deployed.
   ```console
   $ kubectl get svc
   NAME                             TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)                           AGE
   kubernetes                       ClusterIP   10.96.0.1       <none>        443/TCP                           25m
   scalardl-auditor-envoy           NodePort    10.101.34.229   <none>        40051:30140/TCP,40052:30599/TCP   3m32s
   scalardl-auditor-envoy-metrics   ClusterIP   10.97.47.11     <none>        9001/TCP                          3m32s
   scalardl-auditor-headless        ClusterIP   None            <none>        50051/TCP,50053/TCP,50052/TCP     3m32s
   scalardl-auditor-metrics         ClusterIP   10.103.88.93    <none>        8080/TCP                          3m32s
   scalardl-ledger-envoy            NodePort    10.97.160.80    <none>        50051:32468/TCP,50052:30626/TCP   19m
   scalardl-ledger-envoy-metrics    ClusterIP   10.97.83.78     <none>        9001/TCP                          19m
   scalardl-ledger-headless         ClusterIP   None            <none>        50051/TCP,50053/TCP,50052/TCP     19m
   scalardl-ledger-metrics          ClusterIP   10.111.170.92   <none>        8080/TCP                          19m
   ```
   If the Auditor Services are deployed properly, you can see private IP addresses in the CLUSTER-IP column. (Note: `scalardl-auditor-headless` has no CLUSTER-IP.)  

1. (Optional) If you set `LoadBalancer` to `envoy.service.type` in the `scalardl-auditor-custom-values.yaml`, you can access Auditor from 127.0.0.1.  
   To expose the `scalardl-auditor-envoy` service as your local `127.0.0.1:40051` and `127.0.0.1:40052`, open another terminal, and run the `minikube tunnel` command.
   ```console
   $ minikube tunnel
   ```
   After running the `minikube tunnel` command, you can see the  EXTERNAL-IP of the `scalardl-auditor-envoy` as  `127.0.0.1`.
   ```console
   $ kubectl get svc scalardl-auditor-envoy
   NAME                     TYPE           CLUSTER-IP      EXTERNAL-IP   PORT(S)                           AGE
   scalardl-auditor-envoy   LoadBalancer   10.101.34.229   127.0.0.1     40051:30140/TCP,40052:30599/TCP   5m28s
   ```

## Step 6. Start Client container

In this section, we will create a Client container to run a sample contract of Scalar DL.  
We will use certificate files in the Client container. So, mount ~/scalardl-test/certs to the Client container.  

1. Start the Client container on the Docker Network `minikube`.
   ```console
   $ docker run -d --name scalardl-client --hostname scalardl-client -v ~/scalardl-test/certs:/certs --network minikube --entrypoint sleep ubuntu:20.04 inf
   ```

1. Check the Client container is running.
   ```console
   $ docker ps -f name=scalardl-client
   ```

## Step 7. Run Scalar DL sample contracts in the Client container

In this section, we will prepare and run the Scalar DL sample contract.  
* Note: 
   * When you use Auditor, you need to register the certificate for the Ledger and Auditor before starting the client application.  
   * The Ledger needs to register its certificate to Auditor, and the Auditor needs to register its certificate to Ledger.

This guide explains the minimum steps. If you want to know more details about Scalar DL and the contract, please refer to the [Getting Started with Scalar DL Auditor](https://github.com/scalar-labs/scalardl/blob/master/docs/getting-started-auditor.md).

1. Run bash in the Client container.
   ```console
   $ docker exec -it scalardl-client bash
   ```
   After this step, run each command in the Client container.  

1. Install Git, OpenJDK 8, curl, and unzip in the Client container.
   ```console
   # apt update && DEBIAN_FRONTEND="noninteractive" TZ="Etc/UTC" apt install -y git openjdk-8-jdk curl unzip
   ```

1. Clone Scalar DL Java Client SDK's git repository.
   ```console
   # git clone https://github.com/scalar-labs/scalardl-java-client-sdk.git
   ```

1. Change directory to `scalardl-java-client-sdk/`.
   ```console
   # cd scalardl-java-client-sdk/ 
   # pwd
   /scalardl-java-client-sdk
   ```

1. Change branch to arbitrary version.
   ```
   # git checkout -b v3.4.0 refs/tags/v3.4.0
   # git branch
     master
   * v3.4.0
   ```
   If you want to use another version, please specify the version (tag) you want to use. You need to use the same version of Scalar DL (Ledger and Auditor) and Scalar DL Java Client SDK.

1. Build the sample contract.
   ```console
   # ./gradlew assemble
   ```

1. Download CLI tools of Scalar DL from [Scalar DL Java Client SDK Releases](https://github.com/scalar-labs/scalardl-java-client-sdk/releases).
   ```console
   # curl -OL https://github.com/scalar-labs/scalardl-java-client-sdk/releases/download/v3.4.0/scalardl-java-client-sdk-3.4.0.zip
   ```
   You need to use the same version of CLI tools and Scalar DL (Ledger and Auditor).

1. Unzip the scalardl-java-client-sdk-3.4.0.zip file.
   ```console
   # unzip ./scalardl-java-client-sdk-3.4.0.zip
   ```

1. Create a configuration file (ledger.as.client.properties) to register the certificate of Ledger to Auditor.
   ```console
   # cat << EOF > ledger.as.client.properties
   # Ledger
   scalar.dl.client.server.host=minikube
   scalar.dl.client.server.port=32468
   scalar.dl.client.server.privileged_port=30626
   
   # Auditor
   scalar.dl.client.auditor.enabled=true
   scalar.dl.client.auditor.host=minikube
   scalar.dl.client.auditor.port=30140
   scalar.dl.client.auditor.privileged_port=30599
   
   # Certificate
   scalar.dl.client.cert_holder_id=ledger
   scalar.dl.client.cert_path=../certs/ledger.pem
   scalar.dl.client.private_key_path=../certs/ledger-key.pem
   EOF
   ```
   * Note:
       * You need to specify the port number (NodePort) of `scalardl-ledger-envoy` (Kubernetes Service Resource) as a value of `scalar.dl.client.server.port` and `scalar.dl.client.server.privileged_port` in each `*.properties`. You can confirm the port number of `scalardl-ledger-envoy` with the `kubectl get svc scalardl-ledger-envoy` command.
         ```console
         $ kubectl get svc scalardl-ledger-envoy
         NAME                    TYPE       CLUSTER-IP     EXTERNAL-IP   PORT(S)                           AGE
         scalardl-ledger-envoy   NodePort   10.97.160.80   <none>        50051:32468/TCP,50052:30626/TCP   30m
         ```
         In this case, you need to specify `32468` to `scalar.dl.client.server.port` and `30626` to `scalar.dl.client.server.privileged_port` in the `*.properties` file.
       * Also, you need to specify the port number (NodePort) of `scalardl-auditor-envoy` (Kubernetes Service Resource) as a value of `scalar.dl.client.auditor.port` and `scalar.dl.client.auditor.privileged_port` in each `*.properties`. You can confirm the port number of `scalardl-auditor-envoy` with the `kubectl get svc scalardl-auditor-envoy` command.
         ```console
         $ kubectl get svc scalardl-auditor-envoy
         NAME                     TYPE       CLUSTER-IP      EXTERNAL-IP   PORT(S)                           AGE
         scalardl-auditor-envoy   NodePort   10.101.34.229   <none>        40051:30140/TCP,40052:30599/TCP   15m
         ```
         In this case, you need to specify `30140` to `scalar.dl.client.auditor.port` and `30599` to `scalar.dl.client.auditor.privileged_port` in the `*.properties` file.

1. Create a configuration file (auditor.as.client.properties) to register the certificate of Auditor to Ledger.
   ```console
   # cat << EOF > auditor.as.client.properties
   # Ledger
   scalar.dl.client.server.host=minikube
   scalar.dl.client.server.port=32468
   scalar.dl.client.server.privileged_port=30626
   
   # Auditor
   scalar.dl.client.auditor.enabled=true
   scalar.dl.client.auditor.host=minikube
   scalar.dl.client.auditor.port=30140
   scalar.dl.client.auditor.privileged_port=30599
   
   # Certificate
   scalar.dl.client.cert_holder_id=auditor
   scalar.dl.client.cert_path=../certs/auditor.pem
   scalar.dl.client.private_key_path=../certs/auditor-key.pem
   EOF
   ```

1. Create a configuration file (client.properties) to access Scalar DL (Ledger and Auditor) on minikube.
   ```console
   # cat << EOF > client.properties
   # Ledger
   scalar.dl.client.server.host=minikube
   scalar.dl.client.server.port=32468
   scalar.dl.client.server.privileged_port=30626
   
   # Auditor
   scalar.dl.client.auditor.enabled=true
   scalar.dl.client.auditor.host=minikube
   scalar.dl.client.auditor.port=30140
   scalar.dl.client.auditor.privileged_port=30599
   
   # Certificate
   scalar.dl.client.cert_holder_id=client
   scalar.dl.client.cert_path=../certs/client.pem
   scalar.dl.client.private_key_path=../certs/client-key.pem
   EOF
   ```

1. Register certificate file of Ledger.
   ```console
   # ./scalardl-java-client-sdk-3.4.0/bin/register-cert --properties ./ledger.as.client.properties
   ```

1. Register certificate file of Auditor.
   ```console
   # ./scalardl-java-client-sdk-3.4.0/bin/register-cert --properties ./auditor.as.client.properties
   ```

1. Register certificate file of client.
   ```console
   # ./scalardl-java-client-sdk-3.4.0/bin/register-cert --properties ./client.properties
   ```

1. Register sample contract `StateUpdater`.
   ```console
   # ./scalardl-java-client-sdk-3.4.0/bin/register-contract --properties ./client.properties --contract-id StateUpdater --contract-binary-name com.org1.contract.StateUpdater --contract-class-file ./build/classes/java/main/com/org1/contract/StateUpdater.class
   ```

1. Register sample contract `StateReader`.
   ```console
   # ./scalardl-java-client-sdk-3.4.0/bin/register-contract --properties ./client.properties --contract-id StateReader --contract-binary-name com.org1.contract.StateReader --contract-class-file ./build/classes/java/main/com/org1/contract/StateReader.class
   ```

1. Execute contract `StateUpdater`.
   ```console
   # ./scalardl-java-client-sdk-3.4.0/bin/execute-contract --properties ./client.properties --contract-id StateUpdater --contract-argument '{"asset_id": "test_asset", "state": 3}'
   ```
   This sample contract updates the `state` (value) of the asset named `test_asset` to `3`.  

1. Execute contract `StateReader`.
   ```console
   # ./scalardl-java-client-sdk-3.4.0/bin/execute-contract --properties ./client.properties --contract-id StateReader --contract-argument '{"asset_id": "test_asset"}'
   {
       "status_code": "OK",
       "output": {
           "age": 0,
           "input": {
           },
           "output": {
               "state": 3
           },
           "contract_id": "client/1/StateUpdater",
           "argument": {
               "asset_id": "test_asset",
               "state": 3,
               "nonce": "ef041eb4-f9c3-455a-9dab-0f081a01d13b"
           },
           "signature": "MEUCIEzeQzX3poEfM6dlgmaLIMlMI0efnsYTfY25nru1DSeXAiEAiszgxFIO3Gv4yxBI6Sy/zph1pnnwQJRuGifio09fQOg=",
           "hash": "zqm/vXPC8o5mL5YUaAPOrIYK/qBd3kXVjHXUH7rdjnE=",
           "prev_hash": ""
       },
       "error_message": null
   }
   ```
   * Reference information
       * If the asset data is not tampered with, the contract execution request (execute-contract command) returns `OK` as a result.
       * If the asset data is tampered with (e.g. the `state` value in the DB is tampered with), the contract execution request (execute-contract command) returns a value other than `OK`  (e.g. `INCONSISTENT_STATES`) as a result, like the following.
         ```console
         # ./scalardl-java-client-sdk-3.4.0/bin/execute-contract --properties ./client.properties --contract-id StateReader --contract-argument '{"asset_id": "test_asset"}'
         {
             "status_code": "INCONSISTENT_STATES",
             "output": null,
             "error_message": "The results from Ledger and Auditor don't match"
         }
         ```
           * In this way, the Scalar DL can detect data tampering.

1. Execute validation request of the asset.
   ```console
   # ./scalardl-java-client-sdk-3.4.0/bin/validate-ledger --properties ./client.properties --asset-id "test_asset"
   {
       "status_code": "OK",
       "Ledger": {
           "id": "test_asset",
           "age": 0,
           "nonce": "ef041eb4-f9c3-455a-9dab-0f081a01d13b",
           "hash": "zqm/vXPC8o5mL5YUaAPOrIYK/qBd3kXVjHXUH7rdjnE=",
           "signature": "MEQCIB0lHtURoLYSz0vSpV4BhYmYBqzeSrYekN/GdP+quBLtAiBeQWMeLDEdxzeIoAkD/Cbi3zbIDud8CjK6gN/IpQKW0Q=="
       },
       "Auditor": {
           "id": "test_asset",
           "age": 0,
           "nonce": "ef041eb4-f9c3-455a-9dab-0f081a01d13b",
           "hash": "zqm/vXPC8o5mL5YUaAPOrIYK/qBd3kXVjHXUH7rdjnE=",
           "signature": "MEQCIBP312FoK5pX/eSzNiJ+zCJA5PVjlbFVmMYujEESy978AiATC19Fo6Y/YGWIFgDKdfIZhLAcUcHeyNloU1YQqJBy3Q=="
       },
       "error_message": null
   }
   ```
   * Reference information
       * If the asset data is not tampered with, the validation request (validate-ledger command) returns `OK` as a result.
       * If the asset data is tampered with (e.g. the `state` value in the DB is tampered with), the validation request (validate-ledger command) returns a value other than `OK` (e.g. `INVALID_OUTPUT`) as a result, like the following.
         ```console
         # ./scalardl-java-client-sdk-3.4.0/bin/validate-ledger --properties ./client.properties --asset-id "test_asset"
         {
             "status_code": "INVALID_OUTPUT",
             "output": null,
             "error_message": "Validation failed."
         }
         ```
           * In this way, the Scalar DL can detect data tampering.

## Step 8. Delete all resources

After completing the Scalar DL Auditor tests on minikube, remove all resources.

1. Uninstall Scalar DL Schema Loader, Ledger, and Auditor from minikube.
   ```console
   $ helm uninstall schema-loader-ledger schema-loader-auditor scalardl-ledger scalardl-auditor
   ```

1. Stop and remove containers (Cassandra and Client).
   ```
   $ docker rm $(docker kill scalardl-client cassandra-ledger cassandra-auditor)
   ```

1. Remove working directory and sample files (configuration file, key, and certificate).
   ```console
   $ cd ~
   $ rm -rf ~/scalardl-test/
   ```

1. Delete minikube.
   ```console
   $ minikube delete --all
   ```

