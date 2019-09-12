## Noobaa - Object Storage Setup

CAM components use S3 object storage as temporary scratch space when performing migrations.  This storage can be any object storage that presents an `S3 like` interface.  Currently, we have tested AWS S3, Noobaa, and Minio.  These instructions outline installation, setup and creation of a noobaa replication repository.

### Installation

NooBaa can run on an OpenShift cluster to provide an S3 compatible store for migration scratch space. We recommend loading NooBaa onto the destination cluster.  We've created a simple installation script that you can download a use.  Just perform the following steps:

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
$ chmod +x setup_noobaa.sh
```

4. ./setup_noobaa.sh

```
$ ./setup_noobaa.sh
--2019-09-12 15:40:55--  https://github.com/noobaa/noobaa-operator/releases/download/v1.1.1/noobaa-linux-v1.1.1
Resolving github.com (github.com)... 52.74.223.119
Connecting to github.com (github.com)|52.74.223.119|:443... connected.
HTTP request sent, awaiting response... 302 Found
Location: https://github-production-release-asset-2e65be.s3.amazonaws.com/194805859/7d933080-d3cf-11e9-9870-dc26ae740f88?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAIWNJYAX4CSVEH53A%2F20190912%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Date=20190912T154055Z&X-Amz-Expires=300&X-Amz-Signature=e8374857fe920173347e700f57747918d9879b397b83145eddde71b96fbbfd42&X-Amz-SignedHeaders=host&actor_id=0&response-content-disposition=attachment%3B%20filename%3Dnoobaa-linux-v1.1.1&response-content-type=application%2Foctet-stream [following]
--2019-09-12 15:40:55--  https://github-production-release-asset-2e65be.s3.amazonaws.com/194805859/7d933080-d3cf-11e9-9870-dc26ae740f88?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAIWNJYAX4CSVEH53A%2F20190912%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Date=20190912T154055Z&X-Amz-Expires=300&X-Amz-Signature=e8374857fe920173347e700f57747918d9879b397b83145eddde71b96fbbfd42&X-Amz-SignedHeaders=host&actor_id=0&response-content-disposition=attachment%3B%20filename%3Dnoobaa-linux-v1.1.1&response-content-type=application%2Foctet-stream
Resolving github-production-release-asset-2e65be.s3.amazonaws.com (github-production-release-asset-2e65be.s3.amazonaws.com)... 52.216.207.195
Connecting to github-production-release-asset-2e65be.s3.amazonaws.com (github-production-release-asset-2e65be.s3.amazonaws.com)|52.216.207.195|:443... connected.
HTTP request sent, awaiting response... 200 OK
Length: 49924963 (48M) [application/octet-stream]
Saving to: ‘noobaa-linux-v1.1.1’

100%[====================================================================================================================================================================================================>] 49,924,963  6.61MB/s   in 9.0s   

