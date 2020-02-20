# Overview
The scripts here will deploy an OpenShift 3.11 cluster with the same variables as intended for Summit 2020 Labs for OpenShift Migrations.
Provisioning will likely take on order of ~70-90 minutes to complete.
 
# Usage
## Create Cluster
1. Ensure that you have a `../../../../secret.yml` in the top level directory of this repo
1. Ensure that you have `cp my_vars.yml.sample my_vars.yml` and you have edited 'my_vars.yml'
1. Ensure that `AGNOSTICD_HOME` environment variable is set
1. Run: `create_ocp3_workshop.sh`
1. Wait ... ~70 - 90 minutes

## Destroy Cluster
1. Ensure that you have a `../../../../secret.yml` in the parent directory
1. Ensure that you have `cp my_vars.sample.yml my_vars.yml` and you have edited 'my_vars.yml'
1. Ensure that `AGNOSTICD_HOME` environment variable is set
1. Run: `delete_ocp3_workshop.sh`
1. Wait ... ~5-10 minutes
    * If something goes wrong and you need to do a manual deletion, you can clean up the AWS resources by finding the relevant CloudFormation template and deleting it via the AWS Management Console looking at the CloudFormation service in the correct region.

# Tips

## Example:  oc login

        $ oc login https://master.jmatthewsagn1.mg.dog8code.com:443 -u admin -p r3dh4t1! 
        The server uses a certificate signed by an unknown authority.
        You can bypass the certificate check, but any data you send to the server could be intercepted by others.
        Use insecure connections? (y/n): yes

        # or alternative to create a new kubeconfig file to reference later
        export KUBECONFIG=~/.agnosticd/jmatthewsagn1/kubeconfig
        $ oc login https://master.jmatthewsagn1.mg.dog8code.com -u admin -p r3dh4t1! --config ${KUBECONFIG}
        


## Example:  log into console
1. Look for info of the console in stdout

        skipping: [localhost] => (item=user.info: Openshift Master Console: https://master.jmatthewsagn1.mg.dog8code.com/console)  => {"item": "user.info: Openshift Master Console: https://master.jmatthewsagn1.mg.dog8code.com/console"}

    * Visit:  https://master.jmatthewsagn1.mg.dog8code.com

        * Username:   admin
        * Password:   r3dh4t1! 
        * Can change admin user name with

            * -e 'admin_user=*some_name*


## Example:  SSH into nodes
1. Find the output_dir, defined in `my_vars.yml`
1. Use the generated `*_ssh_conf` in the output directory to leverage the bastion as a proxy

    * Example: 

            $ ssh -F /tmp/agnostic_jmatthewsagn1/ocp-workshop_jmatthewsagn1_ssh_conf master1
