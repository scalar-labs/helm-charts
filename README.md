# Scalar Helm Charts Repository

[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0) ![Release Charts](https://github.com/scalar-labs/helm-charts/workflows/Release%20Helm%20Charts/badge.svg?branch=main)

This directory contains the following helm charts.

* [Scalar DL](./charts/scalardl/)
* [Schema Loading for Scalar DL](./charts/schema-loading/)


## Usage

[Helm](https://helm.sh) must be installed to use the charts.
Please refer to Helm's [documentation](https://helm.sh/docs/) to get started.

Once Helm is set up properly, add the repo as follows:

```console
helm repo add scalar-labs https://scalar-labs.github.io/helm-charts
```

You can then run `helm search repo scalar-labs` to see the Scalar charts.

## Contributing

This repo is mainly maintained by the Scalar Engineering Team, but of course we appreciate any help.

* For asking questions, finding answers and helping other users, please go to [stackoverflow](https://stackoverflow.com/) and use [scalardl](https://stackoverflow.com/questions/tagged/scalardl) tag.
* For filing bugs, suggesting improvements, or requesting new features, help us out by opening an issue.

## License

[Apache 2.0 License](https://github.com/scalar-labs/helm-charts/blob/main/LICENSE).
