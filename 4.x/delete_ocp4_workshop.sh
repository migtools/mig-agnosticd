OUR_DIR=`pwd`

# Required for MacOS with virtualenv
# as per https://github.com/konveyor/mig-agnosticd/issues/182
export OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES

if [[ -z "${AGNOSTICD_HOME}" ]]; then
    echo "Please ensure that 'AGNOSTICD_HOME' is set before running."
    exit
fi

pushd .
cd ${AGNOSTICD_HOME}
ansible-playbook  ./ansible/configs/ocp4-cluster/destroy_env.yml ${OUR_DIR}/../archive_deleted.yml -e @${OUR_DIR}/my_vars.yml -e @${OUR_DIR}/ocp4_vars.yml -e @${OUR_DIR}/../secret.yml "$@"
popd
