#!/bin/bash
# POSIX

# Error handling.
# $1 - error string
die() {
  echo "${0##*/}: error: $*" >&2
  exit 1
}

# As the name suggests
usage() {
  echo "Usage: ${0##*/}  [-h] --token <token hash> --provider <provider ip> 

This script starts Oneclient components:

Example usage:
${0##*/} --provider 172.16.0.1 --token '_Us_MYaSD80YgPpcKfVSLP-Mz3TIqmN1q1vb3qFJ'
or
export ONECLIENT_AUTHORIZATION_TOKEN='_Us_MYaSD80YgPpcKfVSLP-Mz3TIqmN1q1vb3qFJ'
${0##*/} --provider 'node1.oneprovider.onedata.example.com'

Options:
  -h, --help         display this help and exit
  -t, --token        authorization token
  -p, --provider     ip or hostname of provider you want to connect to"
  exit 0
}


main() {
  local token
  local provider
  local mount_point

  if [ ! -z "$ONECLIENT_AUTHORIZATION_TOKEN" ]; then
    token=$ONECLIENT_AUTHORIZATION_TOKEN
  fi

  if [ ! -z "$PROVIDER_HOSTNAME" ]; then
    provider=$PROVIDER_HOSTNAME
  fi

  while (( $# )); do
      case $1 in
          -h|-\?|--help)   # Call a "usage" function to display a synopsis, then exit.
              usage
              exit 0
              ;;
          -t | --token)       
              token=$2
              shift
              ;;
          -p | --provider)      
              provider=$2
              shift
              ;;
          -m | --mount-point)       
              mount_point=$2
              shift
              ;;
          -?*)
              printf 'WARN: Unknown option (ignored): %s\n' "$1" >&2
              exit 1
              ;;
          *)
              die "no option ${flag}"
              ;;
      esac
      shift
  done

  if [ -z "$token" ]; then
    die "no authorization token supplied. See --help option."
  fi

  if [ -z "$provider" ]; then
    echo "No provider supplied. Assuming \"localhost\"."
    provider="localhost"
  fi
  
  service='oneclient'
  ONECLIENT_AUTHORIZATION_TOKEN=$token PROVIDER_HOSTNAME=$provider docker-compose -f "docker-compose-${service}.yml" up -d "oneclient"
  
}

