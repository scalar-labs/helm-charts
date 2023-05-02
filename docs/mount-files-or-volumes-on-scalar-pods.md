# Mount any files or volumes on Scalar product pods

You can mount any files or volumes on Scalar product pods when you use ScalarDB Server, ScalarDB Cluster, or ScalarDL Helm Charts (ScalarDL Ledger and ScalarDL Auditor).

## Mount key and certificate files on a pod in ScalarDL Helm Charts

You must mount the key and certificate files to run ScalarDL Auditor.

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
          scalar.dl.auditor.private_key_path=/keys/private-key
          scalar.dl.auditor.cert_path=/keys/certificate
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
         kubectl create secret generic ledger-keys \
           --from-file=private-key=./ledger-key.pem
         ```
       * ScalarDL Auditor
         ```console
         kubectl create secret generic auditor-keys \
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

## Mount emptyDir to get a heap dump file

You can mount emptyDir to Scalar product pods by using the following keys in your custom values file. For example, you can use this volume to get a heap dump of Scalar products.

* Keys
  * `scalardb.extraVolumes` / `scalardb.extraVolumeMounts` (ScalarDB Server)
  * `scalardbCluster.extraVolumes` / `scalardbCluster.extraVolumeMounts` (ScalarDB Cluster)
  * `ledger.extraVolumes` / `ledger.extraVolumeMounts` (ScalarDL Ledger)
  * `auditor.extraVolumes` / `auditor.extraVolumeMounts` (ScalarDL Auditor)

* Example (ScalarDB Server)
  ```yaml
  scalardb:
    extraVolumes:
      - name: heap-dump
        emptyDir: {}
    extraVolumeMounts:
      - name: heap-dump
        mountPath: /dump
  ```

In this example, you can see the mounted volume in the ScalarDB Server pod as follows.

```console
$ ls -ld /dump
drwxrwxrwx 2 root root 4096 Feb  6 07:43 /dump
```
