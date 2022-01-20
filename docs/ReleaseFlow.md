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
