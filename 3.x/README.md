# Overview
The scripts here will deploy an OpenShift 3 cluster with a Bastion host, all ssh traffic to cluster needs to use the bastion as proxy.  Provisioning will likely take on order of ~70-90 minutes to complete.
 
# Usage
## Create Cluster
1. Ensure that you have a `../secret.yml` in the parent directory
1. Ensure that you have `cp my_vars.yml.sample my_vars.yml` and you have edited 'my_vars.yml'
1. Ensure that `AGNOSTICD_HOME` environment variable is set
1. Run: `create_ocp3_workshop.sh`
1. Wait ... ~70 - 90 minutes

## Destroy Cluster
1. Ensure that you have a `../secret.yml` in the parent directory
1. Ensure that you have `cp my_vars.sample.yml my_vars.yml` and you have edited 'my_vars.yml'
1. Ensure that `AGNOSTICD_HOME` environment variable is set
1. Run: `delete_ocp3_workshop.sh`
1. Wait ... ~5 minutes
    * If something goes wrong and you need to do a manual deletion, you can clean up the AWS resources by finding the relevant CloudFormation template and deleting it via the AWS Management Console looking at the CloudFormation service in the correct region.

# Tips

## Example:  oc login

        $ oc login https://master.jmatthewsagn1.mg.dog8code.com:443 -u opentlc-mgr -p r3dh4t1! 
        The server uses a certificate signed by an unknown authority.
        You can bypass the certificate check, but any data you send to the server could be intercepted by others.
        Use insecure connections? (y/n): yes

        # or alternative to create a new kubeconfig file to reference later
        export KUBECONFIG=~/.agnosticd/jmatthewsagn1/kubeconfig
        $ oc login https://master.jmatthewsagn1.mg.dog8code.com -u opentlc-mgr -p r3dh4t1! --config ${KUBECONFIG}
        


## Example:  log into console
1. Look for info of the console in stdout

        skipping: [localhost] => (item=user.info: Openshift Master Console: https://master.jmatthewsagn1.mg.dog8code.com/console)  => {"item": "user.info: Openshift Master Console: https://master.jmatthewsagn1.mg.dog8code.com/console"}

    * Visit:  https://master.jmatthewsagn1.mg.dog8code.com

        * Username:  opentlc-mgr
        * Password:   r3dh4t1! 
        * Can change admin user name with

            * -e 'admin_user=*some_name*


## Example:  SSH into nodes
1. Find the output_dir, defined in `my_vars.yml`
1. Use the generated `*_ssh_conf` in the output directory to leverage the bastion as a proxy

    * Example: 

            $ ssh -F /tmp/agnostic_jmatthewsagn1/ocp-workshop_jmatthewsagn1_ssh_conf master1


# Troubleshooting

## Playbook hangs on a shell command 
The overall installation should take ~ 50 minutes to complete 
If your playbook hangs for unusually longer, find out which task it is hung on. Login to the remote host and pull ansible logs from /root/ansible.log
It will most likely be the case that the task is already completed on remote host but your local playbook is waiting for completion. In that case, you can add a tag to the task on which the playbook hung and run the playbook again by skipping those tasks using  `--skip-tags <YOUR_TAG>`. (only applicable when the task is completed without errors)
More info in https://github.com/redhat-cop/agnosticd/issues/464

## Reloading master configuration
From OKD 3.10 onwards, master processes are nomore managed by systemd on host. They run as pods on the master node. Run /usr/local/bin/master-restart api and /usr/local/bin/master-restart controller to restart master api and controller after updating master-config.

## Playbook exits with error `some required packages are available at higher version than requested` (atomic-openshift package in particular)
Make sure that variable osrelease is set to 3.11.104. 
Versions < 3.11.98 are expected to throw this error

## `oc command not found` error
This is because OCP did not get installed at all.
Make sure you have set software_to_deploy variable to openshift
