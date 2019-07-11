## Openshift 3.x Cors Settings for Mig UI

This is a standalone script to apply Mig UI's CORS settings on Openshift 3.x clusters.

Before running this script, please make sure that you deployed Mig UI on your 4.x cluster. It is assumed that you launched clusters with `mig-agnosticd`.

This script uses the same `my_vars.yml` file you used when launching a new cluster. Make sure those files are present for both the clusters.

```
../3.x/my_vars.yml
../4.x/my_vars.yml
```

### Usage

Run the script

```
ansible-playbook cors.yml
```

There is no need to set any variables, the script reads `my_vars.yml` files and puts the right settings.

