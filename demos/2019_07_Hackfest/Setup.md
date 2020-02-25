# Setting up hackathon environment

Before working with the migration tool, we need to setup OCP environments and
install the migration workload on the clusters.

The overall steps this document will walk you through are:

 1. Provision OCP 3.11 multi-node environment in AWS via [mig-agnosticd](https://github.com/konveyor/mig-agnosticd/3.x/) to be used as the source cluster
 1. Provision OCP 4.1 multi-node environment in AWS via [mig-agnosticd](https://github.com/konveyor/mig-agnosticd/4.x/) to be used as the destination cluster
 1. Deploy [migration workloads](https://github.com/konveyor/mig-agnosticd/tree/master/workloads) onto both clusters
 1. Deploy [application workloads](https://github.com/konveyor/mig-agnosticd/tree/master/workloads) onto source cluster

## Setup

1. Clone `mig-agnosticd` repository:
```bash
$ git clone https://github.com/konveyor/mig-agnosticd
$ cd mig-agnosticd
```
1. Follow the [prerequisite guide](https://github.com/konveyor/mig-agnosticd#pre-provisioning-steps) to set up the `mig-agnosticd` configuration files.
    * When configuring `my_vars.yaml` for `3.x` and `4.x` clusters, it is helpful to select different unique values for `guid` to differentiate the clusters
    * For this document, we will use `<username>-ocp3` and `<username>-ocp4` respectfully. `dymurray` can be seen as the username.
    * For this document, we will use `mg.example.com` for the value of `subdomain_base_suffix` in `my_vars.yaml` to compare what the expected route outputs coordinate with.

### Source Cluster
1. Provision 3.11 environment
    * `$ cd 3.x/`
    * `$ ./create_ocp3_workshop.sh`
1. Log into the 3.11 environment (Assumes you didn't change `output_dir` var in `mig-agnosticd`)
```bash
$ export KUBECONFIG=~/.agnosticd/dymurray-ocp3/kubeconfig
$ oc login https://dymurray-ocp3.mg.example.com -u opentlc-mgr -p r3dh4t1!
The server uses a certificate signed by an unknown authority.
You can bypass the certificate check, but any data you send to the server could be intercepted by others.
Use insecure connections? (y/n): y
```

1. Install migration workload
    * `$ cd ../workloads/`
    * `$ ./deploy_workload.sh -a create -w migration -v 3`

1. Verify that the `migration-operator` deployment is running in `mig` namespace and healthy
```bash
$ oc get deployment migration-operator  -n mig
NAME                 DESIRED   CURRENT   UP-TO-DATE   AVAILABLE   AGE
migration-operator   1         1         1            1           5m
```

1. Verify that Velero is now running on the source in the `mig` namespace
```
$ oc get pods -n mig | grep velero 
velero-7559946c5c-mh5sp               1/1     Running   0          2m
```

1. Install sample application workload
  * Mediawiki
    * `$ git clone https://github.com/konveyor/mediawiki`
    * `$ cd mediawiki`
    * `$ ansible playbook setup.yml`
  * MSSQL
    * `$ ./deploy_workload.sh -a create -w mssql -v 3`
    
1. Verify that the MSSQL deployment was successful
```bash
$ oc get pods -n mssql-persistent
NAME                                    READY     STATUS    RESTARTS   AGE
mssql-app-deployment-6ffb46c5d6-mmcwb   1/1       Running   0          30m
mssql-deployment-2-zjkkf                1/1       Running   0          19m
```

1. Get service account token needed for destination cluster to talk to source
    * Run the commands:
```bash
$ oc sa get-token -n mig mig
eyJhbGciOifsfsds8ahmtpZCI6IiJ9fdsfdseyJpc3MiOiJrdWJlcm5ldGVzL3NlcnZpY2VhY2NvdW50Iiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9uYW1lc3BhY2UiOiJtaWciLCJrdWJlcm5ldGVzLmlvL3NlcnZpY2VhY2NvdW50L3NlY3JldC5uYW1lIjoibWlnLXRva2VuLTdxMnhjIiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9zZXJ2aWNlLWFjY291bnQubmFtZSI6Im1pZyIsImt1YmVybmss7gc2VydmljZWFjY291bnQvc2VydmljZS1hY2NvdW50LnVpZCI6IjQ5NjYyZjgxLWEzNDItMTFlOS05NGRjLTA2MDlkNjY4OTQyMCIsInN1YiI6InN5c3RlbTpzZXJ2aWNlYWNjb3VudDptaWc6bWlnIn0.Qhcv0cwP539nSxbhIHFNHen0PNXSfLgBiDMFqt6BvHZBLET_UK0FgwyDxnRYRnDAHdxAGHN3dHxVtwhu-idHKI-mKc7KnyNXDfWe5O0c1xWv63BbEvyXnTNvpJuW1ChUGCY04DBb6iuSVcUMi04Jy_sVez00FCQ56xMSFzy5nLW5QpLFiFOTj2k_4Krcjhs8dgf02dgfkkshshjfgfsdfdsfdsa8fdsgdsfd8fasfdaTScsu4lEDSbMY25rbpr-XqhGcGKwnU58qlmtJcBNT3uffKuxAdgbqa-4zt9cLFeyayTKmelc1MLswlOvu3vvJ2soFx9VzWdPbGRMsjZWWLvJ246oyzwykYlBunYJbX3D_uPfyqoKfzA

# We need to save the output of the 'get-token', that is the long string we will enter into the mig-ui when we create a new cluster entry.
```

### Destination Cluster
1. Provision 4.1 environment
    * `$ cd 4.x/`
    * `$ ./create_ocp4_workshop.sh`
    
1. Set KUBECONFIG to point to 4.1 environment (Assumes you didn't change `output_dir` var in `mig-agnosticd`)
```bash
$ export KUBECONFIG=~/.agnosticd/dymurray-ocp4-cluster/ocp4-workshop_dymurray-ocp4_kubeconfig
```

1. Install migration workload
    * `$ cd ../workloads/`
    * `$ ./deploy_workload.sh -a create -w migration -v 4`

1. Verify that you see the below pods now running in `mig` namespace, we are looking for pods of `controller-manager`, `velero`, and `migration-ui`
```bash
$ oc get pods -n mig
NAME                                 READY   STATUS      RESTARTS   AGE
migration-operator-437w4jd-88sf      1/1     Running     0          2m
controller-manager-79bf7cd7d-99sbr   1/1     Running     0          2m
migration-ui-6d84bb9879-w52qx        1/1     Running     0          2m
restic-6lhnp                         1/1     Running     0          2m
restic-c72gl                         1/1     Running     0          2m
restic-xf4z2                         1/1     Running     0          2m
velero-6bf58f4f88-6cpw8              1/1     Running     0          2m
```

1. Determine the route of `mig-ui`, we will use this later to enable a CORS header on the OCP 3.x side.
```bash
$ oc get routes migration -n mig -o jsonpath='{.spec.host}'
migration-mig.apps.cluster-dymurray-ocp4.dymurray-ocp4.mg.example.com
```

### (If migrating MSSQL) Create MSSQL Security Context Constraint

1. Run the following to recreate MSSQL's `scc` on the destination cluster:
```bash
$ oc create -f files/mssql-scc.yaml
```

### Enable CORS Headers on Source cluster

1. Run the following playbook to enable the proper CORS headers on the source cluster
```bash
$ cd ../cors/
$ ansible-playbook cors.yaml
```

## Prepare to use mig-ui from OCP 4.1 Cluster in your Browser
1. To visit the ui, look at the route on the OCP 4.1 Cluster
```bash
$ oc get routes migration -n mig -o jsonpath='{.spec.host}'
migration-mig.apps.cluster-dymurray-ocp4.dymurray-ocp4.mg.example.com
```

1. For this example we'd visit the below from our browser:
  * https://migration-mig.apps.cluster-dymurray-ocp4.dymurray-ocp4.mg.example.com

### Accept certificates on source and destination clusters

1. Before you can login you will need to accept the certificates with your
   browser on both the source and destination cluster. To do this:
  * Visit the link displayed by the webui for `.well-known/oauth-authorization-server`
    * OCP 4.1: https://api.cluster-dymurray-ocp4.dymurray-ocp4.mg.example.com:6443/.well-known/oauth-authorization-server
    * OCP 3.11 https://master.dymurray-ocp3.mg.dog8code.com/.well-known/oauth-authorization-server
  * Refresh the page
  * Get redirected to login page
1. Login with your credentials for the cluster.
  * You can find your credentials from the output directory of agnosticd
  * For example:
```
$ cat ~/.agnosticd/dymurray-ocp4/ocp4-workshop_dymurray-ocp4_kubeadmin-password 
de8uJb-UdwTd-P6REei-JJL3X
```
  * I would login as:
    * Username:    `kubeadmin`
    * Password:    `de8uJb-UdwTd-P6REei-JJL3X`
1. We also need to accept the certificates from the OCP 3.11 cluster
  * Visit the webui for OCP 3.11 console, for example: https://master.dymurray-ocp3.mg.example.com
  * Login with the credentials from agnosticd:
    * Username: `opentlc-mgr`
    * Password: `r3dh4t1!`


# Conclusion

You now have 2 OCP clusters provisioned as a source and destination cluster with all of the necessary components to run the application migration tool. Please continue on to [migrate the MSSQL application](./Migrate.md)
