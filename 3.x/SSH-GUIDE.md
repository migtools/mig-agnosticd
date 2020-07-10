# SSH configuration for 3.x clusters

AgnosticD exports a set of SSH configurations post cluster installation. It lets users SSH into master, worker and support nodes directly from their computer without having to SSH into the bastion host. Another advantage of using the auto-generated SSH config is that the users can use the internal DNS addresses of the nodes in order to SSH into them. The internal DNS addresses can be easily found in the output of `oc get nodes` command. 

## How to setup?

The auto-generated SSH config can be found in the `output_dir` specified in the `my_vars.yml` file [here](https://github.com/konveyor/mig-agnosticd/blob/cb744dda550a74a6b23c57a08733597f2aa69bb9/3.x/my_vars.yml.sample#L14).

In the output directory, there are two SSH configs `ocp-workshop_${YOUR_GUID}_ssh_conf` and `ssh-config-ocp-workshop-${YOUR_GUID}`. Just include these files at the very top in your `~/.ssh/config` file :

```sh
Include ${your_output_dir}/ocp-workshop_${YOUR_GUID}_ssh_conf
Include ${your_output_dir}/ssh-config-ocp-workshop-${YOUR_GUID}
...
...
```

Once set up, try SSHing into your internal nodes directly from your computer. See example below :

```sh
# Find the internal DNS addresses of nodes
[user@localhost DataGenerator]$ oc get nodes
NAME                       STATUS   ROLES     AGE   VERSION
infranode1.guid.internal   Ready    infra     36d   v1.11.0+d4cacc0
master1.guid.internal      Ready    master    36d   v1.11.0+d4cacc0
node1.guid.internal        Ready    compute   36d   v1.11.0+d4cacc0
node2.guid.internal        Ready    compute   36d   v1.11.0+d4cacc0
support1.guid.internal     Ready    compute   36d   v1.11.0+d4cacc0
support2.guid.internal     Ready    compute   36d   v1.11.0+d4cacc0
support3.guid.internal     Ready    compute   36d   v1.11.0+d4cacc0

# use the internal address to ssh 
[user@localhost DataGenerator]$ ssh node1.guid.internal
Last login: Thu Jul  9 21:30:59 2020 from 192.168.0.8
[ec2-user@node1 ~]$
```

If SSH complains about bad permissions on the config files, simply run :

```sh
chmod 600 ${your_output_dir}/ocp-workshop_${YOUR_GUID}_ssh_conf
chmod 600 ${your_output_dir}/ssh-config-ocp-workshop-${YOUR_GUID}
```

If your SSH client doesn't allow including config files, you can just copy the contents of both the files directly in your main `~/.ssh/config` file.
