# scalar-manager

![Version: 1.0.0](https://img.shields.io/badge/Version-1.0.0-informational?style=flat-square)  ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square)  ![AppVersion: 1.0.0](https://img.shields.io/badge/AppVersion-1.0.0-informational?style=flat-square)

Scalar Manager
Current chart version is `1.0.0`

**Homepage:** <https://scalar-labs.com/>

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| fullnameOverride | string | `""` | Override the fully qualified app name |
| image.pullPolicy | string | `"IfNotPresent"` | Specify a imagePullPolicy |
| image.repository | string | `"ghcr.io/scalar-labs/scalar-manager"` | Docker image |
| image.tag | string | `""` | Override the image tag whose default is the chart appVersion |
| imagePullSecrets | list | `[{"name":"reg-docker-secrets"}]` | Optionally specify an array of imagePullSecrets. Secrets must be manually created in the namespace |
| nameOverride | string | `""` | Override the Chart name |
| replicaCount | int | `1` | number of replicas to deploy |
| scalarManager.grafanaUrl | string | `""` |  |
| scalarManager.port | int | `5000` | The port that Scalar Manager container exposes |
| scalarManager.refreshInterval | int | `30` |  |
| scalarManager.targets | list | `[]` |  |
| service.port | int | `8000` | The port that service exposes |
| service.type | string | `"ClusterIP"` | The service type |
| serviceAccount.automountServiceAccountToken | bool | `true` | Specify to mount a service account token or not |
| serviceAccount.serviceAccountName | string | `""` | Name of the existing service account resource |
