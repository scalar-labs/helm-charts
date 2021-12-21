#!/usr/bin/env bash

# Generate json schema for chart values.
#
# https://github.com/karuppiah7890/helm-schema-gen

set -e -o pipefail [[ -n "$DEBUG" ]] && set -x

SCRIPT_ROOT="$(cd "$(dirname "$0")"; pwd)"

DOCKER_BUILDKIT=1 docker build \
  -f "${SCRIPT_ROOT}/update-values-schema-json/Dockerfile" \
  --output "${SCRIPT_ROOT}/../" \
  "${SCRIPT_ROOT}/../"
