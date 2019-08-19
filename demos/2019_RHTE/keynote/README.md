# RHTE Keynote

This is a guide to deploy OCP3 and OCP4 clusters on AWS for RHTE Keynote scenes.

# Before you proceed

We'd need :  
- access to an AWS account which has permissions to create AWS resources required by both the clusters.
- secret token to deploy OpenShift 4 cluster. It can be created here : 
- a private content repository.

## Requirements

You need following packages installed on your host machine from where you'll launch this deployment.

- Python 2.7.x (Python 3.x may not work)
- Ansible 2.7.6+ 
- Git
- awscli 
- python-boto3
- python2-boto

# Installation

## Clone AgnosticD

Clone AgnosticD repository to your preferred location :

```bash
git clone https://github.com/redhat-cop/agnosticd ~/
```

Set the environment variable `AGNOSTICD_HOME` to the location of the AgnosticD repo :

```bash
export AGNOSTICD_HOME=~/agnosticd/
```

## Prepare your secret file

### Secret Variables
 
Copy `secret.yml.sample` to `secret.yml` : 

```bash
cp secret.yml.sample secret.yml
```

Fill `secret.yml` with your secret values. Make sure all variables are filled.

### OCP Cluster Variables

Copy `3.x/my_vars.yml.sample` to `3.x/my_vars.yml` :

```bash
cp 3.x/my_vars.yml.sample 3.x/my_vars.yml
```

Copy `4.x/my_vars.yml.sample` to `4.x/my_vars.yml`:

```bash
cp 4.x/my_vars.yml.sample 4.x/my_vars.yml
```

Fill all `3.x/my_vars.yml` and `4.x/my_vars.yml` files with your values. Follow comments above each variable for more information.

## Launch the environments

Once the variable files are ready, to launch a new keynote environment : 

```bash
./create_rhte_env.sh
```

To destroy the keynote environment : 

```bash
./delete_rhte_env.sh
```
