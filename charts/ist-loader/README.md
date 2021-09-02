# run IST using minikube

This readme is here to help helm chart beginner to run IST with minikube.

Prerequisite: 
 - [Minikube](https://minikube.sigs.k8s.io/docs/start/)
 - Virtualization tool (ex: [virtualbox](https://www.virtualbox.org/wiki/Downloads))
 - Database supported by scalardl (ex: [cassandra](https://kubernetes.io/docs/tutorials/stateful-application/cassandra/))


```
minikube start
```

## Install scalardl helm chart

Scalardl helm chart is pulling private docker images, to be able to access to them you need to give your git access token.

```
kubectl create secret docker-registry ledger-secrets --docker-server=ghcr.io --docker-username=git_username --docker-password=git_access_token
```

Replace `imagePullSecrets` with your secret name.

#### **`scalardl/values.yaml`**
```
imagePullSecrets: 
    - name: ledger-secrets
```

## Install IST helm chart

To add IST loader to minikube you will need to clone [this](https://github.com/scalar-labs/scalar-ist-internal) git repository

Before building the image run `eval $(minikube docker-env)`. This will allow to build your image in your minikube instance

```
docker build --tag scalar-ist-loader .
```

You need to run those both commands on the same terminal.
