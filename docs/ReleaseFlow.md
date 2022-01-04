# Release Flow

## Requirements
| Name | Version | Mandatory | link |
|:------|:-------|:----------|:------|
| Helm | 3.2.1 or latest | no | https://helm.sh/docs/intro/install/ |

## Preparation
You need to set the `version` of the `Chart.yaml` of each `helm-charts` to the version to be released.
``` yaml
version: 2.1.0
```

## Release
Run the release manually from the Github UI.
* [Release Action](https://github.com/scalar-labs/helm-charts/actions/workflows/release.yml)

## Points of Attention
### If the version of the `main` branch of the `charts` you are releasing is higher than the version you are releasing
* You create a branch (`prepare-release-*`).
* You make sure to create the tag from the previous version of the target version.
``` console
$ git checkout -b prepare-release-v3.0.1  refs/tags/scalardl-3.0.1
```

* You need to set the `version` of the `Chart.yaml` of each `helm-charts` to the version to be released.
``` yaml
version: 2.0.1
```

* In this case, the `Github Actions` for the release will be executed upon `Git push`.
