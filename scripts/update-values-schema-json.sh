#!/usr/bin/env bash

# Generate json schema for chart values.
#
# https://github.com/karuppiah7890/helm-schema-gen

set -e -o pipefail [[ -n "$DEBUG" ]] && set -x

chart_dirs=$(ls charts)
for chart_dir in ${chart_dirs}; do
  echo "schema-gen charts/${chart_dir} chart..."
  helm schema-gen "charts/${chart_dir}/values.yaml" >| "charts/${chart_dir}/values.schema.json"
done
