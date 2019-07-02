# OCP Migration Environments

This repository contains configuration files and scripts intended to deploy OCP 3.x and 4.x environments to aid in developing and testing Cluster Application Migration Tool.  All workflows are leveraging https://github.com/redhat-cop/agnosticd.

This repository is focused on providing the exact scripts/config files we are using so we may all work from a common configuration.  The intent is that all future contributions continue to be done upstream in https://github.com/redhat-cop/agnosticd and this repo serves as the specific bash and yaml files to kick off agnosticd in the exact manner we require.

Note we are only provisioning to AWS with the provided configurations.

# What is offered
## AWS OCP 3.x Environment (Intended to be our Source Cluster)
An OpenShift Ansible provisioned AWS multi-node environment leveraging CloudFormation for AWS infrastructure.

The https://github.com/fusor/mig-agnosticd/tree/master/3.x directory provides a means of deploying a '3.11' cluster.
Additionally we will install:
  - Velero (our Fork):              https://github.com/fusor/velero
  - Velero Plugins:

    - https://github.com/fusor/openshift-migration-plugin
    - https://github.com/fusor/openshift-velero-plugin
  - Restic (our Fork):              https://github.com/fusor/restic

## AWS OCP 4.x Environment (Intended to be our Destination Cluster)
An OpenShift Installer provisoned (IPI) AWS multi-node environment leveraging Terraform via the installer.

The https://github.com/fusor/mig-agnosticd/tree/master/4.x directory provides a means of deploying a '4.1' cluster.
Additionally we will install:
  - Velero (our Fork):              https://github.com/fusor/velero
  - Velero Plugins:

    - https://github.com/fusor/openshift-migration-plugin
    - https://github.com/fusor/openshift-velero-plugin
  - Restic (our Fork):              https://github.com/fusor/restic
  - Migration CRDs/Controllers:     https://github.com/fusor/mig-controller
  - Migration UI:                   https://github.com/fusor/mig-ui



# How are the environments provisioned
This repository is simply configuration files to drive https://github.com/redhat-cop/agnosticd, 'agnosticd' is a collection of Ansible configs/roles we are leveraging to deploy our OCP environments.  

The installation of the Velero and Migration bits are handled via roles in agnosticd which are leveraging the below operators:
  - https://github.com/fusor/velero-operator
  - https://github.com/fusor/mig-operator

At this point in time, the operators are _not_ integrated with OLM.  The intent is that agnosticd is installing our operators via regular Deployments and then creating the needed CR's to instruct Operators to install their applications.

# Pre-requisites

1. Follow the [Software Requirements on workstation](https://github.com/redhat-cop/agnosticd/blob/development/docs/Preparing_your_workstation.adoc#software-required-for-deployment) from agnosticd docs


    * https://github.com/redhat-cop/agnosticd/blob/development/docs/Preparing_your_workstation.adoc#software-required-for-deployment

1. AWS Access, you will need AWS access according to the needs of OCP 3.x and 4.x deployments.

    - Admin Access is currently required for OCP 4.x
    - Access to a HostedZone in Route53 is required, meaning you need a domain name managed by Route53 which can serve as the subdomain for your clusters
1. Checkout of https://github.com/redhat-cop/agnosticd 
1. Environment Variable set of 'AGNOSTICD_HOME' pointing to your agnosticd checkout
1. Creation of a 'secret.yml' in the base directory of this repo, see https://github.com/fusor/mig-agnosticd/blob/master/secret.yml.sample

    Intent is that you will do something like:

    - `cp secret.yml.sample secret.yml`
    - `vim secret.yml` # and update the variables as comments instruct

# Initial Setup Steps
        git clone https://github.com/redhat-cop/agnosticd.git
        cd agnosticd
        export AGNOSTICD_HOME=`pwd`  # Consider putting in ~/.bashrc to make easier in future
        cd .. 

        git clone https://github.com/fusor/mig-agnosticd.git
        cd mig-agnosticd
        cp secret.yml.sample secret.yml
        vim secret.yml # Update based on comments in file

        # Now setup for 3.x
        cd 3.x
        cp my_vars.sample.yml my_vars.yml
        vim my_vars.yml # Update based on comments in file
        cd ..

        # Now setup for 4.x
        cd 4.x
        cp my_vars.sample.yml my_vars.yml
        vim my_vars.yml # Update based on comments in file
        cd ..