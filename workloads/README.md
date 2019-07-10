## Deploying AgnosticD workloads

This is a collection of scripts that help you deploy workloads on AgnosticD Openshift clusters. It includes sample configuration files for migration workloads.

### Deploying a workload

To deploy a workload, you can use the `deploy_workload.sh` script.

#### Usage

To create a new workload, run following script 

```
./deploy_workload.sh -a create -w <workload_name> -v <ocp_version>
```

`workload_name` is the name of the workload to deploy. 

We have two migration workloads -

* migration : Mig Operator workload to deploy UI, Controller and Velero
* mssql : A sample MsSQL server with a Node.js app 

The workloads require a few variables defined. Please put those variables under `workload_vars/<workload_name>.yml` file. Sample workload configuration variables are included in the directory.

To remove the workload, run following script

```
./deploy_workload.sh -a remove -w <workload_name> -v <ocp_version> 
```

For more information about the script, run 

```
./deploy_workload.sh -h
```


