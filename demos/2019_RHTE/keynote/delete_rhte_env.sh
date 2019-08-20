#!/bin/bash

OUR_DIR=`pwd`

INFO='\033[0;32m'
NC='\033[0m'

info() {
        echo -e "${INFO}${1}${NC}"
}

if [[ -z "${AGNOSTICD_HOME}" ]]; then
    echo "Please ensure that 'AGNOSTICD_HOME' is set before running."
    exit
fi

pushd ${OUR_DIR}
cd ${AGNOSTICD_HOME}

option="$1"

echo "Deleting OCP3 environment..."
ansible-playbook ${AGNOSTICD_HOME}/ansible/configs/ocp-workshop/destroy_env.yml -e @${OUR_DIR}/3.x/my_vars.yml -e @${OUR_DIR}/3.x/ocp3_vars.yml -e @${OUR_DIR}/secret.yml &> ${OUR_DIR}/ocp3.delete.log &
#pid_v3=$!
info "Run 'tail -f ${OUR_DIR}/ocp3.delete.log' for deletion logs"

echo "Deleting OCP4 environment..."
ansible-playbook ${AGNOSTICD_HOME}/ansible/configs/ocp4-workshop/destroy_env.yml -e @${OUR_DIR}/4.x/my_vars.yml -e @${OUR_DIR}/4.x/ocp4_vars.yml -e @${OUR_DIR}/secret.yml &> ${OUR_DIR}/ocp4.delete.log &
pid_v4=$!
info "Run 'tail -f ${OUR_DIR}/ocp4.delete.log' for deletion logs"
popd
