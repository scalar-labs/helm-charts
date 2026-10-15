# scalardb-saga-server

![Version: 0.0.1](https://img.shields.io/badge/Version-0.0.1-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 3.19.0-alpha.1](https://img.shields.io/badge/AppVersion-3.19.0--alpha.1-informational?style=flat-square)

A Helm chart for ScalarDB Saga Server

**Homepage:** <https://scalar-labs.com/>

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| Takanori Yokoyama | <takanori.yokoyama@scalar-labs.com> |  |
| Hiroyuki Yamada | <hiroyuki.yamada@scalar-labs.com> |  |

## Source Code

* <https://github.com/scalar-labs/scalardb-saga>

## Requirements

Kubernetes: `>= 1.31.0-0`

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| fullnameOverride | string | `""` | Replaces the whole generated resource name, ignoring the release name and the chart name. |
| nameOverride | string | `""` | Replaces the chart name in the generated resource names, keeping the release name. |
| scalarDbSagaServer.affinity | object | `{}` | Affinity for the output Deployment definition. |
| scalarDbSagaServer.configMapNames | object | `{"sagaDefinitions":"","sagaServices":""}` | Names of the two ConfigMaps that contain the Saga definitions and the Saga services configurations. The chart does not create these ConfigMaps. You must create them yourself in the release namespace before you install the chart. Each key of a ConfigMap becomes one file for the server, so create them from a directory, for example `kubectl create configmap saga-definitions --from-file=<dir>/`. `sagaDefinitions` holds the Saga definition files. `sagaServices` holds one `<service>.properties` file for each `service` named in those definitions. ScalarDB Saga Server hot-reloads both while it runs, so edit them in place. Do not set `immutable: true` on them, because that would block the update. |
| scalarDbSagaServer.deploymentAnnotations | object | `{}` | Annotations to add to the Deployment. |
| scalarDbSagaServer.deploymentLabels | object | `{}` | Labels to add to the Deployment. A key that the chart already sets, such as `app.kubernetes.io/name`, keeps the value of the chart and your value is dropped without an error. |
| scalarDbSagaServer.extraVolumeMounts | list | `[]` | Additional volumeMounts on the output Deployment definition. |
| scalarDbSagaServer.extraVolumes | list | `[]` | Additional volumes on the output Deployment definition. |
| scalarDbSagaServer.image | object | `{"pullPolicy":"IfNotPresent","repository":"ghcr.io/scalar-labs/scalardb-saga-server","tag":""}` | This sets the container image more information can be found here: https://kubernetes.io/docs/concepts/containers/images/ |
| scalarDbSagaServer.image.pullPolicy | string | `"IfNotPresent"` | This sets the pull policy for images. |
| scalarDbSagaServer.image.tag | string | `""` | Overrides the image tag whose default is the chart appVersion. |
| scalarDbSagaServer.imagePullSecrets | list | `[]` | Names of the secrets used to pull the container image. The default image is public, so you only need this if you mirror the image to a private registry. More information can be found here: https://kubernetes.io/docs/tasks/configure-pod-container/pull-image-private-registry/ |
| scalarDbSagaServer.javaOpts | string | `""` | Java options for the ScalarDB Saga server. Passed to the container as the `JAVA_OPTS` environment variable. |
| scalarDbSagaServer.logLevel | string | `"INFO"` | Log level for the ScalarDB Saga server. Passed to the container as the `SCALAR_DB_SAGA_LOG_LEVEL` environment variable. |
| scalarDbSagaServer.nodeSelector | object | `{}` | Node selector for the output Deployment definition. |
| scalarDbSagaServer.podAnnotations | object | `{}` | Annotations to add to the pods. The key `scalar-labs.com/config-checksum` is managed by the chart and is rejected here. |
| scalarDbSagaServer.podLabels | object | `{}` | Labels to add to the pods. A key that the chart already sets, such as `app.kubernetes.io/name`, keeps the value of the chart and your value is dropped without an error. |
| scalarDbSagaServer.podSecurityContext | object | `{"seccompProfile":{"type":"RuntimeDefault"}}` | Security context of the pod. |
| scalarDbSagaServer.properties | object | `{"scalar":{"db":{"contact_points":"","password":"${env:SCALAR_DB_PASSWORD}","saga":{"server":{"tls":{"enabled":false}}},"storage":"","username":"${env:SCALAR_DB_USERNAME}"}}}` | ScalarDB Saga server specific configurations. These configurations will be converted to server.properties file and mounted as a ConfigMap in the deployment. You must write the configurations in nested form. A key that contains a "." (for example, `scalar.db.storage: jdbc`) is rejected because such a key is rendered as is and can set the same property twice. A value must be a single-line scalar. A list, a value that contains a newline, and a value that ends with a backslash are rejected, because server.properties is a line-based format and each of them would be read back as something other than what you wrote. If you want to avoid writing credentials in this file, you can refer to environment variables with the `${env:<NAME>}` syntax. In that case, you must create a secret resource that contains the environment variables and set its name to `scalarDbSagaServer.secretNames`. For example, you can create the secret resource by running `kubectl create secret generic scalardb-credentials-secret --from-literal=SCALAR_DB_USERNAME=postgres --from-literal=SCALAR_DB_PASSWORD=postgres`. Changing these configurations restarts the pods, because the server reads server.properties only at startup. |
| scalarDbSagaServer.replicaCount | int | `3` | Number of ScalarDB Saga server pods to run. |
| scalarDbSagaServer.resources | object | `{}` | Resource requests and limits for the output Deployment definition. The chart sets none by default, so the pods run with the BestEffort quality of service and are the first to be evicted when a node runs out of resources. Set both for a production deployment. |
| scalarDbSagaServer.secretNames | list | `[]` | Names of the secrets whose keys are exposed to the server as environment variables. Use this together with the `${env:<NAME>}` syntax in `scalarDbSagaServer.properties` to keep credentials out of this file. |
| scalarDbSagaServer.securityContext | object | `{"allowPrivilegeEscalation":false,"capabilities":{"drop":["ALL"]},"runAsNonRoot":true}` | Security context of the ScalarDB Saga server container. |
| scalarDbSagaServer.securityContext.allowPrivilegeEscalation | bool | `false` | Whether a process in the container can gain more privileges than its parent process. |
| scalarDbSagaServer.securityContext.capabilities | object | `{"drop":["ALL"]}` | Linux capabilities of the container. |
| scalarDbSagaServer.securityContext.runAsNonRoot | bool | `true` | Whether the container must run as a non-root user. |
| scalarDbSagaServer.serverOpts | string | `""` | Server options for the ScalarDB Saga server. Passed to the container as the `SCALARDB_SAGA_SERVER_OPTS` environment variable. |
| scalarDbSagaServer.service | object | `{"annotations":{},"grpc":{"port":12051},"http":{"port":12080},"type":"ClusterIP"}` | This is for setting up a service more information can be found here: https://kubernetes.io/docs/concepts/services-networking/service/ |
| scalarDbSagaServer.service.annotations | object | `{}` | Annotations to add to the service. |
| scalarDbSagaServer.service.grpc | object | `{"port":12051}` | Port that the Service exposes for gRPC. The port that the container listens on is fixed, so changing this changes only the Service. |
| scalarDbSagaServer.service.http | object | `{"port":12080}` | Port that the Service exposes for HTTP. The port that the container listens on is fixed, so changing this changes only the Service. |
| scalarDbSagaServer.service.type | string | `"ClusterIP"` | This sets the service type more information can be found here: https://kubernetes.io/docs/concepts/services-networking/service/#publishing-services-service-types |
| scalarDbSagaServer.serviceAccount | object | `{"annotations":{},"automount":false,"create":true,"name":""}` | This section builds out the service account more information can be found here: https://kubernetes.io/docs/concepts/security/service-accounts/ |
| scalarDbSagaServer.serviceAccount.annotations | object | `{}` | Annotations to add to the service account. |
| scalarDbSagaServer.serviceAccount.automount | bool | `false` | Automatically mount a ServiceAccount's API credentials? ScalarDB Saga Server does not call the Kubernetes API, so the token is not mounted by default. |
| scalarDbSagaServer.serviceAccount.create | bool | `true` | Specifies whether a service account should be created. |
| scalarDbSagaServer.serviceAccount.name | string | `""` | The name of the service account to use. If not set and create is true, a name is generated using the fullname template. |
| scalarDbSagaServer.tls | object | `{"egress":{"secretName":""},"server":{"secretName":""}}` | TLS configuration for the output Deployment definition. `server` covers the incoming connections to ScalarDB Saga Server. `egress` covers the outgoing connections that it makes to the Saga services. The two are independent, so set only the side you need. |
| scalarDbSagaServer.tls.egress.secretName | string | `""` | The name of the secret containing the CA certificate for egress. We expect this secret to have the key 'ca.crt'. ScalarDB Saga Server uses this CA, typically an intermediate CA, to verify the certificates of the HTTPS APIs that it calls as a client. Set this when any `base_url` in the ConfigMap named by `scalarDbSagaServer.configMapNames.sagaServices` uses `https://`. |
| scalarDbSagaServer.tls.server.secretName | string | `""` | The name of the secret containing the TLS certificate and key. We expect this secret to have the keys 'tls.crt', 'tls.key', and 'ca.crt'. Set this together with `scalarDbSagaServer.properties.scalar.db.saga.server.tls.enabled`, which the chart also reads to select the scheme of the health probes. Setting only one of the two is rejected. |
| scalarDbSagaServer.tolerations | list | `[]` | Tolerations for the output Deployment definition. |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.14.2](https://github.com/norwoodj/helm-docs/releases/v1.14.2)
