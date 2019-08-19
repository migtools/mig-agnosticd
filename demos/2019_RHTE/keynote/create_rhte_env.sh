#!/bin/bash

if [[ -z "${AGNOSTICD_HOME}" ]]; then
    echo "Please ensure that 'AGNOSTICD_HOME' is set before running."
    exit
fi

OUR_DIR=`pwd`
pushd ${OUR_DIR}
cd ${AGNOSTICD_HOME}

echo "Creating OCP3 env..."
ansible-playbook ${AGNOSTICD_HOME}/ansible/main.yml -e @${OUR_DIR}/3.x/my_vars.yml -e @${OUR_DIR}/3.x/ocp3_vars.yml -e @${OUR_DIR}/secret.yml

echo "Creating OCP4 env..."
ansible-playbook ${AGNOSTICD_HOME}/ansible/main.yml -e @${OUR_DIR}/4.x/my_vars.yml -e @${OUR_DIR}/4.x/ocp4_vars.yml -e @${OUR_DIR}/secret.yml
popd
