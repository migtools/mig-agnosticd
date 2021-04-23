#!/bin/bash
#
# This script aims to automate Bookbag setup for MTC Lab
# Since there is currently no easy way to guess the OCP3
# enviromnent, we need to ask a user for GUID. 
# Based on the given GUID we can set the rest of the Bookbag instructions up

# These should be overwritten by Ansible after deployment. 
# BEGIN ANSIBLE MANAGED BLOCK
STUDENT=STUDENT
PASSWORD=PASSWORD
API_LOGIN=API_LOGIN
API_PASS=API_PASS
API_ADDRESS=API_ADDRESS
LOCAL_GUID=GUID
# END ANSIBLE MANAGED BLOCK

HOME="/home/$STUDENT"

main(){

# Print a welcome message and ask user for input
welcome_message
check_guid

# Try to reach the OCP 3 cluster, and copy the cluster.info over
get_cluster_info

# Run the bookbag playbook
deploy_bookbag

# Modify bashrc and move the script away to 'startup' after completion
cleanup

}






# Functions go here
# Function which welcomes the user and asks for OCP3 hostname

welcome_message() {
    clear
    cat << EOF
    ██╗    ██╗███████╗██╗      ██████╗ ██████╗ ███╗   ███╗███████╗
    ██║    ██║██╔════╝██║     ██╔════╝██╔═══██╗████╗ ████║██╔════╝
    ██║ █╗ ██║█████╗  ██║     ██║     ██║   ██║██╔████╔██║█████╗
    ██║███╗██║██╔══╝  ██║     ██║     ██║   ██║██║╚██╔╝██║██╔══╝
    ╚███╔███╔╝███████╗███████╗╚██████╗╚██████╔╝██║ ╚═╝ ██║███████╗
     ╚══╝╚══╝ ╚══════╝╚══════╝ ╚═════╝ ╚═════╝ ╚═╝     ╚═╝╚══════╝

                        ████████╗ ██████╗
                        ╚══██╔══╝██╔═══██╗
                           ██║   ██║   ██║
                           ██║   ██║   ██║
                           ██║   ╚██████╔╝
                           ╚═╝    ╚═════╝

        ███╗   ███╗████████╗ ██████╗    ██╗      █████╗ ██████╗
        ████╗ ████║╚══██╔══╝██╔════╝    ██║     ██╔══██╗██╔══██╗
        ██╔████╔██║   ██║   ██║         ██║     ███████║██████╔╝
        ██║╚██╔╝██║   ██║   ██║         ██║     ██╔══██║██╔══██╗
        ██║ ╚═╝ ██║   ██║   ╚██████╗    ███████╗██║  ██║██████╔╝
        ╚═╝     ╚═╝   ╚═╝    ╚═════╝    ╚══════╝╚═╝  ╚═╝╚═════╝

   =================================================================
EOF
    printf "\nPlease enter your OCP3 bastion hostname. \nThat is the one you received FOR YOUR OCP3 environment: "
    check_hostname
}

check_guid(){
    # Check if the GUID is from the LOCAL system
    while [ $GUID = $LOCAL_GUID ]
    do
        printf "\nPlease enter the OCP3 hostname, NOT the OCP4 (local) system hostname: "
        check_hostname
    done
    printf "Your OCP3 GUID is $GUID. \nWorking...\n"
}

check_hostname(){
    read HOSTNAME
    if [[ "$HOSTNAME" =~ "@" ]]
        then
            # Someone pasted the whole thing, with the username, strip it
            HOSTNAME=$(echo $HOSTNAME|cut -d @ -f 2)
    fi
    GUID=$(echo $HOSTNAME|cut -d . -f 2)
    # printf "GUID: $GUID\n"
}

get_cluster_info(){
    printf "Checking cluster connectivity\n"
    check_host=(sshpass -p "$PASSWORD" ssh -o StrictHostKeyChecking=no $STUDENT@$HOSTNAME ls cluster.info)
    until "${check_host[@]}"
    do
        printf "Host still not reachable. Waiting 15s and trying again\n"
        sleep 15
    done
    # Getting and merging the cluster.info files.
    if sshpass -p "$PASSWORD" scp $STUDENT@$HOSTNAME:./cluster.info cluster.ocp3
    then
        printf "Grabbing cluster info from OCP3 cluster\n"
        cp cluster.info cluster.orig
        cat cluster.ocp3 >> cluster.info
    else
        printf "Couldn't copy the cluster.info file from OCP3\n"
        exit 1
    fi
}

deploy_bookbag(){
    # We have to oc login to be able to make changes to the cluster
    oc login -u $API_LOGIN -p $API_PASS --insecure-skip-tls-verify=true $API_ADDRESS

    # Since we are logged in, enable NooBaa admin for web UI

    enable_nooba_admin

    # Now run the ansible-playbook to deploy Bookbag

    ansible-playbook -e ocp3_password=$PASSWORD -e ocp4_password=$PASSWORD bookbag.yml > >(tee -a bookbag.log) 2> >(tee -a bookbag_err.log >&2)
    BOOKBAG_URL=$(sed -n 's/.*\(bookbag-.*\)".*/\1/p' bookbag.log)
    printf "\nWaiting for Bookbag to become available"
    until [[ $(curl -k -s https://$BOOKBAG_URL) =~ "Redirecting" ]]
    do
       printf "."
       sleep 10
    done
    printf "\n\n\t\tYour Bookbag is up and running. \n\t\t    You can reach it via:\n"
    printf "\n\t https://$BOOKBAG_URL\n\n"
    printf "\n\t\t\tHappy Migrating!\n\n"
}

enable_nooba_admin(){
   oc adm groups new cluster-admins
   oc adm policy add-cluster-role-to-group cluster-admin cluster-admins
   oc adm groups add-users cluster-admins admin
}

cleanup(){
    mkdir startup
    mv prepare_station.sh startup
    sed -i '/prepare_station.sh/d' $HOME/.bashrc
}

main "$@"
exit
