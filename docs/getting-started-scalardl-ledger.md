# Getting Started with Helm Charts (Scalar DL Ledger)

This document explains how to get started with Scalar DL Ledger using the Helm Chart in your test environment. Here, we assume that you already have a Mac or Linux environment for testing.  

## Requirement

* You need the privileges to pull the Scalar DL containers (`scalar-ledger` and `scalardl-schema-loader`) from [GitHub Packages](https://github.com/orgs/scalar-labs/packages).  
* You must create a Github Personal Access Token (PAT) with `read:packages` scope according to the [GitHub document](https://docs.github.com/en/github/authenticating-to-github/keeping-your-account-and-data-secure/creating-a-personal-access-token) to pull the above containers.

## Environment

We will create the following environment in your local by using Docker and minikube.  

```
On the Docker Network (named minikube)

                   +-----------------------+
  +-----------+    | +------------------+  |    +-----------+
  |           |    | | Scalar DL Ledger |  |    |           |
  |  Client   |    | +------------------+  |    | Cassandra |
  | Container |    |                       |    | Container |
  |           |    | Kubernetes (minikube) |    |           |
  +-----+-----+    +-----------+-----------+    +-----+-----+
        |                      |                      |
*-------+----------------------+----------------------+-------*
             ------->                     ------->
               gRPC                    Cassandra Driver
```

## Step 1. Start minikube

First, you need to prepare a `minikube` environment according to [Getting Started with Scalar Helm Charts](./getting-started-scalar-helm-charts.md). If you have already started the `minikube`, you can skip this step.

## Step 2. Start Cassandra container

We use Apache Cassandra as the backend storage of Scalar DL Ledger. We start a Cassandra container on the same network of Kubernetes (Scalar DL Ledger Pod on minikube) to make them communicate properly.

1. Start a Cassandra container on the Docker Network `minikube`.
   ```console
   docker run --name cassandra-ledger --network minikube -d cassandra:3.11
   ```
   * Note: 
       * The Docker Network `minikube` was created by the `minikube start --driver=docker` command that we ran in Step 2.
       * Scalar DL uses Scalar DB in its internal. You need to specify the Scalar DB-supported Cassandra version (tag).
           * You can see the Scalar DB version of Scalar DL from the [build.gradle](https://github.com/scalar-labs/scalar/blob/master/build.gradle) file (see the value of `scalarDbVersion`).
           * Also, you can see the Scalar DB-supported Cassandra versions (tag) in [this document](https://github.com/scalar-labs/scalardb/blob/master/docs/scalardb-supported-databases.md).

1. Check if the Cassandra container is running.
   ```console
   docker ps -f name=cassandra-ledger
   ```
   [Command execution result]
   ```console
   CONTAINER ID   IMAGE            COMMAND                  CREATED         STATUS         PORTS                                         NAMES
   6dceab0007c8   cassandra:3.11   "docker-entrypoint.s???"   2 minutes ago   Up 2 minutes   7000-7001/tcp, 7199/tcp, 9042/tcp, 9160/tcp   cassandra-ledger
   ```

1. Check the status of Cassandra.
   ```console
   docker exec -t cassandra-ledger cqlsh -e "show version"
   ```
   [Command execution result]
   ```console
   [cqlsh 5.0.1 | Cassandra 3.11.11 | CQL spec 3.4.4 | Native protocol v4]
   ```
   It may take a while to start Cassandra in the container. So, if this command returns an error, wait a moment and then re-run it.

## Step 3. Create working directory

We will create some configuration files and key/certificate files locally. So, create a working directory for it.

1. Create working directory.
   ```console
   mkdir ~/scalardl-test
   ```

## Step 4. Create key/certificate files

* Note: 
    * In this guide, we will use self-sign certificates for the test. However, it is strongly recommended that these certificates NOT be used in production.

1. Create `certs/` directory.
   ```console
   mkdir ~/scalardl-test/certs/
   ```
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


## Step 5. Create DB schema for Scalar DL Ledger by Helm Charts

We will deploy a Scalar DL Schema Loader on minikube by using Helm Charts.  
The Scalar DL Schema Loader will create the DB schema for Scalar DL Ledger in the Cassandra.  

1. Change working directory from `certs/`.
   ```console
   cd ~/scalardl-test/
   ```

1. Add the Scalar Helm Repository.
   ```console
   helm repo add scalar-labs https://scalar-labs.github.io/helm-charts
   ```

1. Create secret resource `reg-docker-secrets` to pull the Scalar DL container images from GitHub Packages.
   ```console
   kubectl create secret docker-registry reg-docker-secrets --docker-server=ghcr.io --docker-username=<github-username> --docker-password=<github-personal-access-token>
   ```

1. Create a custom value file for Scalar DL Schema Loader (schema-loader-ledger-custom-values.yaml).
   ```console
   cat << EOF > schema-loader-ledger-custom-values.yaml
   schemaLoading:
     database: "cassandra"
     contactPoints: "cassandra-ledger"
     username: "cassandra"
     password: "cassandra"
     schemaType: "ledger"
   EOF
   ```

1. Deploy the Scalar DL Schema Loader.
   ```console
   helm install schema-loader-ledger scalar-labs/schema-loading -f ./schema-loader-ledger-custom-values.yaml
   ```

1. Check if the Scalar DL Schema Loader pod is deployed and completed.
   ```console
   kubectl get pod
   ```
   [Command execution result]
   ```console
   NAME                                        READY   STATUS      RESTARTS   AGE
   schema-loader-ledger-schema-loading-cscr4   0/1     Completed   0          19s
   ```
   If the Scalar DL Schema Loader pod is `ContainerCreating` or `Running`, wait for the process will be completed (The STATUS will be `Completed`).

## Step 6. Deploy Scalar DL Ledger on the Kubernetes (minikube) using Helm Charts

1. Create a custom value file for Scalar DL Ledger (scalardl-ledger-custom-values.yaml).
   ```console
   cat << EOF > scalardl-ledger-custom-values.yaml
   envoy:
     service:
       type: "NodePort"
   
   ledger:
     scalarLedgerConfiguration:
       dbStorage: "cassandra"
       dbContactPoints: "cassandra-ledger"
       dbUsername: "cassandra"
       dbPassword: "cassandra"
       ledgerProofEnabled: true
   EOF
   ```
   * Note:
       * If you want to access Scalar DL Ledger from 127.0.0.1 (your localhost), set `LoadBalancer` to `envoy.service.type` like the following.
         ```console
         cat << EOF > scalardl-ledger-custom-values.yaml
         envoy:
           service:
             type: "LoadBalancer"
         
         ledger:
           scalarLedgerConfiguration:
             dbStorage: "cassandra"
             dbContactPoints: "cassandra-ledger"
             dbUsername: "cassandra"
             dbPassword: "cassandra"
             ledgerProofEnabled: true
         EOF
         ```
       * If you want to use Scalar DL Auditor, set `true` to `ledger.scalarLedgerConfiguration.ledgerAuditorEnabled`.
         ```console
         cat << EOF > scalardl-ledger-custom-values.yaml
         envoy:
           service:
             type: "NodePort"
         
         ledger:
           scalarLedgerConfiguration:
             dbStorage: "cassandra"
             dbContactPoints: "cassandra-ledger"
             dbUsername: "cassandra"
             dbPassword: "cassandra"
             ledgerProofEnabled: true
             ledgerAuditorEnabled: true
         EOF
         ```

1. Create secret resource `ledger-keys`.
   ```console
   kubectl create secret generic ledger-keys --from-file=private-key=./certs/ledger-key.pem
   ```

1. Deploy the Scalar DL Ledger.
   ```console
   helm install scalardl-ledger scalar-labs/scalardl -f ./scalardl-ledger-custom-values.yaml
   ```

1. Check if the Scalar DL Ledger pods are deployed.
   ```console
   kubectl get pod
   ```
   [Command execution result]
   ```console
   NAME                                        READY   STATUS      RESTARTS   AGE
   scalardl-ledger-envoy-84dcc85b6d-bs2xl      1/1     Running     0          5m55s
   scalardl-ledger-envoy-84dcc85b6d-btc8c      1/1     Running     0          5m55s
   scalardl-ledger-envoy-84dcc85b6d-c2nnp      1/1     Running     0          5m55s
   scalardl-ledger-ledger-57dcb56f58-dgcjs     1/1     Running     0          5m55s
   scalardl-ledger-ledger-57dcb56f58-fdnvm     1/1     Running     0          5m55s
   scalardl-ledger-ledger-57dcb56f58-mtrfc     1/1     Running     0          5m55s
   schema-loader-ledger-schema-loading-cscr4   0/1     Completed   0          8m16s
   ```
   If the Scalar DL Ledger pods are deployed properly, you can see the STATUS are `Running`.  

1. Check if the Scalar DL Ledger Services are deployed.
   ```console
   kubectl get svc
   ```
   [Command execution result]
   ```console
   NAME                            TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)                           AGE
   kubernetes                      ClusterIP   10.96.0.1        <none>        443/TCP                           21h
   scalardl-ledger-envoy           NodePort    10.98.162.209    <none>        50051:31452/TCP,50052:31118/TCP   6m23s
   scalardl-ledger-envoy-metrics   ClusterIP   10.105.122.178   <none>        9001/TCP                          6m23s
   scalardl-ledger-headless        ClusterIP   None             <none>        50051/TCP,50053/TCP,50052/TCP     6m23s
   scalardl-ledger-metrics         ClusterIP   10.110.55.239    <none>        8080/TCP                          6m23s
   ```
   If the Scalar DL Ledger Services are deployed properly, you can see private IP addresses in the CLUSTER-IP column. (Note: `scalardl-ledger-headless` has no CLUSTER-IP.)  

1. (Optional) If you set `LoadBalancer` to `envoy.service.type` in the `scalardl-ledger-custom-values.yaml`, you can access Scalar DL Ledger from 127.0.0.1.  
   To expose the `scalardl-ledger-envoy` service as your local `127.0.0.1:50051` and `127.0.0.1:50052`, open another terminal, and run the `minikube tunnel` command.
   ```console
   minikube tunnel
   ```
   After running the `minikube tunnel` command, you can see the  EXTERNAL-IP of the `scalardl-ledger-envoy` as  `127.0.0.1`.
   ```console
   kubectl get svc scalardl-ledger-envoy
   ```
   [Command execution result]
   ```console
   NAME                    TYPE           CLUSTER-IP      EXTERNAL-IP   PORT(S)                           AGE
   scalardl-ledger-envoy   LoadBalancer   10.98.162.209   127.0.0.1     50051:31452/TCP,50052:31118/TCP   9m7s
   ```

## Step 7. Start Client container

We will use certificate files in the Client container. So, we mount ~/scalardl-test/certs directory to the Client container.  

1. Start a Client container on the `minikube` network.
   ```console
   docker run -d --name scalardl-client --hostname scalardl-client -v ~/scalardl-test/certs:/certs --network minikube --entrypoint sleep ubuntu:20.04 inf
   ```

1. Check if the Client container is running.
   ```console
   docker ps -f name=scalardl-client
   ```

## Step 8. Run Scalar DL sample contracts in the Client container

The following explains the minimum steps. If you want to know more details about Scalar DL and the contract, please refer to the [Getting Started with Scalar DL](https://github.com/scalar-labs/scalardl/blob/master/docs/getting-started.md).

1. Run bash in the Client container.
   ```console
   docker exec -it scalardl-client bash
   ```
   After this step, run each command in the Client container.  

1. Install Git, OpenJDK 8, curl, and unzip in the Client container.
   ```console
   apt update && DEBIAN_FRONTEND="noninteractive" TZ="Etc/UTC" apt install -y git openjdk-8-jdk curl unzip
   ```

1. Clone Scalar DL Java Client SDK git repository.
   ```console
   git clone https://github.com/scalar-labs/scalardl-java-client-sdk.git
   ```

1. Change directory to `scalardl-java-client-sdk/`.
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
   git checkout -b v3.4.0 refs/tags/v3.4.0
   ```
   ```console
   git branch
   ```
   [Command execution result]
   ```console
     master
   * v3.4.0
   ```
   If you want to use another version, please specify the version (tag) you want to use. You need to use the same version of Scalar DL Ledger and Scalar DL Java Client SDK.

1. Build the sample contract.
   ```console
   ./gradlew assemble
   ```

1. Download CLI tools of Scalar DL from [Scalar DL Java Client SDK Releases](https://github.com/scalar-labs/scalardl-java-client-sdk/releases).
   ```console
   curl -OL https://github.com/scalar-labs/scalardl-java-client-sdk/releases/download/v3.4.0/scalardl-java-client-sdk-3.4.0.zip
   ```
   You need to use the same version of CLI tools and Scalar DL Ledger.

1. Unzip the scalardl-java-client-sdk-3.4.0.zip file.
   ```console
   unzip ./scalardl-java-client-sdk-3.4.0.zip
   ```

1. Create a configuration file (client.properties) to access Scalar DL Ledger on minikube.
   ```console
   cat << EOF > client.properties
   scalar.dl.client.server.host=minikube
   scalar.dl.client.server.port=31452
   scalar.dl.client.server.privileged_port=31118
   scalar.dl.client.cert_holder_id=client
   scalar.dl.client.cert_path=../certs/client.pem
   scalar.dl.client.private_key_path=../certs/client-key.pem
   EOF
   ```
   * Note:
       * You need to specify the port number (NodePort) of `scalardl-ledger-envoy` (Kubernetes Service Resource) as a value of `scalar.dl.client.server.port` and `scalar.dl.client.server.privileged_port` in the `client.properties`. You can confirm the port number of `scalardl-ledger-envoy` with the `kubectl get svc scalardl-ledger-envoy` command.
         ```console
         kubectl get svc scalardl-ledger-envoy
         ```
         [Command execution result]
         ```console
         NAME                    TYPE       CLUSTER-IP      EXTERNAL-IP   PORT(S)                           AGE
         scalardl-ledger-envoy   NodePort   10.98.162.209   <none>        50051:31452/TCP,50052:31118/TCP   21m
         ```
         In this case, you need to specify `31452` to `scalar.dl.client.server.port` and `31118` to `scalar.dl.client.server.privileged_port` in the `client.properties` file.

1. Register the certificate file of client.
   ```console
   ./scalardl-java-client-sdk-3.4.0/bin/register-cert --properties ./client.properties
   ```

1. Register the sample contract `StateUpdater`.
   ```console
   ./scalardl-java-client-sdk-3.4.0/bin/register-contract --properties ./client.properties --contract-id StateUpdater --contract-binary-name com.org1.contract.StateUpdater --contract-class-file ./build/classes/java/main/com/org1/contract/StateUpdater.class
   ```

1. Register the sample contract `StateReader`.
   ```console
   ./scalardl-java-client-sdk-3.4.0/bin/register-contract --properties ./client.properties --contract-id StateReader --contract-binary-name com.org1.contract.StateReader --contract-class-file ./build/classes/java/main/com/org1/contract/StateReader.class
   ```

1. Execute the contract `StateUpdater`.
   ```console
   ./scalardl-java-client-sdk-3.4.0/bin/execute-contract --properties ./client.properties --contract-id StateUpdater --contract-argument '{"asset_id": "test_asset", "state": 3}'
   ```
   This sample contract updates the `state` (value) of the asset named `test_asset` to `3`.  

1. Execute the contract `StateReader`.
   ```console
   ./scalardl-java-client-sdk-3.4.0/bin/execute-contract --properties ./client.properties --contract-id StateReader --contract-argument '{"asset_id": "test_asset"}'
   ```
   [Command execution result]
   ```console
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
               "nonce": "04c0cc2f-8f78-4ab3-afaa-ce8150af2c5b"
           },
           "signature": "MEYCIQD0ixVIP0Qr/ujMa9EBpRhxIIjCQ9MK/dTdQhz89HbtqwIhAICGzZauXprs5C/twNDYVqfZYj3SJP0V+LQFFIsSHcL9",
           "hash": "lGSUj1HPuqsxTs5RqkhcZVCrkr/1Tnm9IDTDs9z8C9E=",
           "prev_hash": ""
       },
       "error_message": null
   }
   ```

1. Execute a validation request of the asset.
   ```console
   ./scalardl-java-client-sdk-3.4.0/bin/validate-ledger --properties ./client.properties --asset-id "test_asset"
   ```
   [Command execution result]
   ```console
   {
       "status_code": "OK",
       "Ledger": {
           "id": "test_asset",
           "age": 0,
           "nonce": "04c0cc2f-8f78-4ab3-afaa-ce8150af2c5b",
           "hash": "lGSUj1HPuqsxTs5RqkhcZVCrkr/1Tnm9IDTDs9z8C9E=",
           "signature": "MEUCIGxosE88GLTP64JN/aa2gevAJl64oaesXZxAQIzY+RtRAiEA92wEUzqTJAa1iNLkwD5BUzaTMO3YhtP0wRhQLy2fpr4="
       },
       "Auditor": null,
       "error_message": null
   }
   ```
   * Reference information
       * If the asset data is not tampered with, the validation request (validate-ledger command) returns `OK` as a result.
       * If the asset data is tampered with (e.g. the `state` value in the DB is tampered with), the validation request (validate-ledger command) returns a value other than `OK` (e.g. `INVALID_OUTPUT`) as a result, like the following.
         ```console
         ./scalardl-java-client-sdk-3.4.0/bin/validate-ledger --properties ./client.properties --asset-id "test_asset"
         ```
         [Command execution result]
         ```console
         {
             "status_code": "INVALID_OUTPUT",
             "Ledger": {
                 "id": "test_asset",
                 "age": 0,
                 "nonce": "04c0cc2f-8f78-4ab3-afaa-ce8150af2c5b",
                 "hash": "lGSUj1HPuqsxTs5RqkhcZVCrkr/1Tnm9IDTDs9z8C9E=",
                 "signature": "MEUCIQDlOkpxKPvLxrAPIe8nwoSANTCDcENK5K7Na9cFgHOg2AIgDZTeNejDCjQL2Th4UByy5bVy0VG6ZLsGWWyZR5qPhWQ="
             },
             "Auditor": null,
             "error_message": null
         }
         ```
           * In this way, the Scalar DL Ledger can detect data tampering.

## Step 9. Delete all resources

After completing the Scalar DL Ledger tests on minikube, remove all resources.

1. Uninstall Scalar DL Schema Loader and Ledger from minikube.
   ```console
   helm uninstall schema-loader-ledger scalardl-ledger
   ```

1. Stop and remove containers (Cassandra and Client).
   ```
   docker rm $(docker kill scalardl-client cassandra-ledger)
   ```

1. Remove working directory and sample files (configuration file, key, and certificate).
   ```console
   cd ~
   ```
   ```console
   rm -rf ~/scalardl-test/
   ```

1. Delete minikube.
   ```console
   minikube delete --all
   ```

