#!/usr/bin/env bash

set -e -o pipefail; [[ -n "$DEBUG" ]] && set -x

SCRIPT_ROOT="$(cd "$(dirname "$0")"; pwd)"
docs="${SCRIPT_ROOT}/../charts/**/README.md"

exec "${SCRIPT_ROOT}/verify-files.sh" "${docs}" "${SCRIPT_ROOT}/update-chart-docs.sh"
