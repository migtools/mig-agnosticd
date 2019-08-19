#!/bin/bash

INFO='\033[0;32m'
NC='\033[0m'

info() {
	echo -e "${INFO}${1}${NC}"
}

if [[ -z "${AGNOSTICD_HOME}" ]]; then
    error "Please ensure that 'AGNOSTICD_HOME' is set before running."
    exit
fi

OUR_DIR=`pwd`
pushd ${OUR_DIR}
cd ${AGNOSTICD_HOME}

echo "Creating OCP3 env..."
ansible-playbook ${AGNOSTICD_HOME}/ansible/main.yml -e @${OUR_DIR}/3.x/my_vars.yml -e @${OUR_DIR}/3.x/ocp3_vars.yml -e @${OUR_DIR}/secret.yml &> ${OUR_DIR}/ocp3.log &
info "Run 'tail -f ${OUR_DIR}/ocp3.log' for deployment logs"

echo "Creating OCP4 env..."
ansible-playbook ${AGNOSTICD_HOME}/ansible/main.yml -e @${OUR_DIR}/4.x/my_vars.yml -e @${OUR_DIR}/4.x/ocp4_vars.yml -e @${OUR_DIR}/secret.yml &> ${OUR_DIR}/ocp4.log &
info "Run 'tail -f ${OUR_DIR}/ocp4.log' for deployment logs"
popd
