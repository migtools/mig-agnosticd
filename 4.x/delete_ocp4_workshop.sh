source ../env
OUR_DIR=`pwd`

pushd .
cd ${AGNOSTICD_HOME} 
ansible-playbook  ./ansible/configs/ocp4-workshop/destroy_env.yml -e @{OUR_DIR}/my_vars.yml -e @${OUR_DIR}/ocp4_vars.yml -e @${OUR_DIR}/../secret.yml  -vv
popd 