# Overview
The scripts here will deploy an OpenShift 4 cluster with a Bastion host.  Provisioning will likely take on order of ~60 minutes to complete.
 
# Usage
## Create Cluster
1. Ensure that you have a `../secret.yml` in the parent directory
1. Ensure that you have `cp my_vars.sample.yml my_vars.yml` and you have edited 'my_vars.yml'
1. Ensure that `AGNOSTICD_HOME` environment variable is set
1. Run: `create_ocp4_workshop.sh`
1. Wait ... ~60 minutes

## Destroy Cluster
1. Ensure that you have a `../secret.yml` in the parent directory
1. Ensure that you have `cp my_vars.sample.yml my_vars.yml` and you have edited 'my_vars.yml'
1. Ensure that `AGNOSTICD_HOME` environment variable is set
1. Run: `delete_ocp4_workshop.sh`
1. Wait ... ~5-10 minutes
    * If something goes wrong, manual cleanup is difficult.  The rough steps are later in this document.

    



# Tips

## Example: Running `oc` or `kubectl` commands with provided 'KUBECONFIG', need to `export KUBECONFIG`
You will find a kubeconfig file has been copied to your host in the `output_dir` specified in `my_vars.yml`

* Example, my output_dir is `/tmp/agnostic_jwm0702ocp4a` and in there is a file `ocp4-workshop_jwm0702ocp4a_kubeconfig`

        $ export KUBECONFIG=/tmp/agnostic_jwm0702ocp4a/ocp4-workshop_jwm0702ocp4a_kubeconfig
        $ oc whoami
        system:admin

## Obtaining kubeadmin password

Look in the directory configured by `output_dir` specified in `my_vars.yml`, in that directory will be a file `*_kubeadmin-password` it will contain the password for 'kubeadmin'

        $ cat /tmp/agnostic_jwm0702ocp4a/ocp4-workshop_jwm0702ocp4a_kubeadmin-password 
        d34yS-vY429C-7fj2-CmEa9



## Log into the web console
The console address is computed as:
`https://console-openshift-console.apps.cluster-${GUID}.${guid}.${subdomain_base_suffix}/`

* For example in `my_vars.yml` I have

        guid:                   jwm0702ocp4a
        subdomain_base_suffix:  .mg.dog8code.com

* So my console is at: https://console-openshift-console.apps.cluster-jwm0702ocp4a.jwm0702ocp4a.mg.dog8code.com/

* I can also determine this by looking at the routes in the `openshift-console` namespace on the cluster


        $ export KUBECONFIG=/tmp/agnostic_jwm0702ocp4a/ocp4-workshop_jwm0702ocp4a_kubeconfig
        $ oc get routes -n openshift-console
        NAME        HOST/PORT       PATH   SERVICES PORT    TERMINATION          WILDCARD
        console     console-openshift-console.apps.cluster-jwm0702ocp4a.jwm0702ocp4a.mg.dog8code.com            console     https   reencrypt/Redirect   None
        downloads   downloads-openshift-console.apps.cluster-jwm0702ocp4a.jwm0702ocp4a.mg.dog8code.com          downloads   http    edge                 None

* I log in with credentials of:

    * Username:  'kubeadmin'
    * Password:   From `${output_dir}/ocp4-workshop_${guid}_kubeadmin-password`




## SSH
OCP 4 environments are not typically ones you will SSH into, yet for this case the install is happening on the 'clientvm', so you may find it useful to ssh to the clientvm

* To find the 'clientvm' look at your `output_dir` from `my_vars.yml`, then find the file ending in `*_ssh_conf` in that directory.

    * Example, mine is `/tmp/agnostic_jwm0702ocp4a/ocp4-workshop_jwm0702ocp4a_ssh_conf`

            $ cat /tmp/agnostic_jwm0702ocp4a/ocp4-workshop_jwm0702ocp4a_ssh_conf
            ##### BEGIN ADDED BASTION PROXY HOST clientvm.jwm0702ocp4a.internal ocp4-workshop-jwm0702ocp4a ######
            Host clientvm.jwm0702ocp4a.internal clientvm
                Hostname ec2-34-209-31-72.us-west-2.compute.amazonaws.com
                IdentityFile ~/.ssh/libra.pem
                IdentitiesOnly yes
                User ec2-user
                ControlMaster auto
                ControlPath /tmp/jwm0702ocp4a-%r-%h-%p
                ControlPersist 5m
                StrictHostKeyChecking no
                ConnectTimeout 60
                ConnectionAttempts 10
                UserKnownHostsFile /tmp/agnostic_jwm0702ocp4a/ocp4-workshop_jwm0702ocp4a_ssh_known_hosts
            ##### END ADDED BASTION PROXY HOST clientvm.jwm0702ocp4a.internal ocp4-workshop-jwm0702ocp4a ######
    * SSH into the clientvm

            $ ssh -i ~/.ssh/libra.pem ec2-user@ec2-34-209-31-72.us-west-2.compute.amazonaws.com
            [ec2-user@clientvm 0 ~]$ cd cluster-jwm0702ocp4a/
            [ec2-user@clientvm 0 ~/cluster-jwm0702ocp4a]$ ls
            auth/  metadata.json  terraform.aws.auto.tfvars  terraform.tfstate  terraform.tfvars  tls/
            $ openshift-install destroy cluster


# Troubleshooting

## Manual cleanup if something goes wrong from `delete_ocp4_workshop.sh`
1. Attempt to run "openshift-install destroy cluster" from the clientvm that deployed the cluster

    * Follow steps above in 'Tips' to ssh into your clientvm

            $ ssh -i ~/.ssh/libra.pem ec2-user@ec2-34-209-31-72.us-west-2.compute.amazonaws.com
            
            [ec2-user@clientvm 0 ~]$ cd cluster-jwm0702ocp4a/

            [ec2-user@clientvm 0 ~/cluster-jwm0702ocp4a]$ ls
            auth/  metadata.json  terraform.aws.auto.tfvars  terraform.tfstate  terraform.tfvars  tls/

            $ openshift-install destroy cluster 
            
1. After you have cleaned up the terraform provisioned resources and only after, then you can tear down the clientvm by deleting the associated CloudFormation template

    * Remember...the terraform state of the ocp 4 cluster is stored locally on the clientvm .... don't delete the clientvm until you have attempt to run `openshift-install destroy cluster`


## Error converting YAML to JSON. Could not find expected key ‘Install Config’
This is most likely because of a bad custom configuration file generated for cluster installation. 
In my case, it was because I did not put ocp4_token (pull-secret) within single inverted commas.
    
## Playbook hangs on `openshift-installer create` phase
Make sure that the cluster creation is complete. To ensure that it is complete, login to clientvm host. There would be a directory created at /home/ec2-user/cluter-<GUID> for your cluster installation. Tail .openshift_installer.log file in that directory. Check whether the cluster creation step succeded. If not, wait till it completes. You can also ensure whether the openshift-installer process exited. If all of this looks okay to you, then your playbook just hung on shell completion or a bad network connection. You can follow steps in this issue.

## `htpasswd` replaces the default kubeadmin user 
Use opentlc-mgr as user and r3dh4t1!  as password
