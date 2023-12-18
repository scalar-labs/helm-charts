# How to deploy ScalarDB Analytics with PostgreSQL

This document explains how to deploy ScalarDB Analytics with PostgreSQL by using Scalar Helm Charts. For details on the custom values file for ScalarDB Analytics with PostgreSQL, see [Configure a custom values file for ScalarDB Analytics with PostgreSQL](./configure-custom-values-scalardb-analytics-postgresql.md).

## Prepare a secret resource

You must create a secret resource `scalardb-analytics-postgresql-superuser-password` with the key `superuser-password` that includes a superuser password for PostgreSQL before you deploy ScalarDB Analytics with PostgreSQL. Scalar Helm Chart mounts this secret resource and sets the `POSTGRES_PASSWORD` environment variable to the value of the `superuser-password` key.

```console
kubectl create secret generic scalardb-analytics-postgresql-superuser-password --from-literal=superuser-password=<POSTGRESQL_PASSWORD> -n <NAMESPACE>
```

## Deploy ScalarDB Analytics with PostgreSQL

To deploy ScalarDB Analytics with PostgreSQL, run the following command, replacing the contents in the angle brackets as described:

```console
helm install <RELEASE_NAME> scalar-labs/scalardb-analytics-postgresql -n <NAMESPACE> -f /<PATH_TO_YOUR_CUSTOM_VALUES_FILE_FOR_SCALARDB_ANALYTICS_WITH_POSTGRESQL> --version <CHART_VERSION>
```

## Upgrade a ScalarDB Analytics with PostgreSQL deployment

To upgrade a ScalarDB Analytics with PostgreSQL deployment, run the following command, replacing the contents in the angle brackets as described:

```console
helm upgrade <RELEASE_NAME> scalar-labs/scalardb-analytics-postgresql -n <NAMESPACE> -f /<PATH_TO_YOUR_CUSTOM_VALUES_FILE_FOR_SCALARDB_ANALYTICS_WITH_POSTGRESQL> --version <CHART_VERSION>
```

## Delete a ScalarDB Analytics with PostgreSQL deployment

To delete a ScalarDB Analytics with PostgreSQL deployment, run the following command, replacing the contents in the angle brackets as described:  

```console
helm uninstall <RELEASE_NAME> -n <NAMESPACE>
```