2019-09-12 15:41:05 (5.28 MB/s) - ‘noobaa-linux-v1.1.1’ saved [49924963/49924963]

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
INFO[0000] ⏳ System Phase is "". Pod "noobaa-operator-599bf96b86-vfh5s" is not yet ready: Phase="Pending". ContainersNotReady (containers with unready status: [noobaa-operator]). ContainersNotReady (containers with unready status: [noobaa-operator]).  
INFO[0003] ⏳ System Phase is "". Pod "noobaa-operator-599bf96b86-vfh5s" is not yet ready: Phase="Pending". ContainersNotReady (containers with unready status: [noobaa-operator]). ContainersNotReady (containers with unready status: [noobaa-operator]).  
INFO[0006] ⏳ System Phase is "". Pod "noobaa-operator-599bf96b86-vfh5s" is not yet ready: Phase="Pending". ContainersNotReady (containers with unready status: [noobaa-operator]). ContainersNotReady (containers with unready status: [noobaa-operator]).  
INFO[0009] ⏳ System Phase is "". Pod "noobaa-operator-599bf96b86-vfh5s" is not yet ready: Phase="Pending". ContainersNotReady (containers with unready status: [noobaa-operator]). ContainersNotReady (containers with unready status: [noobaa-operator]).  
INFO[0012] ⏳ System Phase is "". Pod "noobaa-operator-599bf96b86-vfh5s" is not yet ready: Phase="Pending". ContainersNotReady (containers with unready status: [noobaa-operator]). ContainersNotReady (containers with unready status: [noobaa-operator]).  
INFO[0015] ⏳ System Phase is "". Pod "noobaa-operator-599bf96b86-vfh5s" is not yet ready: Phase="Pending". ContainersNotReady (containers with unready status: [noobaa-operator]). ContainersNotReady (containers with unready status: [noobaa-operator]).  
INFO[0018] ⏳ System Phase is "". Pod "noobaa-operator-599bf96b86-vfh5s" is not yet ready: Phase="Pending". ContainersNotReady (containers with unready status: [noobaa-operator]). ContainersNotReady (containers with unready status: [noobaa-operator]).  
INFO[0021] ⏳ System Phase is "". Pod "noobaa-operator-599bf96b86-vfh5s" is not yet ready: Phase="Pending". ContainersNotReady (containers with unready status: [noobaa-operator]). ContainersNotReady (containers with unready status: [noobaa-operator]).  
INFO[0024] ⏳ System Phase is "". Pod "noobaa-operator-599bf96b86-vfh5s" is not yet ready: Phase="Pending". ContainersNotReady (containers with unready status: [noobaa-operator]). ContainersNotReady (containers with unready status: [noobaa-operator]).  
INFO[0027] ⏳ System Phase is "". Pod "noobaa-operator-599bf96b86-vfh5s" is not yet ready: Phase="Pending". ContainersNotReady (containers with unready status: [noobaa-operator]). ContainersNotReady (containers with unready status: [noobaa-operator]).  
INFO[0030] ⏳ System Phase is "". Pod "noobaa-operator-599bf96b86-vfh5s" is not yet ready: Phase="Pending". ContainersNotReady (containers with unready status: [noobaa-operator]). ContainersNotReady (containers with unready status: [noobaa-operator]).  
INFO[0033] ⏳ System Phase is "". Pod "noobaa-operator-599bf96b86-vfh5s" is not yet ready: Phase="Pending". ContainersNotReady (containers with unready status: [noobaa-operator]). ContainersNotReady (containers with unready status: [noobaa-operator]).  
INFO[0036] ⏳ System Phase is "". Pod "noobaa-operator-599bf96b86-vfh5s" is not yet ready: Phase="Pending". ContainersNotReady (containers with unready status: [noobaa-operator]). ContainersNotReady (containers with unready status: [noobaa-operator]).  
INFO[0039] ⏳ System Phase is "Creating". Pod "noobaa-core-0" is not yet ready: Phase="Pending".  
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
INFO[0084] ⏳ System Phase is "Connecting". Pod "noobaa-core-0" is not yet ready: Phase="Pending". ContainersNotInitialized (containers with incomplete status: [init-mongo]). ContainersNotReady (containers with unready status: [mongodb noobaa-server]). ContainersNotReady (containers with unready status: [mongodb noobaa-server]).  
INFO[0087] ⏳ System Phase is "Connecting". Pod "noobaa-core-0" is not yet ready: Phase="Pending". ContainersNotInitialized (containers with incomplete status: [init-mongo]). ContainersNotReady (containers with unready status: [mongodb noobaa-server]). ContainersNotReady (containers with unready status: [mongodb noobaa-server]).  
INFO[0090] ⏳ System Phase is "Connecting". Pod "noobaa-core-0" is not yet ready: Phase="Pending". ContainersNotInitialized (containers with incomplete status: [init-mongo]). ContainersNotReady (containers with unready status: [mongodb noobaa-server]). ContainersNotReady (containers with unready status: [mongodb noobaa-server]).  
INFO[0093] ⏳ System Phase is "Connecting". Pod "noobaa-core-0" is not yet ready: Phase="Pending". ContainersNotReady (containers with unready status: [mongodb noobaa-server]). ContainersNotReady (containers with unready status: [mongodb noobaa-server]).  
INFO[0096] ⏳ System Phase is "Connecting". Pod "noobaa-core-0" is not yet ready: Phase="Pending". ContainersNotReady (containers with unready status: [mongodb noobaa-server]). ContainersNotReady (containers with unready status: [mongodb noobaa-server]).  
INFO[0099] ⏳ System Phase is "Connecting". Pod "noobaa-core-0" is not yet ready: Phase="Pending". ContainersNotReady (containers with unready status: [mongodb noobaa-server]). ContainersNotReady (containers with unready status: [mongodb noobaa-server]).  
INFO[0102] ⏳ System Phase is "Connecting". Pod "noobaa-core-0" is not yet ready: Phase="Pending". ContainersNotReady (containers with unready status: [mongodb noobaa-server]). ContainersNotReady (containers with unready status: [mongodb noobaa-server]).  
INFO[0105] ⏳ System Phase is "Connecting". Pod "noobaa-core-0" is not yet ready: Phase="Pending". ContainersNotReady (containers with unready status: [mongodb noobaa-server]). ContainersNotReady (containers with unready status: [mongodb noobaa-server]).  
INFO[0108] ⏳ System Phase is "Connecting". Pod "noobaa-core-0" is not yet ready: Phase="Pending". ContainersNotReady (containers with unready status: [mongodb noobaa-server]). ContainersNotReady (containers with unready status: [mongodb noobaa-server]).  
INFO[0111] ⏳ System Phase is "Connecting". Pod "noobaa-core-0" is not yet ready: Phase="Pending". ContainersNotReady (containers with unready status: [mongodb noobaa-server]). ContainersNotReady (containers with unready status: [mongodb noobaa-server]).  
INFO[0114] ⏳ System Phase is "Connecting". Pod "noobaa-core-0" is not yet ready: Phase="Pending". ContainersNotReady (containers with unready status: [mongodb noobaa-server]). ContainersNotReady (containers with unready status: [mongodb noobaa-server]).  
INFO[0117] ⏳ System Phase is "Connecting". Pod "noobaa-core-0" is not yet ready: Phase="Pending". ContainersNotReady (containers with unready status: [mongodb noobaa-server]). ContainersNotReady (containers with unready status: [mongodb noobaa-server]).  
INFO[0120] ⏳ System Phase is "Connecting". Pod "noobaa-core-0" is not yet ready: Phase="Pending". ContainersNotReady (containers with unready status: [mongodb noobaa-server]). ContainersNotReady (containers with unready status: [mongodb noobaa-server]).  
INFO[0123] ⏳ System Phase is "Connecting". Container "noobaa-server" is not yet ready: starting...
INFO[0126] ⏳ System Phase is "Connecting". Container "noobaa-server" is not yet ready: starting...
INFO[0129] ⏳ System Phase is "Connecting". Container "noobaa-server" is not yet ready: starting...
INFO[0132] ⏳ System Phase is "Connecting". Container "noobaa-server" is not yet ready: starting...
INFO[0135] ⏳ System Phase is "Connecting". Container "noobaa-server" is not yet ready: starting...
INFO[0138] ⏳ System Phase is "Connecting". Container "noobaa-server" is not yet ready: starting...
INFO[0141] ✅ System Phase is "Ready".                   
INFO[0141] CLI version: 1.1.1                           
INFO[0141] noobaa-image: noobaa/noobaa-core:5           
INFO[0141] operator-image: noobaa/noobaa-operator:1.1.1
INFO[0141] Namespace: noobaa                            
INFO[0141]                                              
INFO[0141] CRD Status:                                  
INFO[0141] ✅ Exists: CustomResourceDefinition "noobaas.noobaa.io"
INFO[0141] ✅ Exists: CustomResourceDefinition "backingstores.noobaa.io"
INFO[0141] ✅ Exists: CustomResourceDefinition "bucketclasses.noobaa.io"
INFO[0141] ✅ Exists: CustomResourceDefinition "objectbuckets.objectbucket.io"
INFO[0141] ✅ Exists: CustomResourceDefinition "objectbucketclaims.objectbucket.io"
INFO[0141]                                              
INFO[0141] Operator Status:                             
INFO[0141] ✅ Exists: Namespace "noobaa"                 
INFO[0141] ✅ Exists: ServiceAccount "noobaa-operator"   
INFO[0141] ✅ Exists: Role "noobaa-operator"             
INFO[0141] ✅ Exists: RoleBinding "noobaa-operator"      
INFO[0141] ✅ Exists: ClusterRole "noobaa-operator"      
INFO[0141] ✅ Exists: ClusterRoleBinding "noobaa-operator-noobaa"
INFO[0141] ✅ Exists: StorageClass "noobaa-storage-class"
INFO[0141] ✅ Exists: Deployment "noobaa-operator"       
INFO[0141]                                              
INFO[0141] System Status:                               
INFO[0141] ✅ Exists: NooBaa "noobaa"                    
INFO[0141] ✅ Exists: StatefulSet "noobaa-core"          
INFO[0141] ✅ Exists: Service "noobaa-mgmt"              
INFO[0141] ✅ Exists: Service "s3"                       
INFO[0141] ✅ Exists: Secret "noobaa-server"             
INFO[0141] ✅ Exists: Secret "noobaa-operator"           
INFO[0141] ✅ Exists: Secret "noobaa-admin"              
INFO[0141] ✅ Exists: PrometheusRule "noobaa-prometheus-rules"
INFO[0141] ✅ Exists: PersistentVolumeClaim "logdir-noobaa-core-0"
INFO[0141] ✅ Exists: PersistentVolumeClaim "mongo-datadir-noobaa-core-0"
INFO[0141] ✅ System Phase is "Ready"                    
INFO[0141] ✅ Exists: Secret "noobaa-admin"              
INFO[0141]                                              
INFO[0141] #------------------#                         
INFO[0141] #- Mgmt Addresses -#                         
INFO[0141] #------------------#                         
INFO[0141]                                              
INFO[0141] ExternalDNS : [https://ad25e6246d57311e9935602732066408-668145310.ap-southeast-1.elb.amazonaws.com:8443]
INFO[0141] ExternalIP  : []                             
INFO[0141] NodePorts   : [https://10.0.128.246:31384]   
INFO[0141] InternalDNS : [https://noobaa-mgmt.noobaa:8443]
INFO[0141] InternalIP  : [https://172.30.220.83:8443]   
INFO[0141] PodPorts    : [https://10.129.0.37:8443]     
INFO[0141]                                              
INFO[0141] #--------------------#                       
INFO[0141] #- Mgmt Credentials -#                       
INFO[0141] #--------------------#                       
INFO[0141]                                              
INFO[0141] password: wSVgmIoBltWAUzqxsNdPeg==           
INFO[0141] system: noobaa                               
INFO[0141] email: admin@noobaa.io                       
INFO[0141]                                              
INFO[0141] #----------------#                           
INFO[0141] #- S3 Addresses -#                           
INFO[0141] #----------------#                           
INFO[0141]                                              
INFO[0141] ExternalDNS : [https://ad25fc94ed57311e9935602732066408-369370669.ap-southeast-1.elb.amazonaws.com:443]
INFO[0141] ExternalIP  : []                             
INFO[0141] NodePorts   : [https://10.0.128.246:32322]   
INFO[0141] InternalDNS : [https://s3.noobaa:443]        
INFO[0141] InternalIP  : [https://172.30.236.186:443]   
INFO[0141] PodPorts    : [https://10.129.0.37:6443]     
INFO[0141]                                              
INFO[0141] #------------------#                         
INFO[0141] #- S3 Credentials -#                         
INFO[0141] #------------------#                         
INFO[0141]                                              
INFO[0141] AWS_ACCESS_KEY_ID: UzUxSjvRGSNfoleqi6ly      
INFO[0141] AWS_SECRET_ACCESS_KEY: vhY1npAeR0m/S0+UsZjIun8Eu4EMc7yy88sUiUN7
INFO[0141]                                              
route.route.openshift.io/s3 exposed
S3 endpoint of:  's3-noobaa.apps.cluster-ef7b.ef7b.sandbox951.opentlc.com'
AWS_ACCESS_KEY_ID of 'UzUxSjvRGSNfoleqi6ly'
AWS_SECRET_KEY of 'vhY1npAeR0m/S0+UsZjIun8Eu4EMc7yy88sUiUN7'
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

```
S3 endpoint of:  's3-noobaa.apps.cluster-ef7b.ef7b.sandbox951.opentlc.com'
AWS_ACCESS_KEY_ID of 'UzUxSjvRGSNfoleqi6ly'
AWS_SECRET_KEY of 'vhY1npAeR0m/S0+UsZjIun8Eu4EMc7yy88sUiUN7'
```

***NOTE: For the S3 endpoint prefix with `http://` when creating replication respository.***

Return to  Lab: [Lab 2 - Prerequisites and Setup](./2.md)<br>
[Home](./README.md)
