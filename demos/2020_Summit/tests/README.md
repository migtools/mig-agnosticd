## Lab Tests

Misc. scripts to deploy 2020 Summit lab-like environments.

## Instructions

Prepare your `my_vars.yml` files in both [3.x](./3.x/) and [4.x](./4.x/) directories.

Make sure you have secret.yml file created [here](../../../../secret.yml).

To deploy OCP 3 Lab environment, run :

```
./create_ocp3_workshop.sh
```

This deploys OCP3 with Migration workload, sample apps, Gluster and NFS.

To delete, run :

```
./delete_ocp3_workshop.sh
```

To deploy OCP 4 Lab environment, run : 

```
./create_ocp4_workshop.sh
```

This deploys OCP4 with Migration workload, and OCS Operator.

To delete, run : 

```
./delete_ocp4_workshop.sh
```
