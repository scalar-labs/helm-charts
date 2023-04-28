# How to use a customized properties file with Scalar Helm Charts

You can set your customized properties files with Scalar Helm Charts (ScalarDB, ScalarDL Ledger, ScalarDL Auditor, and ScalarDL Schema Loader). Also, you can specify some flags in addition to the customized properties file with the ScalarDL Schema Loader chart. This document explains how to set properties files and flags with Scalar Helm Charts.

## Set your properties file to a custom values file

1. Set your properties to the following keys in the custom values file.
   * Keys
     * `scalardb.databaseProperties` (ScalarDB)
     * `ledger.ledgerProperties` (ScalarDL Ledger)
     * `auditor.auditorProperties` (ScalarDL Auditor)
     * `schemaLoading.databaseProperties` (ScalarDL Schema Loader)

   * Example
       * ScalarDB
         ```yaml
         scalardb:
           databaseProperties: |
             scalar.db.contact_points=jdbc:postgresql://postgresql-scalardb.default.svc.cluster.local:5432/postgres
             scalar.db.username=postgres
             scalar.db.password=postgres
             scalar.db.storage=jdbc
         ```
       * ScalarDL Ledger
         ```yaml
         ledger:
           ledgerProperties: |
             scalar.db.contact_points=jdbc:postgresql://postgresql-ledger.default.svc.cluster.local:5432/postgres
             scalar.db.username=postgres
             scalar.db.password=postgres
             scalar.db.storage=jdbc
             scalar.dl.ledger.proof.enabled=true
             scalar.dl.ledger.auditor.enabled=true
             scalar.dl.ledger.proof.private_key_path=/keys/private-key
         ```
       * ScalarDL Auditor
         ```yaml
         auditor:
           auditorProperties: |
             scalar.db.contact_points=jdbc:postgresql://postgresql-auditor.default.svc.cluster.local:5432/postgres
             scalar.db.username=postgres
             scalar.db.password=postgres
             scalar.db.storage=jdbc
             scalar.dl.auditor.ledger.host=scalardl-ledger-envoy
             scalar.dl.auditor.cert_path=/keys/certificate
             scalar.dl.auditor.private_key_path=/keys/private-key
         ```
       * ScalarDL Schema Loader
         ```yaml
         schemaLoading:
           databaseProperties: |
             scalar.db.contact_points=jdbc:postgresql://postgresql-ledger.default.svc.cluster.local:5432/postgres
             scalar.db.username=postgres
             scalar.db.password=postgres
             scalar.db.storage=jdbc
         ```

1. Deploy Scalar products with the above custom values file.  
   Please refer to the [Getting Started with Scalar Helm Charts](./getting-started-scalar-helm-charts.md) for more details on how to use each Helm Chart.

## Use `Secret` resources to pass the credentials as the environment variables into the properties file

You can pass the credentials like **username** or **password** as the environment variables via `Secret` resource. The docker images of Scalar products use the `dockerize` command for templating properties files.  

Note: You cannot use the following environment variable names in your customized properties since these are used in the Scalar Helm Chart internal.
```console
HELM_SCALAR_DB_CONTACT_POINTS
HELM_SCALAR_DB_CONTACT_PORT
HELM_SCALAR_DB_USERNAME
HELM_SCALAR_DB_PASSWORD
HELM_SCALAR_DB_STORAGE
HELM_SCALAR_DL_LEDGER_PROOF_ENABLED
HELM_SCALAR_DL_LEDGER_AUDITOR_ENABLED
HELM_SCALAR_DL_LEDGER_PROOF_PRIVATE_KEY_PATH
HELM_SCALAR_DL_AUDITOR_SERVER_PORT
HELM_SCALAR_DL_AUDITOR_SERVER_PRIVILEGED_PORT
HELM_SCALAR_DL_AUDITOR_SERVER_ADMIN_PORT
HELM_SCALAR_DL_AUDITOR_LEDGER_HOST
HELM_SCALAR_DL_AUDITOR_CERT_HOLDER_ID
HELM_SCALAR_DL_AUDITOR_CERT_VERSION
HELM_SCALAR_DL_AUDITOR_CERT_PATH
HELM_SCALAR_DL_AUDITOR_PRIVATE_KEY_PATH
SCALAR_DB_LOG_LEVEL
SCALAR_DL_LEDGER_LOG_LEVEL
SCALAR_DL_AUDITOR_LOG_LEVEL
```

