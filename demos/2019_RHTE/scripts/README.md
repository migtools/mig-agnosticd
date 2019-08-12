# Scripts for Migration Demos in RHTE 2019 Labs

## Applying CORS Settings

To apply CORS settings on your OCP3 cluster : 

```bash
USER=<user_on_bastion> GUID_3=<guid_of_ocp3> GUID_4=<guid_of_ocp4> DOMAIN=<domain_of_ocp4_lab> ansible-playbook cors.yaml -i bastion.<GUID_3>.<DOMAIN>
```

Example usage :

```bash
USER=lab_user GUID_3=c8ss GUID_4=09kt domain=events.opentlc.com ansible-playbook cors.yaml -i bastion.c8ss.events.opentlc.com
```
