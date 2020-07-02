## Deploying AgnosticD workloads

This is a collection of scripts that help you deploy workloads on AgnosticD OpenShift clusters.

These AgnosticD workloads assist in automated deployment of:
 - The OpenShift 3->4 Application Migration Tool 
 - Various sample apps for use when testing App Migration capabilities from OpenShift 3->4  

The workloads are available in AgnosticD repo. Make sure you have cloned the repo and set AGNOSTICD_HOME environment variable to the location of the repo.

```bash
git clone https://github.com/redhat-cop/agnosticd
```

### Deploying a workload

#### Usage: `./deploy_workload.sh `
|Flag|Purpose|Accepted Values|
|---|---|---|
|`-a`|Workload Action|[`create`, `delete`]|
|`-w`|Workload Name|[`migration`, `mssql`, ...]|
|`-v`|AgnosticD OpenShift Version|[`3`, `4`]|

To create a new workload:

```bash
./deploy_workload.sh -a create -w <workload_name> -v <ocp_version>
```

`workload_name` is the name of the workload to deploy. 

`ocp_version` is the version of the AgnosticD OpenShift cluster to deploy the workload on (`3` or `4`).

To remove the workload:

```bash
./deploy_workload.sh -a remove -w <workload_name> -v <ocp_version> 
```

To print help: 

```bash
./deploy_workload.sh -h
```

#### Deploying migration workloads

Available migration workloads -

* migration : Mig Operator workload to deploy UI, Controller and Velero
* mssql : MsSQL server with a sample frontend app
* minio : Minio server to provide S3 API endpoint
* noobaa : NooBaa operator workload on OCP 4
* ocs-poc : OpenShift Container Storage for OpenShift 4.x
* parks-app : Demo application 
* sock-shop : Demo application
* robot-shop : Demo application 

```bash
# Deploy Migration components to OpenShift 3 (velero)
./deploy_workload.sh -a create -w migration -v 3

# Deploy Migration components to OpenShift 4 (velero, mig-controller, mig-ui)
./deploy_workload.sh -a create -w migration -v 4

# Deploy mssql sample app to OpenShift 3
./deploy_workload.sh -a create -w mssql -v 3

# Deploy ceph cluster to OpenShift 4
./deploy_workload.sh -a create -w ceph -v 4

# Deploy minio to OpenShift 4
./deploy_workload.sh -a create -w minio -v 4
# Access key: minio; Secret key: minio123
```

### About Workload Configuration

Migration workloads have default variables set in `workload_vars/<workload_name>.yml`. 

You may change these variables for your use-case, but the defaults will allow for for Migration of apps from OpenShift 3->4 with the Migration Controller + UI located on OpenShift 4.
