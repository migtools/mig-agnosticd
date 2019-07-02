OUR_DIR=`pwd`

pushd .
cd ${AGNOSTICD_HOME} 
ansible-playbook ${AGNOSTICD_HOME}/ansible/main.yml -e @${OUR_DIR}/my_vars.yml -e @${OUR_DIR}/ocp4_vars.yml -e @${OUR_DIR}/../secret.yml   
popd 