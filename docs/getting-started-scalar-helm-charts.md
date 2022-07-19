# Getting Started with Scalar Helm Charts

This document explains how to get started with Scalar Helm Chart in your test environment using `Minikube`. Here, we assume that you already have a Mac or Linux environment for testing.  

## Tools

We will use the following tools for testing.  

1. Docker
1. minikube
1. kubectl
1. Helm
1. cfssl / cfssljson

## Step 1. Install tools

First, you need to install the following tools used in this guide.

1. Install the Docker according to the [Docker document](https://docs.docker.com/engine/install/)  

1. Install the minikube according to the [minikube document](https://minikube.sigs.k8s.io/docs/start/)  

1. Install the kubectl according to the [Kubernetes document](https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/)  

1. Install the helm command according to the [Helm document](https://helm.sh/docs/intro/install/)  

1. Install the cfssl and cfssljson according to the [CFSSL document](https://github.com/cloudflare/cfssl)
   * Note:
        * You need the cfssl and cfssljson when you try Scalar DL. If you try Scalar Helm Charts other than Scalar DL (e.g., Scalar DB, Monitoring, Logging, etc...), the cfssl and cfssljson are not necessary.

## Step 2. Start minikube with docker driver

1. Start minikube with docker driver.
   ```console
   minikube start --driver=docker
   ```

1. Check the status of the minikube and pods.
   ```console
   kubectl get pod -A
   ```
   [Command execution result]
   ```console
   NAMESPACE     NAME                               READY   STATUS    RESTARTS      AGE
   kube-system   coredns-64897985d-lbsfr            1/1     Running   1 (20h ago)   21h
   kube-system   etcd-minikube                      1/1     Running   1 (20h ago)   21h
   kube-system   kube-apiserver-minikube            1/1     Running   1 (20h ago)   21h
   kube-system   kube-controller-manager-minikube   1/1     Running   1 (20h ago)   21h
   kube-system   kube-proxy-gsl6j                   1/1     Running   1 (20h ago)   21h
   kube-system   kube-scheduler-minikube            1/1     Running   1 (20h ago)   21h
   kube-system   storage-provisioner                1/1     Running   2 (19s ago)   21h
   ```
   If the minikube starts properly, you can see some pods are `Running` in the kube-system namespace.

## Step 3. 

After the minikube starts, you can try each Scalar Helm Charts on it. Please refer to the following documents for more details.

* [Scalar DB Server](./getting-started-scalardb.md)
* [Scalar DL Ledger](./getting-started-scalardl-ledger.md)
* [Scalar DL Auditor](./getting-started-scalardl-auditor.md)
* [Monitoring using Prometheus Operator](./getting-started-monitoring.md)
  * [Logging using Loki Stack](./getting-started-logging.md)
  * [Scalar Manager](./getting-started-scalar-manager.md)
