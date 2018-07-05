#!/usr/bin/env bash

# Entrypoint example.
# This is an example entrypoint utilising Panubo practice, and demonstrating
# various methods for container initialization.

# See: https://github.com/panubo/bash-container for additional
# entrypoint functions

# LICENSE: MIT License, Copyright (c) 2017-2018 Volt Grid Pty Ltd t/a Panubo

# run_deployfile [FILENAME]
# run_deployfile Deployfile
run_deployfile() {
  # Run all Deployfile commands
  local deployfile="${1:-'Deployfile'}"
  local command_run=false
  if [[ ! -e "${deployfile}" ]]; then return 0; fi
  while read -r line || [[ -n "${line}" ]]; do
    if [[ -z "${line}" ]] || [[ "${line}" == \#* ]]; then continue; fi
    (>&2 echo "Running task ${line%%:*}: ${line#*:[[:space:]]}")
    eval "${line#*:[[:space:]]}"
    rc=$?
    [[ "${rc}" -ne 0 ]] && return "${rc}"
    command_run=true
  done < "${deployfile}"
  [[ "${command_run}" == "true" ]] && return 0
  # return 1 if no commands were run
  return 1
}

# exec_procfile FILENAME TYPE
# exec_procfile Procfile web
exec_procfile() {
  # Exec Procfile command
  local procfile="${1:-'Procfile'}"
  if [[ ! -e "${procfile}" ]]; then return 0; fi
  while read -r line || [[ -n "${line}" ]]; do
    if [[ -z "${line}" ]] || [[ "${line}" == \#* ]]; then continue; fi
    if [[ "${2}" == "${line%%:*}" ]]; then
      echo "Executing ${2} from ${1}..."
      eval exec "${line#*:[[:space:]]}"
    fi
  done < "${procfile}"
}

# Run all commands specified in the Deployfile
run_deployfile Deployfile
# Try to run a procfile command
exec_procfile Procfile "$1"
# fall back and execute the passed arg
exec "$@"
