FROM ubuntu:22.04 AS build

WORKDIR /src

RUN set -x && \
    apt update && \
    apt -y install curl bash

SHELL ["/bin/bash", "-c"]

# Install helm-schema-gen
# https://github.com/scalar-labs/helm-schema-gen
RUN set -x && \
    curl -L https://github.com/scalar-labs/helm-schema-gen/releases/download/0.0.4/helm-schema-gen_0.0.4_Linux_x86_64.tar.gz | tar xvzf - -C /

COPY . .

RUN set -x && \
    ls -d charts/* | xargs -I{} sh -c "/helm-schema-gen {}/values.yaml >{}/values.schema.json"

FROM scratch AS output
COPY --from=build /src/charts charts
