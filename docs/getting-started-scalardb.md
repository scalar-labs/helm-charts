# Getting Started with Helm Charts (Scalar DB Server)

This document explains how to get started with Scalar DB Server using Helm Chart in your test environment. Here, we assume that you already have a Mac or Linux environment for testing.  

## Tools

We will use the following tools for testing.  

1. Docker
1. minikube
1. kubectl
1. Helm

## Environment

We will create the following environment in your local by using Docker and minikube.  

```
On the Docker Network (named minikube)

                   +-----------------------+
  +-----------+    | +------------------+  |    +-----------+
  |           |    | | Scalar DB Server |  |    |           |
  |  Client   |    | +------------------+  |    | Cassandra |
  | Container |    |                       |    | Container |
  |           |    | Kubernetes (minikube) |    |           |
  +-----+-----+    +-----------+-----------+    +-----+-----+
        |                      |                      |
*-------+----------------------+----------------------+-------*
             ------->                     ------->
               gRPC                    Cassandra Driver
```

## Step 1. Install tools

First, you need to install the following tools that will be used in this guide.  

1. Install the Docker according to the [Docker document](https://docs.docker.com/engine/install/)  

1. Install the minikube according to the [minikube document](https://minikube.sigs.k8s.io/docs/start/)  

1. Install the kubectl according to the [Kubernetes document](https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/)  

1. Install the helm command according to the [Helm document](https://helm.sh/docs/intro/install/)  

## Step 2. Start minikube with docker driver


1. Start minikube with docker driver.
   ```console
   $ minikube start --driver=docker
   ```

1. Check the status of the minikube and pods.
   ```console
   $ kubectl get pod -A
   NAMESPACE     NAME                               READY   STATUS    RESTARTS        AGE
   kube-system   coredns-64897985d-6jw6c            1/1     Running   0               3m27s
   kube-system   etcd-minikube                      1/1     Running   27              3m38s
   kube-system   kube-apiserver-minikube            1/1     Running   27              3m38s
   kube-system   kube-controller-manager-minikube   1/1     Running   27              3m38s
   kube-system   kube-proxy-5vcnc                   1/1     Running   0               3m27s
   kube-system   kube-scheduler-minikube            1/1     Running   27              3m38s
   kube-system   storage-provisioner                1/1     Running   1 (2m56s ago)   3m37s
   ```
   If the minikube starts properly, you can see some pods are `Running` in the kube-system namespace.

## Step 3. Start Cassandra container

We use Apache Cassandra as the backend storage of Scalar DB Server. We start a Cassandra container on the same network of Kubernetes (Scalar DB Server Pod on minikube) to make them communicate properly.

1. Start a Cassandra container on the Docker Network `minikube`.
   ```console
   $ docker run --name cassandra-scalardb --network minikube -d cassandra:3.11
   ```
   * Note: 
       * The Docker Network `minikube` was created by `minikube start --driver=docker` command that we ran in Step 2.
       * You can see the Scalar DB-supported Cassandra versions (tag) in [this document](https://github.com/scalar-labs/scalardb/blob/master/docs/scalardb-supported-databases.md).
       * If you want to create a schema for Scalar DB by running Schema Loader from localhost, you need to expose the container's 9042 port as follows.
         ```console
         $ docker run --name cassandra-scalardb --network minikube -p 127.0.0.1:9042:9042 -d cassandra:3.11
         ```

1. Check if the Cassandra container is running.
   ```console
   $ docker ps -f name=cassandra-scalardb
   CONTAINER ID   IMAGE            COMMAND                  CREATED         STATUS         PORTS                                         NAMES
   6dceab0007c8   cassandra:3.11   "docker-entrypoint.s…"   2 minutes ago   Up 2 minutes   7000-7001/tcp, 7199/tcp, 9042/tcp, 9160/tcp   cassandra-scalardb
   ```

1. Check the status of Cassandra.
   ```console
   $ docker exec -t cassandra-scalardb cqlsh -e "show version"
   [cqlsh 5.0.1 | Cassandra 3.11.11 | CQL spec 3.4.4 | Native protocol v4]
   ```
   It may take a while to start Cassandra in the container. So, if this command returns an error, wait a moment and then re-run it.

## Step 4. Deploy Scalar DB Server on the Kubernetes (minikube) using Helm Charts

1. Add the Scalar Helm Repository.
   ```console
   $ helm repo add scalar-labs https://scalar-labs.github.io/helm-charts
   ```

1. Create a custom value file for Scalar DB Server (scalardb-custom-values.yaml).
   ```console
   $ cat << EOF > scalardb-custom-values.yaml
   envoy:
     service:
       type: "NodePort"
   
   scalardb:
     storageConfiguration:
       contactPoints: "cassandra-scalardb"
       username: "cassandra"
       password: "cassandra"
       storage: "cassandra"
   EOF
   ```
   * Note:
       * If you want to access Scalar DB Server from 127.0.0.1 (your localhost), set `LoadBalancer` to `envoy.service.type` like the following.
         ```yaml
         envoy:
           service:
             type: "LoadBalancer"
         
         scalardb:
           storageConfiguration:
             contactPoints: "cassandra-scalardb"
             username: "cassandra"
             password: "cassandra"
             storage: "cassandra"
         ```

1. Deploy Scalar DB Server.
   ```console
   $ helm install scalardb scalar-labs/scalardb -f ./scalardb-custom-values.yaml
   ```

1. Check if the Scalar DB Server Pods are deployed.
   ```console
   $ kubectl get pod
   NAME                              READY   STATUS    RESTARTS   AGE
   scalardb-7674f74d6b-blxnj         1/1     Running   0          19m
   scalardb-7674f74d6b-kx5q7         1/1     Running   0          19m
   scalardb-7674f74d6b-mzwcr         1/1     Running   0          19m
   scalardb-envoy-5fb8f64786-5q6hn   1/1     Running   0          19m
   scalardb-envoy-5fb8f64786-8d7k5   1/1     Running   0          19m
   scalardb-envoy-5fb8f64786-t2xcv   1/1     Running   0          19m
   ```
   If the Scalar DB Server Pods are deployed properly, you can see the STATUS are `Running`.  

1. Check if the Scalar DB Server Services are deployed.
   ```console
   $ kubectl get svc
   NAME                     TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)                           AGE
   kubernetes               ClusterIP   10.96.0.1        <none>        443/TCP                           163m
   scalardb-envoy           NodePort    10.103.103.188   <none>        60051:32344/TCP,50052:30921/TCP   19m
   scalardb-envoy-metrics   ClusterIP   10.99.184.116    <none>        9001/TCP                          19m
   scalardb-headless        ClusterIP   None             <none>        50051/TCP                         19m
   scalardb-metrics         ClusterIP   10.101.127.88    <none>        8080/TCP                          19m
   ```
   If the Scalar DB Server Services are deployed properly, you can see a private IP address in the CLUSTER-IP column. (Note: `scalardb-headless` has no CLUSTER-IP.)  

1. (Optional) If you set `LoadBalancer` to `envoy.service.type` in the `scalardb-custom-values.yaml`, you can access Scalar DB Server from 127.0.0.1.  
   To expose the `scalardb-envoy` service as your local `127.0.0.1:60051`, open another terminal, and run the `minikube tunnel` command.
   ```console
   $ minikube tunnel
   ```
   After running the `minikube tunnel` command, you can see the  EXTERNAL-IP of the `scalardb-envoy` as  `127.0.0.1`.
   ```console
   $ kubectl get svc scalardb-envoy
   NAME             TYPE           CLUSTER-IP       EXTERNAL-IP   PORT(S)                           AGE
   scalardb-envoy   LoadBalancer   10.103.103.188   127.0.0.1     60051:32344/TCP,50052:30921/TCP   13m
   ```

## Step 5. Start Client container


1. Start a Client container on the `minikube` network.
   ```console
   $ docker run -d --name scalardb-client --hostname scalardb-client --network minikube --entrypoint sleep ubuntu:20.04 inf
   ```

1. Check the status of the Client container.
   ```console
   $ docker ps -f name=scalardb-client
   CONTAINER ID   IMAGE          COMMAND       CREATED              STATUS              PORTS     NAMES
   a49eaf0c2442   ubuntu:20.04   "sleep inf"   About a minute ago   Up About a minute             scalardb-client
   ```

## Step 6. Run Scalar DB sample application in the Client container


The following explains the minimum steps. If you want to know more details about Scalar DB, please refer to the [Getting Started with Scalar DB
](https://github.com/scalar-labs/scalardb/blob/master/docs/getting-started-with-scalardb.md).

1. Run bash in the Client container.
   ```console
   $ docker exec -it scalardb-client bash
   ```
   After this step, run each command in the Client container.  

1. Install Git, OpenJDK 8, and curl in the Client container.
   ```console
   # apt update && DEBIAN_FRONTEND="noninteractive" TZ="Etc/UTC" apt install -y git openjdk-8-jdk curl
   ```

1. Clone Scalar DB git repository.
   ```console
   # git clone https://github.com/scalar-labs/scalardb.git
   ```

1. Change dir to `scalardb/`.
   ```console
   # cd scalardb/ 
   # pwd
   /scalardb
   ```

1. Change branch to arbitrary version.
   ```
   # git checkout -b v3.5.1 refs/tags/v3.5.1
   # git branch
     master
   * v3.5.1
   ```
   If you want to use another version, please specify the version (tag) you want to use.

1. Build Scalar DB as a library.
   ```console
   # ./gradlew installDist
   ```

1. Change dir to `docs/getting-started/`.
   ```console
   # cd docs/getting-started/
   # pwd
   /scalardb/docs/getting-started
   ```

1. Download Schema Loader from [Scalar DB Releases](https://github.com/scalar-labs/scalardb/releases).
   ```console
   # curl -OL https://github.com/scalar-labs/scalardb/releases/download/v3.5.1/scalardb-schema-loader-3.5.1.jar
   ```
   You need to use the same version of Scalar DB and Schema Loader.

1. Create a configuration file (scalardb-schema-loader.properties) for Schema Loader.
   ```console
   # cat << EOF > scalardb-schema-loader.properties
   scalar.db.contact_points=cassandra-scalardb
   scalar.db.contact_port=9042
   scalar.db.username=cassandra
   scalar.db.password=cassandra
   scalar.db.storage=cassandra
   EOF
   ```

1. Create a JSON file (emoney-transaction.json) that defines DB Schema for the sample application.
   ```console
   # cat << EOF > emoney-transaction.json
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
   # java -jar ./scalardb-schema-loader-3.5.1.jar --config ./scalardb-schema-loader.properties -f emoney-transaction.json --coordinator
   ```

1. Create a configuration file (scalardb.properties) to access Scalar DB Server on minikube.
   ```console
   # cat << EOF > scalardb.properties
   scalar.db.contact_points=minikube
   scalar.db.contact_port=32344
   scalar.db.storage=grpc
   scalar.db.transaction_manager=grpc
   EOF
   ```
   * Note:
       * You need to specify the port number (NodePort) of `scalardb-envoy` (Kubernetes Service Resource) as a value of `scalar.db.contact_port` in the `scalardb.properties`. You can confirm the port number of `scalardb-envoy` with the `kubectl get svc scalardb-envoy` command.
         ```console
         $ kubectl get svc scalardb-envoy
         NAME             TYPE       CLUSTER-IP       EXTERNAL-IP   PORT(S)                           AGE
         scalardb-envoy   NodePort   10.103.103.188   <none>        60051:32344/TCP,50052:30921/TCP   79m
         ```
         In this case, you need to specify `32344` to `scalar.db.contact_port` in the `scalardb.properties` file.

1. Run the sample application.
   ```console
   # ../../gradlew run --args="-mode transaction -action charge -amount 1000 -to user1"
   # ../../gradlew run --args="-mode transaction -action charge -amount 0 -to merchant1"
   # ../../gradlew run --args="-mode transaction -action pay -amount 100 -to merchant1 -from user1"
   ```

1. (Optional) You can see the inserted and modified (INSERT/UPDATE) data through the sample application using the following command. (This command needs to run on your localhost, not on the Client container.)  
   ```console
   $ docker exec -t cassandra-scalardb cqlsh -e "SELECT * FROM emoney.account"
   
    id        | balance | before_balance | before_tx_committed_at | before_tx_id                         | before_tx_prepared_at | before_tx_state | before_tx_version | tx_committed_at | tx_id                                | tx_prepared_at | tx_state | tx_version
   -----------+---------+----------------+------------------------+--------------------------------------+-----------------------+-----------------+-------------------+-----------------+--------------------------------------+----------------+----------+------------
        user1 |     900 |           1000 |          1649830558289 | 78bdbb22-1ab4-4263-80c4-eacd9c6fbcfb |         1649830558262 |               3 |                 1 |   1649830585148 | d156b2dc-f791-4fd4-b3de-a6272eb2a680 |  1649830585119 |        3 |          2
    merchant1 |     100 |              0 |          1649830578857 | e4028217-ab4f-4755-ab31-fcc2ed93905f |         1649830578840 |               3 |                 1 |   1649830585148 | d156b2dc-f791-4fd4-b3de-a6272eb2a680 |  1649830585119 |        3 |          2
   
   (2 rows)
   ```
   * Note:
       * Usually, you need to access data (record) through Scalar DB. The above command is used to explain and confirm the working of the sample application.

## Step 7. Delete all resources

After completing the Scalar DB Server tests on minikube, remove all resources.

1. Uninstall Scalar DB Server from minikube.
   ```console
   $ helm uninstall scalardb
   ```

1. Stop and remove containers (Cassandra and Client).
   ```
   $ docker rm $(docker kill scalardb-client cassandra-scalardb)
   ```

1. Delete minikube.
   ```console
   $ minikube delete --all
   ```