1. Set environment variable name to the properties configuration in the custom values file using Go template syntax.
   * Example
       * ScalarDB
         ```yaml
         scalardb:
            databaseProperties: |
              ...
              scalar.db.username={{ default .Env.SCALAR_DB_USERNAME "" }}
              scalar.db.password={{ default .Env.SCALAR_DB_PASSWORD "" }}
              ...
         ```
        * ScalarDL Ledger
          ```yaml
          ledger:
            ledgerProperties: |
              ...
              scalar.db.username={{ default .Env.SCALAR_DB_USERNAME "" }}
              scalar.db.password={{ default .Env.SCALAR_DB_PASSWORD "" }}
              ...
          ```
       * ScalarDL Auditor
         ```yaml
         auditor:
           auditorProperties: |
             ...
             scalar.db.username={{ default .Env.SCALAR_DB_USERNAME "" }}
             scalar.db.password={{ default .Env.SCALAR_DB_PASSWORD "" }}
             ...
         ```
       * ScalarDL Schema Loader
         ```yaml
         schemaLoading:
           databaseProperties: |
             ...
             scalar.db.username={{ default .Env.SCALAR_DB_USERNAME "" }}
             scalar.db.password={{ default .Env.SCALAR_DB_PASSWORD "" }}
             ...
         ```

1. Create a `Secret` resource that includes credentials.  
   You need to specify the environment variable name as keys of the `Secret`.
   * Example
     ```console
     kubectl create secret generic scalardb-credentials-secret \
       --from-literal=SCALAR_DB_USERNAME=postgres \
       --from-literal=SCALAR_DB_PASSWORD=postgres
     ```

1. Set the `Secret` name to the following keys in the custom values file.  
   * Keys
     * `scalardb.secretName` (ScalarDB)
     * `ledger.secretName` (ScalarDL Ledger)
     * `auditor.secretName` (ScalarDL Auditor)
     * `schemaLoading.secretName` (ScalarDL Schema Loader)
   * Example
     * ScalarDB
       ```yaml
       scalardb:
         secretName: "scalardb-credentials-secret"
       ```
     * ScalarDL Ledger
       ```yaml
       ledger:
         secretName: "ledger-credentials-secret"
       ```
     * ScalarDL Auditor
       ```yaml
       auditor:
         secretName: "auditor-credentials-secret"
       ```
     * ScalarDL Schema Loader
       ```yaml
       schemaLoading:
         secretName: "schema-loader-ledger-credentials-secret"
       ```

1. Deploy Scalar products with the above custom values file.  
   After deploying Scalar products, the Go template strings (environment variables) are replaced by the values of the `Secret`.
   * Example
       * Custom values file
         ```yaml
         scalardb:
           databaseProperties: |
             scalar.db.contact_points=jdbc:postgresql://postgresql-scalardb.default.svc.cluster.local:5432/postgres
             scalar.db.username={{ default .Env.SCALAR_DB_USERNAME "" }}
             scalar.db.password={{ default .Env.SCALAR_DB_PASSWORD "" }}
             scalar.db.storage=jdbc
         ```
       * Properties file in containers
         ```properties
         scalar.db.contact_points=jdbc:postgresql://postgresql-scalardb.default.svc.cluster.local:5432/postgres
         scalar.db.username=postgres
         scalar.db.password=postgres
         scalar.db.storage=jdbc
         ```

   Please refer to the [Getting Started with Scalar Helm Charts](./getting-started-scalar-helm-charts.md) for more details on how to use each Helm Chart.

