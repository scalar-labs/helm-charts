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
helm install <RELEASE_NAME> scalar-labs/scalardb-graphql -n <NAMESPACE> -f /<PATH_TO_YOUR_CUSTOM_VALUES_FILE_FOR_SCALARDB_GRAPHQL> --version <CHART_VERSION>
```

## Upgrade the deployment of ScalarDB GraphQL

```console
helm upgrade <RELEASE_NAME> scalar-labs/scalardb-graphql -n <NAMESPACE> -f /<PATH_TO_YOUR_CUSTOM_VALUES_FILE_FOR_SCALARDB_GRAPHQL> --version <CHART_VERSION>
```

## Delete the deployment of ScalarDB GraphQL

```console
helm uninstall <RELEASE_NAME> -n <NAMESPACE>
```
