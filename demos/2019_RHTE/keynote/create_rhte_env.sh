#!/bin/bash

INFO='\033[0;33m'
ERROR='\033[0;31m'
SUCCESS='\033[0;32m'
NC='\033[0m'

info() {
	echo -e "${INFO}${1}${NC}"
}

error() {
	echo -e "${ERROR}${1}${NC}"
}

success() {
	echo -e "${SUCCESS}${1}${NC}"
}

if [[ -z "${AGNOSTICD_HOME}" ]]; then
    echo "Please ensure that 'AGNOSTICD_HOME' is set before running."
    exit
fi

OUR_DIR=`pwd`
pushd ${OUR_DIR} &> /dev/null
cd ${AGNOSTICD_HOME}

echo "Creating OCP3 env..."
ansible-playbook ${AGNOSTICD_HOME}/ansible/main.yml -e @${OUR_DIR}/3.x/my_vars.yml -e @${OUR_DIR}/3.x/ocp3_vars.yml -e @${OUR_DIR}/secret.yml &> ${OUR_DIR}/ocp3.log &
pid_v3=$!
info "Run 'tail -f ${OUR_DIR}/ocp3.log' for deployment logs"

echo "Creating OCP4 env..."
ansible-playbook ${AGNOSTICD_HOME}/ansible/main.yml -e @${OUR_DIR}/4.x/my_vars.yml -e @${OUR_DIR}/4.x/ocp4_vars.yml -e @${OUR_DIR}/secret.yml &> ${OUR_DIR}/ocp4.log &
pid_v4=$!
info "Run 'tail -f ${OUR_DIR}/ocp4.log' for deployment logs"
popd &> /dev/null


echo "Waiting for OCP3 deployment to complete..."
if ! wait $pid_v3; then
	error "OCP3 deployment failed..."
        exit 1
fi

success "OCP3 deployment succeded..."

echo "Waiting for OCP4 deployment to complete..."
if ! wait $pid_v4; then
	error "OCP4 deployment failed..."
	exit 1
fi

success "OCP4 deployment succeded..."

echo "Creating Minio mig storage on destination..."
ansible-playbook post-install/minio.yml


echo "Creating mig clusters on destination..."
ansible-playbook post-install/migcluster.yml

echo "Adding CORS settings on source cluster..."
ansible-playbook post-install/cors.yml

success "Success..."