## Mount arbitrary files like key and certificate files to the container in ScalarDL Helm Charts

You can mount any files to the container when you use the ScalarDL Helm Charts (ScalarDL Ledger and ScalarDL Auditor). For example, you need to mount the key and certificate files to run the ScalarDL Auditor.

* Configuration example
    * ScalarDL Ledger
      ```yaml
      ledger:
        ledgerProperties: |
          ...
          scalar.dl.ledger.proof.enabled=true
          scalar.dl.ledger.auditor.enabled=true
          scalar.dl.ledger.proof.private_key_path=/keys/private-key
      ```
    * ScalarDL Auditor
      ```yaml
      auditor:
        auditorProperties: |
          ...
          scalar.dl.auditor.cert_path=/keys/certificate
          scalar.dl.auditor.private_key_path=/keys/private-key
      ```

In this example, you need to mount a **private-key** and a **certificate** file under the `/keys` directory in the container. And, you need to mount files named `private-key` and `certificate`. You can use `extraVolumes` and `extraVolumeMounts` to mount these files.

1. Set `extraVolumes` and `extraVolumeMounts` in the custom values file using the same syntax of Kubernetes manifest. You need to specify the directory name to the key `mountPath`.
   * Example
        * ScalarDL Ledger
          ```yaml
          ledger:
            extraVolumes:
              - name: ledger-keys
                secret:
                  secretName: ledger-keys
            extraVolumeMounts:
              - name: ledger-keys
                mountPath: /keys
                readOnly: true
          ```
       * ScalarDL Auditor
         ```yaml
         auditor:
            extraVolumes:
              - name: auditor-keys
                secret:
                  secretName: auditor-keys
            extraVolumeMounts:
              - name: auditor-keys
                mountPath: /keys
                readOnly: true
          ```

1. Create a `Secret` resource that includes key and certificate files.  
   You need to specify the file name as keys of `Secret`.
   * Example
       * ScalarDL Ledger
         ```console
         kubectl create secret generic ledger-key-secret \
           --from-file=private-key=./ledger-key.pem
         ```
       * ScalarDL Auditor
         ```console
         kubectl create secret generic auditor-key-secret \
           --from-file=private-key=./auditor-key.pem \
           --from-file=certificate=./auditor-cert.pem
         ```

1. Deploy Scalar products with the above custom values file.  
   After deploying Scalar products, key and certificate files are mounted under the `/keys` directory as follows.
   * Example
       * ScalarDL Ledger
         ```console
         $ ls -l /keys/
         total 0
         lrwxrwxrwx 1 root root 18 Jun 27 03:12 private-key -> ..data/private-key
         ```
       * ScalarDL Auditor
         ```console
         $ ls -l /keys/
         total 0
         lrwxrwxrwx 1 root root 18 Jun 27 03:16 certificate -> ..data/certificate
         lrwxrwxrwx 1 root root 18 Jun 27 03:16 private-key -> ..data/private-key
         ```

   Please refer to the [Getting Started with Scalar Helm Charts](./getting-started-scalar-helm-charts.md) for more details on how to use each Helm Chart.

## Set flags with the ScalarDL Schema Loader chart

You can specify several flags as an array with the ScalarDL Schema Loader chart.

1. Set flags to the following key in the custom values file of the ScalarDL Schema Loader chart.
   * Example
     ```yaml
     schemaLoading:
       commandArgs:
       - "--alter"
       - "--compaction-strategy"
       - "<compactionStrategy>"
       - "--delete-all"
       - "--no-backup"
       - "--no-scaling"
       - "--repair-all"
       - "--replication-factor"
       - "<replicaFactor>"
       - "--replication-strategy"
       - "<replicationStrategy>"
       - "--ru"
       - "<ru>"
     ```
