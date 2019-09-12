## Noobaa - Object Storage Setup

CAM components use S3 object storage as temporary scratch space when performing migrations.  This storage can be any object storage that presents an `S3 like` interface.  Currently, we have tested AWS S3, Noobaa, and Minio.  These instructions outline installation, setup and creation of a noobaa replication repository.

### Installation

NooBaa can run on an OpenShift cluster to provide an S3 compatible store for migration scratch space. We recommend loading NooBaa onto the destination cluster.  We've created a simple installation script that you can download and use.  Just perform the following steps:

1. SSH into the 4.1 client-vm `SSH lab-user@bastion.<guid>.<domain>` with password: `r3dh4t1!`.

2. wget 
https://gist.githubusercontent.com/jwmatthews/ac1c174bfafcee3d935a67646231e60d/raw/5682de307c657b3a73ab3af84adf753b22365dac/setup_noobaa.sh

```
$ wget 
https://gist.githubusercontent.com/jwmatthews/ac1c174bfafcee3d935a67646231e60d/raw/5682de307c657b3a73ab3af84adf753b22365dac/setup_noobaa.sh
--2019-09-11 01:05:01--  
https://gist.githubusercontent.com/jwmatthews/ac1c174bfafcee3d935a67646231e60d/raw/5682de307c657b3a73ab3af84adf753b22365dac/setup_noobaa.sh
Resolving gist.githubusercontent.com (gist.githubusercontent.com)... 151.101.8.133
Connecting to gist.githubusercontent.com (gist.githubusercontent.com)|151.101.8.133|:443... connected.
HTTP request sent, awaiting response... 200 OK
Length: 359 [text/plain]
Saving to: ‘setup_noobaa.sh’

100%[====================================================================================================================================================================================================>] 359         --.-K/s   in 0s      

2019-09-11 01:05:02 (64.1 MB/s) - ‘setup_noobaa.sh’ saved [359/359]
```


3. Add execution permissions to script.

```
$ chmod +x setup_noobaa.sh`
```

4. ./setup_noobaa.sh

```
$ ./setup_noobaa.sh
--2019-09-11 01:06:20--  https://github.com/noobaa/noobaa-operator/releases/download/v1.1.1/noobaa-linux-v1.1.1
Resolving github.com (github.com)... 52.74.223.119
Connecting to github.com (github.com)|52.74.223.119|:443... connected.
HTTP request sent, awaiting response... 302 Found
Location: https://github-production-release-asset-2e65be.s3.amazonaws.com/194805859/7d933080-d3cf-11e9-9870-dc26ae740f88?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAIWNJYAX4CSVEH53A%2F20190911%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Date=20190911T010620Z&X-Amz-Expires=300&X-Amz-Signature=c2cfc42624327688bce97db727de0d8c27689cca7ad8f39e1501c71437efdef0&X-Amz-SignedHeaders=host&actor_id=0&response-content-disposition=attachment%3B%20filename%3Dnoobaa-linux-v1.1.1&response-content-type=application%2Foctet-stream [following]
--2019-09-11 01:06:20--  https://github-production-release-asset-2e65be.s3.amazonaws.com/194805859/7d933080-d3cf-11e9-9870-dc26ae740f88?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAIWNJYAX4CSVEH53A%2F20190911%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Date=20190911T010620Z&X-Amz-Expires=300&X-Amz-Signature=c2cfc42624327688bce97db727de0d8c27689cca7ad8f39e1501c71437efdef0&X-Amz-SignedHeaders=host&actor_id=0&response-content-disposition=attachment%3B%20filename%3Dnoobaa-linux-v1.1.1&response-content-type=application%2Foctet-stream
Resolving github-production-release-asset-2e65be.s3.amazonaws.com (github-production-release-asset-2e65be.s3.amazonaws.com)... 52.216.170.187
Connecting to github-production-release-asset-2e65be.s3.amazonaws.com (github-production-release-asset-2e65be.s3.amazonaws.com)|52.216.170.187|:443... connected.
HTTP request sent, awaiting response... 200 OK
Length: 49924963 (48M) [application/octet-stream]
Saving to: ‘noobaa-linux-v1.1.1’

100%[====================================================================================================================================================================================================>] 49,924,963  6.67MB/s   in 8.5s   

2019-09-11 01:06:29 (5.58 MB/s) - ‘noobaa-linux-v1.1.1’ saved [49924963/49924963]

