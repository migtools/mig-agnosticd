## Deploying AgnosticD workloads

This is a collection of scripts that help you deploy workloads on AgnosticD Openshift clusters. It includes sample configuration files for migration related workloads.

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

To remove the workload, run following script

```
./deploy_workload.sh -a remove -w <workload_name> -v <ocp_version> 
```

For example, to deploy migration workload on Openshift 3 cluster, run

```
./deploy_workload.sh -a create -w migration -v 3
```

For more information about the script, run 

```
./deploy_workload.sh -h
```

### About Workload Configuration

By default, all the workloads are launched with their default configurations. For migration scenarios, there is no need to change any configuration. 

However, the configuration file of a workload can be found at `workload_vars/<workload_name>.yml`. You may change the values of variables in this file if you do not want the default behaviour.


