# Notes for recreating demo shown on July 12 2019

Please note this is the first full end to end demo and as such still has some rough edges.
The rough edges will improve over next few weeks.

The overall steps are:

 1. Provision OCP 3.11 multi-node environment in AWS via [agnosticd](https://github.com/redhat-cop/agnosticd) (uses openshift-ansible on AWS)
 1. Install [https://github.com/konveyor/mig-operator](mig-operator) on OCP 3.11 cluster which will install/configure
    * [velero](https://github.com/heptio/velero)
 1. Deploy a workload to the OCP 3.11 cluster
    * This workload will serve as the application we want to migrate from source to destination clusters.  It will use Persistent Volumes so that this demo shows migration of state.
 1. Provision OCP 4.x multi-node environment in AWS via [agnosticd](https://github.com/redhat-cop/agnosticd) (uses openshift-install, IPI on AWS)
 1. Install [https://github.com/konveyor/mig-operator](mig-operator) on OCP 4.1 cluster which will install/configure
    * [velero](https://github.com/heptio/velero)
    * [mig-controller](https://github.com/konveyor/mig-controller) and associated CRDs (our Migration API)
    * [mig-ui](https://github.com/konveyor/mig-ui) (our Migration WebUI)
 1. Add an entry for corsAllowedOrigin headers to the OCP 3.11 cluster for the mig-ui running on OCP 4.x cluster. 
 1. Use mig-ui on OCP 4.1 cluster and perform a migration


# Steps
## Destination Cluster
1. Provision 4.1 environment
    * `https://github.com/konveyor/mig-agnosticd/blob/master/4.x/create_ocp4_workshop.sh`
1. Install mig-operator
    * `wget https://raw.githubusercontent.com/konveyor/mig-operator/master/operator.yml`
    * `oc apply -f operator.yml`

            $ oc apply -f operator.yml 
            namespace/mig created
            serviceaccount/migration-operator created
            customresourcedefinition.apiextensions.k8s.io/migrationcontrollers.migration.openshift.io created
            role.rbac.authorization.k8s.io/migration-operator created
            rolebinding.rbac.authorization.k8s.io/migration-operator created
            clusterrolebinding.rbac.authorization.k8s.io/migration-operator created
            deployment.apps/migration-operator created

1. Verify that the `migration-operator` deployment is running in `mig` namespace and healthy

            $ oc get deployment migration-operator  -n mig
            NAME                 DESIRED   CURRENT   UP-TO-DATE   AVAILABLE   AGE
            migration-operator   1         1         1            1           5m

1. Create a CR to trigger the Operator to deploy {velero, mig-ui, mig-controller}
    * `wget https://raw.githubusercontent.com/konveyor/mig-operator/master/controller.yml`
    * No changes are needed to `controller.yml`, it should look like

            $ cat controller.yml
            apiVersion: migration.openshift.io/v1alpha1
            kind: MigrationController
            metadata:
            name: migration-controller
            namespace: mig
            spec:
            cluster_name: host
            migration_velero: true
            migration_controller: true
            migration_ui: true
            #To install the controller on Openshift 3 you will need to configure the API endpoint:
            #mig_ui_cluster_api_endpoint: https://replace-with-openshift-cluster-hostname:8443/api 

    * `oc apply -f controller.yml`

            $ oc apply -f ./controller.yml 
            migrationcontroller.migration.openshift.io/migration-controller created


1. Verify that you see the below pods now running in `mig` namespace, we are looking for pods of `controller-manager`, `velero`, and `migration-ui`

            $ oc get pods -n mig
            NAME                                 READY   STATUS      RESTARTS   AGE
            migration-operator-437w4jd-88sf      1/1     Running     0          2m
            controller-manager-79bf7cd7d-99sbr   1/1     Running     0          2m
            migration-ui-6d84bb9879-w52qx        1/1     Running     0          2m
            restic-6lhnp                         1/1     Running     0          2m
            restic-c72gl                         1/1     Running     0          2m
            restic-xf4z2                         1/1     Running     0          2m
            velero-6bf58f4f88-6cpw8              1/1     Running     0          2m

1. Determine the route of `mig-ui`, we will use this later to enable a CORS header on the OCP 3.x side.

        $ oc get routes migration -n mig -o jsonpath='{.spec.host}'
        migration-mig.apps.cluster-jwm0710ocp4a.jwm0710ocp4a.mg.example.com



## Source Cluster
1. Provision 3.11 environment
    * `https://github.com/konveyor/mig-agnosticd/blob/master/3.x/create_ocp3_workshop.sh`
1. Log into the 3.11 environment

            export KUBECONFIG=~/.agnosticd/jwm0710ocp3a/kubeconfig
            $ oc login https://master.jwm0710ocp3a.mg.example.com -u opentlc-mgr -p r3dh4t1!
            The server uses a certificate signed by an unknown authority.
            You can bypass the certificate check, but any data you send to the server could be intercepted by others.
            Use insecure connections? (y/n): y

1. Install mig-operator
    * `wget https://raw.githubusercontent.com/konveyor/mig-operator/master/operator.yml`
    * `oc apply -f operator.yml`

            $ oc apply -f operator.yml 
            namespace/mig created
            serviceaccount/migration-operator created
            customresourcedefinition.apiextensions.k8s.io/migrationcontrollers.migration.openshift.io created
            role.rbac.authorization.k8s.io/migration-operator created
            rolebinding.rbac.authorization.k8s.io/migration-operator created
            clusterrolebinding.rbac.authorization.k8s.io/migration-operator created
            deployment.apps/migration-operator created

1. Verify that the `migration-operator` deployment is running in `mig` namespace and healthy

            $ oc get deployment migration-operator  -n mig
            NAME                 DESIRED   CURRENT   UP-TO-DATE   AVAILABLE   AGE
            migration-operator   1         1         1            1           5m
1. Create a CR to trigger the Operator to deploy just Velero
    * `wget https://raw.githubusercontent.com/konveyor/mig-operator/master/controller.yml`
    * edit controller.yaml and set `migratation_controller: false` and `migration_ui: false`

            $ cat controller.yml 
            apiVersion: migration.openshift.io/v1alpha1
            kind: MigrationController
            metadata:
            name: migration-controller
            namespace: mig
            spec:
            cluster_name: host
            migration_velero: true
            migration_controller: false
            migration_ui: false
    * `oc apply -f controller.yml`

            $ oc apply -f ./controller.yml 
            migrationcontroller.migration.openshift.io/migration-controller created

    * Verify that Velero is now running on the source in the `mig` namespace

            $ oc get pods -n mig | grep velero 
            velero-7559946c5c-mh5sp               1/1     Running   0          2m

1. Add a corsAllowedOrigin header to specify the mig-ui running on OCP 4.1 is allowed to talk to this OCP 3.11 cluster.

            $ ssh -F ~/.agnosticd/jwm0710ocp3a/ocp-workshop_jwm0710ocp3a_ssh_conf master1
            Last login: Wed Jul 10 12:15:25 2019 from ip-192-168-0-47.us-west-2.compute.internal
            [ec2-user@master1 ~]$ 

            Edit: sudo vim /etc/origin/master/master-config.yaml

            Look for

                corsAllowedOrigins:
                - (?i)//127\.0\.0\.1(:|\z)
                - (?i)//localhost(:|\z)
                - (?i)//192\.168\.0\.99(:|\z)
                - (?i)//kubernetes\.default(:|\z)
                - (?i)//kubernetes(:|\z)
                - (?i)//openshift\.default(:|\z)
                - (?i)//openshift\.default\.svc(:|\z)
                - (?i)//kubernetes\.default\.svc(:|\z)
                - (?i)//172\.30\.0\.1(:|\z)
                - (?i)//openshift\.default\.svc\.cluster\.local(:|\z)
                - (?i)//master1\.jwm0710ocp3a\.internal(:|\z)
                - (?i)//master\.jwm0710ocp3a\.mg\.example\.com(:|\z)
                - (?i)//kubernetes\.default\.svc\.cluster\.local(:|\z)
                - (?i)//openshift(:|\z)
                dnsConfig:
                bindAddress: 0.0.0.0:8053
                bindNetwork: tcp4


             We Want to insert a new entry for
                - (?i)//migration-mig\.apps\.cluster-jwm0710ocp4a\.jwm0710ocp4a\.mg\.example\.com(:|\z)

                corsAllowedOrigins:
                - (?i)//127\.0\.0\.1(:|\z)
                - (?i)//localhost(:|\z)
                - (?i)//192\.168\.0\.99(:|\z)
                - (?i)//kubernetes\.default(:|\z)
                - (?i)//kubernetes(:|\z)
                - (?i)//openshift\.default(:|\z)
                - (?i)//openshift\.default\.svc(:|\z)
                - (?i)//kubernetes\.default\.svc(:|\z)
                - (?i)//172\.30\.0\.1(:|\z)
                - (?i)//openshift\.default\.svc\.cluster\.local(:|\z)
                - (?i)//master1\.jwm0710ocp3a\.internal(:|\z)
                - (?i)//master\.jwm0710ocp3a\.mg\.example\.com(:|\z)
                - (?i)//kubernetes\.default\.svc\.cluster\.local(:|\z)
                - (?i)//openshift(:|\z)
                - (?i)//migration-mig\.apps\.cluster-jwm0710ocp4a\.jwm0706ocp4a\.mg\.example\.com(:|\z)
                dnsConfig:
                bindAddress: 0.0.0.0:8053
                bindNetwork: tcp4
            
        Now restart the api server
            [ec2-user@master1 ~]$ sudo /usr/local/bin/master-restart api
            2
 1. Create a Service Account to use for Migrations
  * Run the commands

        $ oc create sa -n mig mig
        serviceaccount/mig created

        $ oc adm policy add-cluster-role-to-user cluster-admin system:serviceaccount:mig:mig
        clusterrole.rbac.authorization.k8s.io/cluster-admin added: "system:serviceaccount:mig:mig"
        cBook-Pro-2018:~/RedHat/OCP/testData/3.x

        $ oc sa get-token -n mig mig
        eyJhbGciOifsfsds8ahmtpZCI6IiJ9fdsfdseyJpc3MiOiJrdWJlcm5ldGVzL3NlcnZpY2VhY2NvdW50Iiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9uYW1lc3BhY2UiOiJtaWciLCJrdWJlcm5ldGVzLmlvL3NlcnZpY2VhY2NvdW50L3NlY3JldC5uYW1lIjoibWlnLXRva2VuLTdxMnhjIiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9zZXJ2aWNlLWFjY291bnQubmFtZSI6Im1pZyIsImt1YmVybmss7gc2VydmljZWFjY291bnQvc2VydmljZS1hY2NvdW50LnVpZCI6IjQ5NjYyZjgxLWEzNDItMTFlOS05NGRjLTA2MDlkNjY4OTQyMCIsInN1YiI6InN5c3RlbTpzZXJ2aWNlYWNjb3VudDptaWc6bWlnIn0.Qhcv0cwP539nSxbhIHFNHen0PNXSfLgBiDMFqt6BvHZBLET_UK0FgwyDxnRYRnDAHdxAGHN3dHxVtwhu-idHKI-mKc7KnyNXDfWe5O0c1xWv63BbEvyXnTNvpJuW1ChUGCY04DBb6iuSVcUMi04Jy_sVez00FCQ56xMSFzy5nLW5QpLFiFOTj2k_4Krcjhs8dgf02dgfkkshshjfgfsdfdsfdsa8fdsgdsfd8fasfdaTScsu4lEDSbMY25rbpr-XqhGcGKwnU58qlmtJcBNT3uffKuxAdgbqa-4zt9cLFeyayTKmelc1MLswlOvu3vvJ2soFx9VzWdPbGRMsjZWWLvJ246oyzwykYlBunYJbX3D_uPfyqoKfzA

        # We need to save the output of the 'get-token', that is the long string we will enter into the mig-ui when we create a new cluster entry.




# Prepare to use mig-ui from OCP 4.1 Cluster in your Browser
1. Visit the ui, look at the route on the OCP 4.1 Cluster

        $ oc get routes migration -n mig -o jsonpath='{.spec.host}'
        migration-mig.apps.cluster-jwm0710ocp4a.jwm0710ocp4a.mg.example.com

1. For example we'd visit the below from our browser:
    * https://migration-mig.apps.cluster-jwm0710ocp4a.jwm0710ocp4a.mg.example.com

1. Accept certifications, before you can login you will need to accept the certificates with your browser
    * Visit the link displayed by the webui for `.well-known/oauth-authorization-server`
        * For example on my setup the link is: https://api.cluster-jwm0710ocp4a.jwm0710ocp4a.mg.example.com:6443/.well-known/oauth-authorization-server
    * Refresh the page
    * Get redirected to Login
1. Login with your credentials for the cluster.
            You can find your credentials from the output directory of agnosticd
            For example
            
            $ cat ~/.agnosticd/jwm0710ocp4a/ocp4-workshop_jwm0710ocp4a_kubeadmin-password 
            de8uJb-UdwTd-P6REei-JJL3X
    * I would login as:
        * Username:    `kubeadmin`
        * Password:    `de8uJb-UdwTd-P6REei-JJL3X`
1. Caveats once logged in
    * Note that we hardcoded a username for now in upper right hand side, it will say `jmatthews`
1. We also need to accept the certificates from the OCP 3.11 cluster
    * Visit the webui for OCP 3.11 console, for example: https://master.jwm0710ocp3a.mg.example.com
    * Login with the credentials from agnosticd:
        * Username: `opentlc-mgr`
        * Password: `r3dh4t1!`

# Deploy a sample application to your source cluster
 * Example of an nginx example that is often used with velero
   * https://gist.githubusercontent.com/jwmatthews/b0432300864c5bf71736c8647fec72bb/raw/7c5723bcb06c8a11591b2ccb313322c8f3261623/nginx_with_pv.yml

            wget https://gist.githubusercontent.com/jwmatthews/b0432300864c5bf71736c8647fec72bb/raw/7c5723bcb06c8a11591b2ccb313322c8f3261623/nginx_with_pv.yml
            oc apply -f nginx_with_pv.yml
    
            $ oc get all -n nginx-example
            NAME                                    READY   STATUS    RESTARTS   AGE
            pod/nginx-deployment-6c7958f7b7-sn9vz   1/1     Running   0          1m

            NAME               TYPE           CLUSTER-IP       EXTERNAL-IP                   PORT(S)          AGE
            service/my-nginx   LoadBalancer   172.30.237.229   172.29.221.20,172.29.221.20   8081:31082/TCP   21h

            NAME                               DESIRED   CURRENT   UP-TO-DATE   AVAILABLE   AGE
            deployment.apps/nginx-deployment   1         1         1            1           21h

            NAME                                          DESIRED   CURRENT   READY   AGE
            replicaset.apps/nginx-deployment-6c7958f7b7   1         1         1       21h

            NAME                                HOST/PORT                                                  PATH   SERVICES   PORT   TERMINATION   WILDCARD
            route.route.openshift.io/my-nginx   my-nginx-nginx-example.apps.jwm0710ocp3a.mg.example.com          my-nginx   8081                 None

# Use mig-ui to create a Migration Plan and perform a Stage and Migrate
## Add the Source Cluster in mig-ui
$ oc sa get-token -n mig mig

## Create a Storage entry in mig-ui
1. Create a new AWS IAM user and grant S3 Full Access
1. Create a s3 bucket and use the credentials you created for the IAM account that only has s3 access
 * Note, if you use your own account credentials and use MFA you may see a problem, we are still investigating.
 * Recommended to create a new IAM account with just S3 Full Access and use that in this step.
   
## Create a MigPlan
1. Follow wizard to create a Migration Plan
1. After the Plan is created you may need to refresh the page to see the Stage and Migrate buttons turn 'Blue'.
 * 'Grey' means the plan is not yet ready
## Execute Stage + Migrate
1. Click on Stage or Migrate based on what you want to do.
### Reset the Migration so you can re-run
 1. Delete the namespace of the sample app on the destination cluster
 1. On the source cluster, scale the deployment back up

        $ oc scale deployment nginx-deployment -n nginx-example --replicas=1
        deployment.extensions/nginx-deployment scaled




# Debug
## How to see what the operator is doing
 * mig-operator is based on Ansible Operator, you can view the logs by

        $ oc logs migration-operator-bfbc7f445-nk4gz -n mig -c ansible