INFO[0000] CLI version: 1.1.1                           
INFO[0000] noobaa-image: noobaa/noobaa-core:5           
INFO[0000] operator-image: noobaa/noobaa-operator:1.1.1
INFO[0000] Namespace: noobaa                            
INFO[0000]                                              
INFO[0000] CRD Create:                                  
INFO[0000] ✅ Created: CustomResourceDefinition "noobaas.noobaa.io"
INFO[0000] ✅ Created: CustomResourceDefinition "backingstores.noobaa.io"
INFO[0000] ✅ Created: CustomResourceDefinition "bucketclasses.noobaa.io"
INFO[0000] ✅ Created: CustomResourceDefinition "objectbuckets.objectbucket.io"
INFO[0000] ✅ Created: CustomResourceDefinition "objectbucketclaims.objectbucket.io"
INFO[0000]                                              
INFO[0000] Operator Install:                            
INFO[0000] ✅ Created: Namespace "noobaa"                
INFO[0000] ✅ Created: ServiceAccount "noobaa-operator"  
INFO[0000] ✅ Created: Role "noobaa-operator"            
INFO[0000] ✅ Created: RoleBinding "noobaa-operator"     
INFO[0000] ✅ Created: ClusterRole "noobaa-operator"     
INFO[0000] ✅ Created: ClusterRoleBinding "noobaa-operator-noobaa"
INFO[0000] ✅ Created: StorageClass "noobaa-storage-class"
INFO[0000] ✅ Created: Deployment "noobaa-operator"      
INFO[0000]                                              
INFO[0000] System Create:                               
INFO[0000] ✅ Already Exists: Namespace "noobaa"         
INFO[0000] ✅ Created: NooBaa "noobaa"                   
INFO[0000]                                              
INFO[0000] System Wait:                                 
INFO[0000] ⏳ System Phase is "". Pod "noobaa-operator-599bf96b86-6rhwd" is not yet ready: Phase="Pending". ContainersNotReady (containers with unready status: [noobaa-operator]). ContainersNotReady (containers with unready status: [noobaa-operator]).  
INFO[0003] ⏳ System Phase is "". Pod "noobaa-operator-599bf96b86-6rhwd" is not yet ready: Phase="Pending". ContainersNotReady (containers with unready status: [noobaa-operator]). ContainersNotReady (containers with unready status: [noobaa-operator]).  
INFO[0006] ⏳ System Phase is "". Pod "noobaa-operator-599bf96b86-6rhwd" is not yet ready: Phase="Pending". ContainersNotReady (containers with unready status: [noobaa-operator]). ContainersNotReady (containers with unready status: [noobaa-operator]).  
INFO[0009] ⏳ System Phase is "". Pod "noobaa-operator-599bf96b86-6rhwd" is not yet ready: Phase="Pending". ContainersNotReady (containers with unready status: [noobaa-operator]). ContainersNotReady (containers with unready status: [noobaa-operator]).  
INFO[0012] ⏳ System Phase is "". Pod "noobaa-operator-599bf96b86-6rhwd" is not yet ready: Phase="Pending". ContainersNotReady (containers with unready status: [noobaa-operator]). ContainersNotReady (containers with unready status: [noobaa-operator]).  
INFO[0015] ⏳ System Phase is "". Pod "noobaa-operator-599bf96b86-6rhwd" is not yet ready: Phase="Pending". ContainersNotReady (containers with unready status: [noobaa-operator]). ContainersNotReady (containers with unready status: [noobaa-operator]).  
INFO[0018] ⏳ System Phase is "". Pod "noobaa-operator-599bf96b86-6rhwd" is not yet ready: Phase="Pending". ContainersNotReady (containers with unready status: [noobaa-operator]). ContainersNotReady (containers with unready status: [noobaa-operator]).  
INFO[0021] ⏳ System Phase is "". Pod "noobaa-operator-599bf96b86-6rhwd" is not yet ready: Phase="Pending". ContainersNotReady (containers with unready status: [noobaa-operator]). ContainersNotReady (containers with unready status: [noobaa-operator]).  
INFO[0024] ⏳ System Phase is "". Pod "noobaa-operator-599bf96b86-6rhwd" is not yet ready: Phase="Pending". ContainersNotReady (containers with unready status: [noobaa-operator]). ContainersNotReady (containers with unready status: [noobaa-operator]).  
INFO[0027] ⏳ System Phase is "". StatefulSet "noobaa-core" is not found yet
INFO[0030] ⏳ System Phase is "Connecting". Pod "noobaa-core-0" is not yet ready: Phase="Pending". ContainersNotInitialized (containers with incomplete status: [init-mongo]). ContainersNotReady (containers with unready status: [mongodb noobaa-server]). ContainersNotReady (containers with unready status: [mongodb noobaa-server]).  
INFO[0033] ⏳ System Phase is "Connecting". Pod "noobaa-core-0" is not yet ready: Phase="Pending". ContainersNotInitialized (containers with incomplete status: [init-mongo]). ContainersNotReady (containers with unready status: [mongodb noobaa-server]). ContainersNotReady (containers with unready status: [mongodb noobaa-server]).  
INFO[0036] ⏳ System Phase is "Connecting". Pod "noobaa-core-0" is not yet ready: Phase="Pending". ContainersNotInitialized (containers with incomplete status: [init-mongo]). ContainersNotReady (containers with unready status: [mongodb noobaa-server]). ContainersNotReady (containers with unready status: [mongodb noobaa-server]).  
INFO[0039] ⏳ System Phase is "Connecting". Pod "noobaa-core-0" is not yet ready: Phase="Pending". ContainersNotInitialized (containers with incomplete status: [init-mongo]). ContainersNotReady (containers with unready status: [mongodb noobaa-server]). ContainersNotReady (containers with unready status: [mongodb noobaa-server]).  
INFO[0042] ⏳ System Phase is "Connecting". Pod "noobaa-core-0" is not yet ready: Phase="Pending". ContainersNotInitialized (containers with incomplete status: [init-mongo]). ContainersNotReady (containers with unready status: [mongodb noobaa-server]). ContainersNotReady (containers with unready status: [mongodb noobaa-server]).  
INFO[0045] ⏳ System Phase is "Connecting". Pod "noobaa-core-0" is not yet ready: Phase="Pending". ContainersNotInitialized (containers with incomplete status: [init-mongo]). ContainersNotReady (containers with unready status: [mongodb noobaa-server]). ContainersNotReady (containers with unready status: [mongodb noobaa-server]).  
INFO[0048] ⏳ System Phase is "Connecting". Pod "noobaa-core-0" is not yet ready: Phase="Pending". ContainersNotInitialized (containers with incomplete status: [init-mongo]). ContainersNotReady (containers with unready status: [mongodb noobaa-server]). ContainersNotReady (containers with unready status: [mongodb noobaa-server]).  
INFO[0051] ⏳ System Phase is "Connecting". Pod "noobaa-core-0" is not yet ready: Phase="Pending". ContainersNotInitialized (containers with incomplete status: [init-mongo]). ContainersNotReady (containers with unready status: [mongodb noobaa-server]). ContainersNotReady (containers with unready status: [mongodb noobaa-server]).  
INFO[0054] ⏳ System Phase is "Connecting". Pod "noobaa-core-0" is not yet ready: Phase="Pending". ContainersNotInitialized (containers with incomplete status: [init-mongo]). ContainersNotReady (containers with unready status: [mongodb noobaa-server]). ContainersNotReady (containers with unready status: [mongodb noobaa-server]).  
INFO[0057] ⏳ System Phase is "Connecting". Pod "noobaa-core-0" is not yet ready: Phase="Pending". ContainersNotInitialized (containers with incomplete status: [init-mongo]). ContainersNotReady (containers with unready status: [mongodb noobaa-server]). ContainersNotReady (containers with unready status: [mongodb noobaa-server]).  
INFO[0060] ⏳ System Phase is "Connecting". Pod "noobaa-core-0" is not yet ready: Phase="Pending". ContainersNotInitialized (containers with incomplete status: [init-mongo]). ContainersNotReady (containers with unready status: [mongodb noobaa-server]). ContainersNotReady (containers with unready status: [mongodb noobaa-server]).  
INFO[0063] ⏳ System Phase is "Connecting". Pod "noobaa-core-0" is not yet ready: Phase="Pending". ContainersNotInitialized (containers with incomplete status: [init-mongo]). ContainersNotReady (containers with unready status: [mongodb noobaa-server]). ContainersNotReady (containers with unready status: [mongodb noobaa-server]).  
INFO[0066] ⏳ System Phase is "Connecting". Pod "noobaa-core-0" is not yet ready: Phase="Pending". ContainersNotInitialized (containers with incomplete status: [init-mongo]). ContainersNotReady (containers with unready status: [mongodb noobaa-server]). ContainersNotReady (containers with unready status: [mongodb noobaa-server]).  
INFO[0069] ⏳ System Phase is "Connecting". Pod "noobaa-core-0" is not yet ready: Phase="Pending". ContainersNotInitialized (containers with incomplete status: [init-mongo]). ContainersNotReady (containers with unready status: [mongodb noobaa-server]). ContainersNotReady (containers with unready status: [mongodb noobaa-server]).  
INFO[0072] ⏳ System Phase is "Connecting". Pod "noobaa-core-0" is not yet ready: Phase="Pending". ContainersNotInitialized (containers with incomplete status: [init-mongo]). ContainersNotReady (containers with unready status: [mongodb noobaa-server]). ContainersNotReady (containers with unready status: [mongodb noobaa-server]).  
INFO[0075] ⏳ System Phase is "Connecting". Pod "noobaa-core-0" is not yet ready: Phase="Pending". ContainersNotInitialized (containers with incomplete status: [init-mongo]). ContainersNotReady (containers with unready status: [mongodb noobaa-server]). ContainersNotReady (containers with unready status: [mongodb noobaa-server]).  
INFO[0078] ⏳ System Phase is "Connecting". Pod "noobaa-core-0" is not yet ready: Phase="Pending". ContainersNotInitialized (containers with incomplete status: [init-mongo]). ContainersNotReady (containers with unready status: [mongodb noobaa-server]). ContainersNotReady (containers with unready status: [mongodb noobaa-server]).  
INFO[0081] ⏳ System Phase is "Connecting". Pod "noobaa-core-0" is not yet ready: Phase="Pending". ContainersNotInitialized (containers with incomplete status: [init-mongo]). ContainersNotReady (containers with unready status: [mongodb noobaa-server]). ContainersNotReady (containers with unready status: [mongodb noobaa-server]).  
INFO[0084] ⏳ System Phase is "Connecting". Pod "noobaa-core-0" is not yet ready: Phase="Pending". ContainersNotReady (containers with unready status: [mongodb noobaa-server]). ContainersNotReady (containers with unready status: [mongodb noobaa-server]).  
INFO[0087] ⏳ System Phase is "Connecting". Pod "noobaa-core-0" is not yet ready: Phase="Pending". ContainersNotReady (containers with unready status: [mongodb noobaa-server]). ContainersNotReady (containers with unready status: [mongodb noobaa-server]).  
INFO[0090] ⏳ System Phase is "Connecting". Pod "noobaa-core-0" is not yet ready: Phase="Pending". ContainersNotReady (containers with unready status: [mongodb noobaa-server]). ContainersNotReady (containers with unready status: [mongodb noobaa-server]).  
INFO[0093] ⏳ System Phase is "Connecting". Pod "noobaa-core-0" is not yet ready: Phase="Pending". ContainersNotReady (containers with unready status: [mongodb noobaa-server]). ContainersNotReady (containers with unready status: [mongodb noobaa-server]).  
INFO[0096] ⏳ System Phase is "Connecting". Pod "noobaa-core-0" is not yet ready: Phase="Pending". ContainersNotReady (containers with unready status: [mongodb noobaa-server]). ContainersNotReady (containers with unready status: [mongodb noobaa-server]).  
INFO[0099] ⏳ System Phase is "Connecting". Pod "noobaa-core-0" is not yet ready: Phase="Pending". ContainersNotReady (containers with unready status: [mongodb noobaa-server]). ContainersNotReady (containers with unready status: [mongodb noobaa-server]).  
INFO[0102] ⏳ System Phase is "Connecting". Pod "noobaa-core-0" is not yet ready: Phase="Pending". ContainersNotReady (containers with unready status: [mongodb noobaa-server]). ContainersNotReady (containers with unready status: [mongodb noobaa-server]).  
INFO[0105] ⏳ System Phase is "Connecting". Pod "noobaa-core-0" is not yet ready: Phase="Pending". ContainersNotReady (containers with unready status: [mongodb noobaa-server]). ContainersNotReady (containers with unready status: [mongodb noobaa-server]).  
INFO[0108] ⏳ System Phase is "Connecting". Pod "noobaa-core-0" is not yet ready: Phase="Pending". ContainersNotReady (containers with unready status: [mongodb noobaa-server]). ContainersNotReady (containers with unready status: [mongodb noobaa-server]).  
INFO[0111] ⏳ System Phase is "Connecting". Pod "noobaa-core-0" is not yet ready: Phase="Pending". ContainersNotReady (containers with unready status: [mongodb noobaa-server]). ContainersNotReady (containers with unready status: [mongodb noobaa-server]).  
INFO[0114] ⏳ System Phase is "Connecting". Container "noobaa-server" is not yet ready: starting...
INFO[0117] ⏳ System Phase is "Connecting". Container "noobaa-server" is not yet ready: starting...
INFO[0120] ⏳ System Phase is "Connecting". Container "noobaa-server" is not yet ready: starting...
INFO[0123] ⏳ System Phase is "Connecting". Container "noobaa-server" is not yet ready: starting...
INFO[0126] ⏳ System Phase is "Connecting". Container "noobaa-server" is not yet ready: starting...
INFO[0129] ⏳ System Phase is "Connecting". Waiting for phase ready ...
INFO[0132] ✅ System Phase is "Ready".                   
INFO[0132] CLI version: 1.1.1                           
INFO[0132] noobaa-image: noobaa/noobaa-core:5           
INFO[0132] operator-image: noobaa/noobaa-operator:1.1.1
INFO[0132] Namespace: noobaa                            
INFO[0132]                                              
INFO[0132] CRD Status:                                  
INFO[0132] ✅ Exists: CustomResourceDefinition "noobaas.noobaa.io"
INFO[0132] ✅ Exists: CustomResourceDefinition "backingstores.noobaa.io"
INFO[0132] ✅ Exists: CustomResourceDefinition "bucketclasses.noobaa.io"
INFO[0132] ✅ Exists: CustomResourceDefinition "objectbuckets.objectbucket.io"
INFO[0132] ✅ Exists: CustomResourceDefinition "objectbucketclaims.objectbucket.io"
INFO[0132]                                              
INFO[0132] Operator Status:                             
INFO[0132] ✅ Exists: Namespace "noobaa"                 
INFO[0132] ✅ Exists: ServiceAccount "noobaa-operator"   
INFO[0132] ✅ Exists: Role "noobaa-operator"             
INFO[0132] ✅ Exists: RoleBinding "noobaa-operator"      
INFO[0132] ✅ Exists: ClusterRole "noobaa-operator"      
INFO[0132] ✅ Exists: ClusterRoleBinding "noobaa-operator-noobaa"
INFO[0132] ✅ Exists: StorageClass "noobaa-storage-class"
INFO[0132] ✅ Exists: Deployment "noobaa-operator"       
INFO[0132]                                              
INFO[0132] System Status:                               
INFO[0132] ✅ Exists: NooBaa "noobaa"                    
INFO[0132] ✅ Exists: StatefulSet "noobaa-core"          
INFO[0132] ✅ Exists: Service "noobaa-mgmt"              
INFO[0132] ✅ Exists: Service "s3"                       
INFO[0132] ✅ Exists: Secret "noobaa-server"             
INFO[0132] ✅ Exists: Secret "noobaa-operator"           
INFO[0132] ✅ Exists: Secret "noobaa-admin"              
INFO[0132] ✅ Exists: PrometheusRule "noobaa-prometheus-rules"
INFO[0132] ✅ Exists: PersistentVolumeClaim "logdir-noobaa-core-0"
INFO[0132] ✅ Exists: PersistentVolumeClaim "mongo-datadir-noobaa-core-0"
INFO[0132] ✅ System Phase is "Ready"                    
INFO[0132] ✅ Exists: Secret "noobaa-admin"              
INFO[0132]                                              
INFO[0132] #------------------#                         
INFO[0132] #- Mgmt Addresses -#                         
INFO[0132] #------------------#                         
INFO[0132]                                              
INFO[0132] ExternalDNS : [https://a742c38bdd43011e9859006920aa15ae-48998012.ap-southeast-1.elb.amazonaws.com:8443]
INFO[0132] ExternalIP  : []                             
INFO[0132] NodePorts   : [https://10.0.128.117:30511]   
INFO[0132] InternalDNS : [https://noobaa-mgmt.noobaa:8443]
INFO[0132] InternalIP  : [https://172.30.17.78:8443]    
INFO[0132] PodPorts    : [https://10.129.0.35:8443]     
INFO[0132]                                              
INFO[0132] #--------------------#                       
INFO[0132] #- Mgmt Credentials -#                       
INFO[0132] #--------------------#                       
INFO[0132]                                              
INFO[0132] system: noobaa                               
INFO[0132] email: admin@noobaa.io                       
INFO[0132] password: llCJKYbA1d9gwnwfUgWH9Q==           
INFO[0132]                                              
INFO[0132] #----------------#                           
INFO[0132] #- S3 Addresses -#                           
INFO[0132] #----------------#                           
INFO[0132]                                              
INFO[0132] ExternalDNS : [https://a742d8d63d43011e9859006920aa15ae-1082627478.ap-southeast-1.elb.amazonaws.com:443]
INFO[0132] ExternalIP  : []                             
INFO[0132] NodePorts   : [https://10.0.128.117:32553]   
INFO[0132] InternalDNS : [https://s3.noobaa:443]        
INFO[0132] InternalIP  : [https://172.30.167.212:443]   
INFO[0132] PodPorts    : [https://10.129.0.35:6443]     
INFO[0132]                                              
INFO[0132] #------------------#                         
INFO[0132] #- S3 Credentials -#                         
INFO[0132] #------------------#                         
INFO[0132]                                              
INFO[0132] AWS_ACCESS_KEY_ID: jEMd0m9pMFZPJ7iAzfGh      
INFO[0132] AWS_SECRET_ACCESS_KEY: 6IlMRHp1FgbFLvNJv8usdFvlf6Jtb7IiMomIzjlR
INFO[0132]                                              
route.route.openshift.io/s3 exposed
NAME   HOST/PORT                                                 PATH   SERVICES   PORT   TERMINATION   WILDCARD
s3     s3-noobaa.apps.cluster-7839.7839.sandbox525.opentlc.com          s3         s3                   None
NAME           TYPE     DATA   AGE
noobaa-admin   Opaque   5      4s
```

### Create a Bucket via Management interface

From the information provided via the Noobaa installer, login to the Management Interface.

```
INFO[0132] #------------------#                         
INFO[0132] #- Mgmt Addresses -#                         
INFO[0132] #------------------#                         
INFO[0132]                                              
INFO[0132] ExternalDNS : [https://a742c38bdd43011e9859006920aa15ae-48998012.ap-southeast-1.elb.amazonaws.com:8443]
INFO[0132] ExternalIP  : []                             
INFO[0132] NodePorts   : [https://10.0.128.117:30511]   
INFO[0132] InternalDNS : [https://noobaa-mgmt.noobaa:8443]
INFO[0132] InternalIP  : [https://172.30.17.78:8443]    
INFO[0132] PodPorts    : [https://10.129.0.35:8443]     
INFO[0132]                                              
INFO[0132] #--------------------#                       
INFO[0132] #- Mgmt Credentials -#                       
INFO[0132] #--------------------#                       
INFO[0132]                                              
INFO[0132] system: noobaa                               
INFO[0132] email: admin@noobaa.io                       
INFO[0132] password: llCJKYbA1d9gwnwfUgWH9Q==           
```

1. Open your browser to the ExternalDNS URL as shown in the `Mgmt Addresses`, and use the email and password from the `Mgmt Credentials` to login.

![Noobaa Login Screen](./screenshots/noobaa/noobaa-login-screen.png)

2. From the side menu, access the  `Buckets` page.

![Noobaa Bucket Screen](./screenshots/noobaa/noobaa-buckets-screen.png)

3. Create `mybucket` using defaults.

![Noobaa Bucket Screen](./screenshots/noobaa/noobaa-create-bucket-screen.png)

4. Verify the new bucket is available for use.

![Noobaa Bucket Screen](./screenshots/noobaa/noobaa-bucket-created.png)

### Creating a Replication Repository for Migration [MigStorage]

We can now create a Replication Repository using the following information.  Again, most of this information comes from the Noobaa installer output.

Bucket Name: mybucket

EndPoint: (See the route output from above.)

example:
http://s3-noobaa.apps.cluster-7839.7839.sandbox525.opentlc.com

```
INFO[0132]                                              
route.route.openshift.io/s3 exposed
NAME   HOST/PORT                                                 PATH   SERVICES   PORT   TERMINATION   WILDCARD
s3     s3-noobaa.apps.cluster-7839.7839.sandbox525.opentlc.com         
```

Access Key: & Secret Key:

```
INFO[0132] AWS_ACCESS_KEY_ID: jEMd0m9pMFZPJ7iAzfGh      
INFO[0132] AWS_SECRET_ACCESS_KEY: 6IlMRHp1FgbFLvNJv8usdFvlf6Jtb7IiMomIzjlR
```

Return to  Lab: [Lab 2 - Prerequisites and Setup](./2.md)<br>
[Home](./README.md)
