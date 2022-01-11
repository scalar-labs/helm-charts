# Scalar Helm Charts Repository

[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)
[![Release Charts](https://github.com/scalar-labs/helm-charts/actions/workflows/release.yml/badge.svg)](https://github.com/scalar-labs/helm-charts/actions/workflows/release.yml)
[![Chart Testing and Kubeval](https://github.com/scalar-labs/helm-charts/actions/workflows/helm_charts_scalar.yml/badge.svg)](https://github.com/scalar-labs/helm-charts/actions/workflows/helm_charts_scalar.yml)

This directory contains the following helm charts.
* [Scalar DB](./charts/scalardb/)
* [Scalar DL](./charts/scalardl/)
* [Scalar DL Audit](./charts/scalardl-audit/)
* [Schema Loading for Scalar DL](./charts/schema-loading/)
* [Envoy](./charts/envoy/)

## Prerequisites

* Kubernetes 1.19+
* Helm 3.5+

## Usage

### Helm

[Helm](https://helm.sh) must be installed to use the charts.
Please refer to Helm's [documentation](https://helm.sh/docs/) to get started.

Once Helm is set up properly, add the repo as follows:

```console
helm repo add scalar-labs https://scalar-labs.github.io/helm-charts
```

You can then run `helm search repo scalar-labs` to see the Scalar charts.

### Pre-commit hook

If you want to automatically generate `README.md` files and `values.schema.json` with a pre-commit hook,
then run:

``` bash
cd $(git rev-parse --show-toplevel)
ln -s ../../.git-hooks/pre-commit .git/hooks/pre-commit
```

## Contributing

This repo is mainly maintained by the Scalar Engineering Team, but of course we appreciate any help.

* For asking questions, finding answers and helping other users, please go to [stackoverflow](https://stackoverflow.com/) and use [scalardl](https://stackoverflow.com/questions/tagged/scalardl) tag.
* For filing bugs, suggesting improvements, or requesting new features, help us out by opening an issue.

## License

[Apache 2.0 License](https://github.com/scalar-labs/helm-charts/blob/main/LICENSE).
