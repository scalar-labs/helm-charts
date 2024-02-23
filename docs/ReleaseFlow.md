> [!CAUTION]
> 
> The contents of the `docs` folder have been moved to the [docs-internal-orchestration](https://github.com/scalar-labs/docs-internal-orchestration) repository. Please update this documentation in that repository instead.
> 
> To view the Helm Charts documentation, visit the documentation site for the product you are using:
> 
> - [ScalarDB Enterprise Documentation](https://scalardb.scalar-labs.com/docs/latest/helm-charts/getting-started-scalar-helm-charts/).
> - [ScalarDL Documentation](https://scalardl.scalar-labs.com/docs/latest/helm-charts/getting-started-scalar-helm-charts/).

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
