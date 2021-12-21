#!/usr/bin/env bash

set -e -o pipefail; [[ -n "$DEBUG" ]] && set -x

files_path=$1
exec_script_path=$2

if [ $# -ne 2 ]; then
  echo "Usage: $(basename "$0") <files_path> <exec_script_path>" >&2
  exit 1
fi

"${exec_script_path}"

set +e
git diff --no-patch --exit-code "$files_path"
exit_code="$?"
set -e

# Discard changes
git checkout -- "$files_path"

if [[ "$exit_code" != 0 ]]; then
  echo
  echo "Run ${exec_script_path}"
  exit 1
fi
