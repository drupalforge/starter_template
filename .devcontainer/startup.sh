#!/usr/bin/env bash
set -eu -o pipefail

marker=${TMPDIR:-/tmp}/drupalforge-devcontainer-init.complete
if [ -f "$marker" ]; then
  exit 0
fi

read_input() {
  local prompt=$1 default=$2
  if IFS= read -r -t 10 -p "$prompt" REPLY; then
    return
  fi
  printf '\n'
  REPLY=$default
  echo 'No input received; using default.'
}

read_choice() {
  local prompt=$1 default=$2
  while true; do
    read_input "$prompt [$default]: " "$default"
    REPLY=${REPLY:-$default}
    case "$REPLY" in
      y|Y|yes|YES) REPLY=yes; return ;;
      n|N|no|NO) REPLY=no; return ;;
      *) echo 'Enter yes or no.' ;;
    esac
  done
}

if [ ! -t 0 ]; then
  echo 'An interactive terminal is required to initialize this dev container.' >&2
  exit 1
fi

PROJECT=${PROJECT:-}
read_choice 'Customize initialization settings?' n
if [ "$REPLY" = yes ]; then
  debug_default=n
  if [ -n "${DEBUG_SCRIPT:-}" ]; then
    debug_default=y
  fi
  read_choice 'Enable script debugging?' "$debug_default"
  if [ "$REPLY" = yes ]; then
    export DEBUG_SCRIPT=1
  else
    unset DEBUG_SCRIPT
  fi

  while true; do
    read_input "Composer project [${PROJECT:-default}]: " "$PROJECT"
    PROJECT=${REPLY:-$PROJECT}
    if [[ -z "$PROJECT" || "$PROJECT" =~ ^[a-zA-Z0-9][a-zA-Z0-9_.-]*/[a-zA-Z0-9][a-zA-Z0-9_.-]*$ ]]; then
      break
    fi
    echo 'Enter a Composer project in vendor/package format.'
  done
else
  echo 'Using environment settings and defaults.'
fi
export PROJECT

.devpanel/init.sh
touch "$marker"
