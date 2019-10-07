## Openshift 3.x Cross Origin Resource Sharing (CORS) Settings for Mig UI

This is a standalone script to apply Mig UI's [CORS](https://developer.mozilla.org/en-US/docs/Web/HTTP/CORS) settings on Openshift 3.x clusters.

Before running this script, please make sure that you deployed Mig UI on your 4.x cluster. It is assumed that you launched clusters with `mig-agnosticd`.

This script uses the same `my_vars.yml` file you used when launching a new cluster. Make sure those files are present for both the clusters.

```
../3.x/my_vars.yml
../4.x/my_vars.yml
```

### Usage

Run the script

```
ansible-playbook cors.yaml
```

There is no need to set any variables, the script reads `my_vars.yml` files and puts the right settings.

### Debugging CORS
One method for debugging CORS is to simulate requests to the server with curl and look at the returned header.
The below is an example of a script you can run to simulate a request with curl so you can see if the `access-control-allow-origin` header is accepting the mig-ui route. 

This script assumes you change the variables for `OCP3_SERVER` and `UI_ROUTE` before running

    # OCP 3 Cluster
    # Change this value to your OCP 3 url
    OCP3_SERVER=https://master.jwm0710ocp3a.mg.example.com.com

    # The route of mig-ui, most likely on OCP 4 cluster
    # Change this value to your mig-ui route
    UI_ROUTE=https://migration-mig.apps.cluster-jwm0710ocp4a.jwm0710ocp4a.mg.example.com.com
    
    # The namespace you have CAM installed to
    CAM_NAMESPACE=openshift-migration

    curl -v -k -X OPTIONS \
    "${OCP3_SERVER}/apis/migration.openshift.io/v1alpha1/namespaces/${CAM_NAMESPACE}/migclusters" \
    -H "Access-Control-Request-Method: GET" \
    -H "Access-Control-Request-Headers: authorization" \
    -H "Origin: ${UI_ROUTE}"

After running the above you want to see output similar to the below, you are looking for the path of the mig-ui route being in `access-control-allow-origin`

    < HTTP/2 204 
    < access-control-allow-credentials: true
    < access-control-allow-headers: Content-Type, Content-Length, Accept-Encoding, X-CSRF-Token, Authorization, X-Requested-With, If-Modified-Since
    < access-control-allow-methods: POST, GET, OPTIONS, PUT, DELETE, PATCH
    < access-control-allow-origin: https://migration-mig.apps.cluster-jwm0710ocp4a.jwm0710ocp4a.mg.example.com.com
    < access-control-expose-headers: Date
    < cache-control: no-store



 
