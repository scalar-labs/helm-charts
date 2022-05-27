# Release Flow

## Requirements
| Name | Version | Mandatory | link |
|:------|:-------|:----------|:------|
| Helm | 3.2.1 or latest | no | https://helm.sh/docs/intro/install/ |

## Release
* You create a branch (`prepare-release-*`).
* You make sure to create the tag from the previous version of the target version.
``` console
$ git checkout -b prepare-release-v3.0.2  refs/tags/scalardl-3.0.1
```

* You need to set the `version` of the `Chart.yaml` of each `helm-charts` to the version to be released.
``` yaml
version: 3.0.2
```
* Pushing commits to a remote repository.
``` console
$ git push origin prepare-release-v3.0.2
```

* In this case, the `Github Actions` for the release will be executed upon `Git push`.

* If you release the most recent version of charts, you need to update the version of the main branch as well.
    * Example
      ```console
      $ helm search repo scalar-labs/scalardb -l
      NAME                    CHART VERSION   APP VERSION     DESCRIPTION
      scalar-labs/scalardb    2.2.4           3.5.2           Scalar DB server
      scalar-labs/scalardb    2.2.3           3.5.1           Scalar DB server
      
      ...
      
      scalar-labs/scalardb    2.1.5           3.4.4           Scalar DB server
      scalar-labs/scalardb    2.1.4           3.4.3           Scalar DB server
      ```
      * If you release a new chart v2.1.6 (Scalar DB v3.4.x), you don't need to update the version of the main branch.
      * If you release a new chart v2.2.5 (Scalar DB v3.5.x), you need to update the version of the main branch.
      * Also, if you release a new minor (v2.3.0) or major (v3.0.0) chart (Scalar DB v3.x or v4.x), you need to update the version of the main branch.
    * What you need to update
      * If you update a docker image tag (version) of each Scalar product.
        1. Update the value of `version` and `appVersion` in the **Chart.yaml**.
           ```yaml
           version: 2.2.5
           appVersion: 3.5.3
           ```
        1. Update the value of the docker tag in the **values.yaml**.
           * Scalar DB
             ```yaml
             scalardb:
             ...
                image:
                 ...
                 # -- Docker tag of the image.
                 tag: 3.5.3
             ```
           * Scalar DL Ledger
             ```yaml
             ledger:
             ...
               image:
                 ...
                 # -- Docker tag
                 version: 3.4.1
             ```
           * Scalar DL Auditor
             ```yaml
             auditor:
             ...
               image:
                 ...
                 # -- Docker tag
                 version: 3.4.1
             ```
           * Scalar DL Schema Loader
             ```yaml
             schemaLoading:
             ...
               image:
                 ...
                 # -- Docker tag
                 version: 3.4.1
             ```
           * Envoy
             ```yaml
             image:
             ...
               # image.tag -- Docker tag
               version: 1.3.1
             ```
        1. Update **README** using [update-chart-docs.sh](https://github.com/scalar-labs/helm-charts/blob/main/scripts/update-chart-docs.sh).
           ```console
           cd <Git root directory>
           ./scripts/update-chart-docs.sh
           ```
           This script updates the value of README based on the Chart.yaml and values.yaml as follows.
           ```diff
           -Current chart version is `2.2.4`
           +Current chart version is `2.2.5`
           
           ...
           
           -| scalardb.image.tag | string | `"3.5.2"` | Docker tag of the image. |
           +| scalardb.image.tag | string | `"3.5.3"` | Docker tag of the image. |
           ```
      * If you update the version of the Scalar Envoy Charts as dependencies in the charts of Scalar DB, Scalar DL Ledger, and Scalar DL Auditor.
        1. Update the value of `dependencies[].version` of Envoy in the **Chart.yaml**.
           ```yaml
           dependencies:
           - name: envoy
             version: ~2.1.0
           ```
        1. Update the value of docker tag of the Envoy in the **values.yaml**.
           ```yaml
           envoy:
           ...
             image:
             ...
               # -- Docker tag
               version: 1.3.0
           ```
        1. Update **README** using [update-chart-docs.sh](https://github.com/scalar-labs/helm-charts/blob/main/scripts/update-chart-docs.sh).
           ```console
           cd <Git root directory>
           ./scripts/update-chart-docs.sh
           ```
           This script updates the value of README based on the Chart.yaml as follows.
           ```diff
           -| https://scalar-labs.github.io/helm-charts | envoy | ~2.0.1 |
           +| https://scalar-labs.github.io/helm-charts | envoy | ~2.1.0 |
           
           ...
           
           -| envoy.image.version | string | `"1.2.0"` | Docker tag |
           +| envoy.image.version | string | `"1.3.0"` | Docker tag |
           ```
        1. Update **Chart.lock** using the `helm dependency update` command.
           ```console
           cd <Git root directory>/charts/<chart name directory>  (e.g. helm-charts/charts/scalardb/)
           helm dependency update
           ```
           This command updates the Chart.lock file based on the Chart.yaml as follows.
           ```diff
           -  version: 2.0.1
           -digest: sha256:102a060fe4b6e667428ee5ef242bbf994da80841e17ebe178368f7e1904deb53
           -generated: "2022-04-07T18:36:10.973938802+09:00"
           +  version: 2.1.0
           +digest: sha256:21cca64d71b44b1da064db4c42be1a19dd230415494752b58698aaa8bd9a5d77
           +generated: "2022-05-27T11:28:17.717916937+09:00"
           ```
