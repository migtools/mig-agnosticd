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

main(){
    
# Print a welcome message and ask user for input
welcome_message_guid
# Try to reach the OCP 3 cluster, and copy the cluster.info over
get_cluster_info

# Run the bookbag playbook
deploy_bookbag

# Modify bashrc and move the script away to /tmp after completion

#sed 

}


# Functions go here
# Function which welcomes the user and asks for OCP3 hostname

welcome_message_guid() {
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
printf "\nPlease enter your OCP3 bastion hostname. \nThat is the one you received for SSH into OCP3 environment: "
check_hostname

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
            HOSTNAME=$(echo $SSH_HOSTNAME|cut -d @ -f 2)
    fi 
    GUID=$(echo $HOSTNAME|cut -d . -f 2)
    # printf "GUID: $GUID\n"

}

# Getting and merging the cluster.info files. 
get_cluster_info(){
    printf "Checking cluster connectivity\n"
    check_host=(sshpass -p "$PASSWORD" ssh -o StrictHostKeyChecking=no $STUDENT@$HOSTNAME ls cluster.info)
    while ! "${check_host[@]}"
    do
    printf "Host still not reachable. Waiting 15s and trying again\n"
    sleep 15
    done
    
    printf "Grabbing cluster info from OCP3 cluster\n"
    sshpass -p "$PASSWORD" scp $STUDENT@$SSH_HOSTNAME:./cluster.info cluster.ocp3
    cat cluster.ocp3 >> cluster.info

}

deploy_bookbag(){
    # We have to oc login to be able to make changes to the cluster
    oc login -u $API_LOGIN -p $API_PASS --insecure-skip-tls-verify=true $API_ADDRESS


}

main "$@"
exit