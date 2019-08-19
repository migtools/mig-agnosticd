#!/bin/bash

OUR_DIR=`pwd`

if [[ -z "${AGNOSTICD_HOME}" ]]; then
    echo "Please ensure that 'AGNOSTICD_HOME' is set before running."
    exit
fi

pushd ${OUR_DIR}
cd ${AGNOSTICD_HOME}

echo "Deleting OCP3 environment..."
ansible-playbook ${AGNOSTICD_HOME}/ansible/configs/ocp-workshop/destroy_env.yml -e @${OUR_DIR}/3.x/my_vars.yml -e @${OUR_DIR}/3.x/ocp3_vars.yml -e @${OUR_DIR}/secret.yml

echo "Deleting OCP4 environment..."
ansible-playbook ${AGNOSTICD_HOME}/ansible/configs/ocp4-workshop/destroy_env.yml -e @${OUR_DIR}/4.x/my_vars.yml -e @${OUR_DIR}/4.x/ocp3_vars.yml -e @${OUR_DIR}/secret.yml
popd
