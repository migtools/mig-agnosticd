OUR_DIR=`pwd`

if [[ -z "${AGNOSTICD_HOME}" ]]; then
    echo "Please ensure that 'AGNOSTICD_HOME' is set before running."
    exit
fi

pushd .
cd ${AGNOSTICD_HOME} 
ansible-playbook  ./ansible/configs/ocp4-workshop/destroy_env.yml ${OUR_DIR}/../archive_deleted.yml -e @${OUR_DIR}/my_vars.yml -e @${OUR_DIR}/ocp4_vars.yml -e @${OUR_DIR}/../secret.yml  -vv
popd