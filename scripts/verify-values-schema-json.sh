#!/usr/bin/env bash

set -e -o pipefail; [[ -n "$DEBUG" ]] && set -x

SCRIPT_ROOT="$(cd "$(dirname "$0")"; pwd)"
schemas="${SCRIPT_ROOT}/../charts/**/values.schema.json"

exec "${SCRIPT_ROOT}/verify-files.sh" "${schemas}" "${SCRIPT_ROOT}/update-values-schema-json.sh"
