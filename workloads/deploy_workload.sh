#!/bin/bash

# This script deploys a workload on specified OCP cluster
# It assumes that the cluster is launched with mig-agnosticd

USAGE="$(basename "$0") [-h] [-w WORKLOAD] [-e OCP_VERSION (3 or 4)] [-a ACTION]

Options :
  -h    Show this help
  -w    Name of the workload to deploy
  -v    OCP Version (3 or 4)
  -a    Action ('create' or 'remove')

Note : 
  Make sure your cluster was launched using mig-agnosticd

Example Usage :
  $(basename "$0") -w migration -v 3 -a remove
  $(basename "$0") -w mssql -v 4 -a create
"

WORKLOAD=""
OCP=""
OPTARG=""

while getopts ':hw:v:a:' option; do
  case "$option" in
    h) echo "$USAGE"
       exit
       ;;
    w) WORKLOAD=$OPTARG
       ;;
    v) OCP=$OPTARG
       ;; 
    a) ACTION=$OPTARG
       ;;
    :) printf "missing argument for -%s\n" "$OPTARG" >&2
       echo "$USAGE" >&2
       exit 1
       ;;
   \?) printf "illegal option: -%s\n" "$OPTARG" >&2
       echo "$USAGE" >&2
       exit 1
       ;;
  esac
done
if ((OPTIND < 6))
then
  echo -e "Missing required options...\n"
  echo "$USAGE"
  exit 1
fi
shift $((OPTIND -1))


if [ ${AGNOSTICD_HOME} == "" ]; then
  echo "Please set AGNOSTICD_HOME env variable..."
  exit 1
fi

if [ ${ACTION} != "create" ] && [ ${ACTION} != "remove" ]; then
  echo -e "Invalid action...\n"
  echo "$USAGE"
  exit 1
fi

export ANSIBLE_ROLES_PATH=${AGNOSTICD_HOME}/ansible/roles
ansible-playbook ./workload.yml \
    -e"action=${ACTION}" \
    -e"workload=${WORKLOAD}" \
    -e"agnosticd_home=${AGNOSTICD_HOME}" \
    -e"ocp_version=${OCP}"
unset ANSIBLE_ROLES_PATH


