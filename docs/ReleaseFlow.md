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
