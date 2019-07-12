## Deploying AgnosticD workloads

This is a collection of scripts that help you deploy workloads on AgnosticD OpenShift clusters.

These AgnosticD workloads assist in automated deployment of:
 - The OpenShift 3->4 Application Migration Tool 
 - Various sample apps for use when testing App Migration capabilities from OpenShift 3->4  

### NOTE

All workloads deployed by mig-agnosticd must be present in the main AgnosticD directory on your machine. However, the workloads we'll use in this README are yet not part of the redhat-cop/agnosticd repo (see PR 489). To use these workloads before PR 489 merges, clone the following repo and set `AGNOSTICD_HOME` to the clone path:

```bash
git clone https://github.com/pranavgaikwad/agnosticd
```

### Deploying a workload

To create a new workload:

```bash
./deploy_workload.sh -a create -w <workload_name> -v <ocp_version>
```

`workload_name` is the name of the workload to deploy. 

`ocp_version` is the version of the AgnosticD Openshift cluster to deploy the workload on (`3` or `4`).

To remove the workload:

```bash
./deploy_workload.sh -a remove -w <workload_name> -v <ocp_version> 
```

To print help: 

```bash
./deploy_workload.sh -h
```

#### Deploying migration workloads

We have two migration workloads -

* migration : Mig Operator workload to deploy UI, Controller and Velero
* mssql : A sample MsSQL server with a Node.js app


```bash
# Deploy Migration components to OpenShift 3 (velero)
./deploy_workload.sh -a create -w migration -v 3

# Deploy Migration components to OpenShift 4 (velero, mig-controller, mig-ui)
./deploy_workload.sh -a create -w migration -v 4

# Deploy mssql sample app to OpenShift 3
./deploy_workload.sh -a create -w mssql -v 3
```

### About Workload Configuration

Migration workloads have default variables set in `workload_vars/<workload_name>.yml`. 

You may change these variables for your use-case, but the defaults will allow for for Migration of apps from OpenShift 3->4 with the Migration Controller + UI located on OpenShift 4.
