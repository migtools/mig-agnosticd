#!/bin/bash

# Required for MacOS with virtualenv
# as per https://github.com/konveyor/mig-agnosticd/issues/182
export OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES

OUR_DIR=`pwd`

if [[ -z "${AGNOSTICD_HOME}" ]]; then
    echo "Please ensure that 'AGNOSTICD_HOME' is set before running."
    exit
fi

pushd .
cd ${AGNOSTICD_HOME} 
ansible-playbook ${AGNOSTICD_HOME}/ansible/main.yml -e @${OUR_DIR}/my_vars.yml -e @${OUR_DIR}/ocp4_vars.yml -e @${OUR_DIR}/../secret.yml "$@"
rc=$?
popd
exit ${rc}
