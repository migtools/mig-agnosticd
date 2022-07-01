# OCP Migration Environments

This repository contains configuration files and scripts intended to deploy OCP 3.x and 4.x environments to aid in developing and testing Cluster Application Migration Tool.  All workflows are leveraging https://github.com/redhat-cop/agnosticd.

This repository is focused on providing the exact scripts/config files we are using so we may all work from a common configuration.  The intent is that all future contributions continue to be done upstream in https://github.com/redhat-cop/agnosticd and this repo serves as the specific bash and yaml files to kick off agnosticd in the exact manner we require.

Note we are only provisioning to AWS with the provided configurations.

# What is offered
## AWS OCP 3.x Environment (Intended to be our Source Cluster)
An OpenShift Ansible provisioned AWS multi-node environment leveraging CloudFormation for AWS infrastructure.

The https://github.com/konveyor/mig-agnosticd/tree/master/3.x directory provides a means of deploying a '3.11' cluster.
Additionally we will install:
  - Velero (our Fork):              https://github.com/konveyor/velero
  - Velero Plugins:

    - https://github.com/konveyor/openshift-migration-plugin
    - https://github.com/konveyor/openshift-velero-plugin
  - Restic (our Fork):              https://github.com/konveyor/restic

## AWS OCP 4.x Environment (Intended to be our Destination Cluster)
An OpenShift Installer provisoned (IPI) AWS multi-node environment leveraging Terraform via the installer.

The https://github.com/konveyor/mig-agnosticd/tree/master/4.x directory provides a means of deploying a '4.1' cluster.
Additionally we will install:
  - Velero (our Fork):              https://github.com/konveyor/velero
  - Velero Plugins:

    - https://github.com/konveyor/openshift-migration-plugin
    - https://github.com/konveyor/openshift-velero-plugin
  - Restic (our Fork):              https://github.com/konveyor/restic
  - Migration CRDs/Controllers:     https://github.com/konveyor/mig-controller
  - Migration UI:                   https://github.com/konveyor/mig-ui



# How are the environments provisioned
This repository is simply configuration files to drive https://github.com/redhat-cop/agnosticd, 'agnosticd' is a collection of Ansible configs/roles we are leveraging to deploy our OCP environments.  

The installation of the Velero and Migration bits are handled via roles in agnosticd which are leveraging the below operators:
  - https://github.com/konveyor/velero-operator
  - https://github.com/konveyor/mig-operator

At this point in time, the operators are _not_ integrated with OLM.  The intent is that agnosticd is installing our operators via regular Deployments and then creating the needed CR's to instruct Operators to install their applications.

# Pre-requisites

1. Follow the [Software Requirements on workstation](https://github.com/redhat-cop/agnosticd/blob/development/docs/Preparing_your_workstation.adoc#software-required-for-deployment) from agnosticd docs


    * https://github.com/redhat-cop/agnosticd/blob/development/docs/Preparing_your_workstation.adoc#software-required-for-deployment

1. AWS Access, you will need AWS access according to the needs of OCP 3.x and 4.x deployments.

    - Admin Access is currently required for OCP 4.x
    - Access to a HostedZone in AWS Route53 is required, meaning you need a domain name managed by Route53 which can serve as the subdomain for your clusters
1. Checkout of https://github.com/redhat-cop/agnosticd 
1. Environment Variable set of 'AGNOSTICD_HOME' pointing to your agnosticd checkout
1. Creation of secret files  in the base directory of this repo, see https://github.com/konveyor/mig-agnosticd/blob/master/secret.yml.sample

    Intent is that you will do something like:

    - `cp secret.yml.sample secret.yml`
    - `vim secret.yml` # and update the variables as comments instruct
    - Additionally, based on the environment (OCP4 or OCP3) you're provisioning, you will also need to configure an additional secret specific to the OCP version:
        - For OCP 3, you will copy the `secret.ocp3.yml.sample` to `secret.ocp3.yml` and update the file
        - For OCP 4, you will copy the `secret.ocp4.yml.sample` to `secret.ocp4.yml` and update the file

# Pre-provisioning Steps
```
# Clone 'agnosticd' repo, which 'mig-agnosticd' (this repo) will call into for provisioning 
git clone https://github.com/redhat-cop/agnosticd.git
cd agnosticd
export AGNOSTICD_HOME=`pwd`  # Consider exporting 'AGNOSTICD_HOME' in ~/.bashrc to the full repo path for future use.
cd .. 

# Clone 'mig-agnosticd' repo (this repo)
git clone https://github.com/konveyor/mig-agnosticd.git
cd mig-agnosticd
cp secret.yml.sample secret.yml
vim secret.yml # Update based on comments in file

# Fill out required vars for provisioning OpenShift 3.x 
cd 3.x
cp my_vars.yml.sample my_vars.yml
vim my_vars.yml # Update based on comments in file
cd ..

# Fill out required vars for provisioning OpenShift 4.x
cd 4.x
cp my_vars.yml.sample my_vars.yml
vim my_vars.yml # Update based on comments in file
cd ..
```

## Virtualenv (optional)
 * Installing Virtualenv
    ```
    python3 -m pip install --user virtualenv
    python3 -m venv env
    ```

 * Activate Virtualenv and install requirements
    ```
    source env/bin/activate
    pip3 install -r requirements.txt
    ```

 * To update any requirements
    ```
    pip3 freeze > requirements.txt
    ``` 


## Running AgnosticD to provision OpenShift 3 + 4 Clusters

Before provisioning, ensure you have populated all necessary vars in:
 - `./secret.yml`
 - `./3.x/my_vars.yml`
 - `./4.x/my_vars.yml` 

**To provision an OpenShift Cluster with AgnosticD:**
 - 3.x cluster, see [./3.x/README.md](https://github.com/konveyor/mig-agnosticd/blob/master/3.x/README.md). 
 - 4.x cluster, see [./4.x/README.md](https://github.com/konveyor/mig-agnosticd/blob/master/4.x/README.md).

