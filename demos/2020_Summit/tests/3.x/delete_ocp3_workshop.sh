OUR_DIR=`pwd`

if [[ -z "${AGNOSTICD_HOME}" ]]; then
    echo "Please ensure that 'AGNOSTICD_HOME' is set before running."
    exit
fi

pushd .
cd ${AGNOSTICD_HOME} 
ansible-playbook ${AGNOSTICD_HOME}/ansible/configs/ocp-workshop/destroy_env.yml ${OUR_DIR}/../../../../archive_deleted.yml -e @${OUR_DIR}/my_vars.yml -e @${OUR_DIR}/ocp3_vars.yml -e @${OUR_DIR}/../../../../secret.yml   
popd
