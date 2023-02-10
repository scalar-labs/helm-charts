# How to deploy ScalarDB GraphQL

This document explains how to deploy ScalarDB GraphQL using Scalar Helm Charts. You must prepare your custom values file. Please refer to the following document for more details on the custom values file for ScalarDB GraphQL.

* [Configure a custom values file for ScalarDB GraphQL](./configure-custom-values-scalardb-graphql.md)

## Deploy ScalarDB Server (recommended option)

When you deploy ScalarDB GraphQL, it is recommended to deploy ScalarDB Server between ScalarDB GraphQL and backend databases as follows.

```
[Client] ---> [ScalarDB GraphQL] ---> [ScalarDB Server] ---> [Backend databases]
```

Please deploy ScalarDB Server before you deploy ScalarDB GraphQL according to the document [How to deploy ScalarDB Server](./how-to-deploy-scalardb.md).

## Deploy ScalarDB GraphQL

```console
helm install <release name> scalar-labs/scalardb-graphql -n <namespace> -f /path/to/<your custom values file for ScalarDB GraphQL>
```

## Upgrade the deployment of ScalarDB GraphQL

```console
helm upgrade <release name> scalar-labs/scalardb-graphql -n <namespace> -f /path/to/<your custom values file for ScalarDB GraphQL>
```

## Delete the deployment of ScalarDB GraphQL

```console
helm uninstall <release name> -n <namespace>
```
