# App Migration Tool Tutorial

This tutorial will show you how to use the App Migration Tool to migrate
application workloads from an OCP 3.x cluster to OCP 4.x.

The overall steps tutorial will walk you through are:

* [Setup](Setup.md)
  1. Provision OCP 3.11 multi-node environment in AWS via
     [mig-agnosticd](https://github.com/fusor/mig-agnosticd/3.x/) to be used as
     the source cluster
  1. Provision OCP 4.1 multi-node environment in AWS via
     [mig-agnosticd](https://github.com/fusor/mig-agnosticd/4.x/) to be used as
     the destination cluster
  1. Deploy [migration
     workloads](https://github.com/fusor/mig-agnosticd/tree/master/workloads)
     onto both clusters
  1. Deploy [application
     workloads](https://github.com/fusor/mig-agnosticd/tree/master/workloads)
     onto source cluster to be migrated

* [Migrate with the Web UI](Migrate.md)
  1. Add the OCP 3.11 cluster as a migration source
  1. Add an AWS S3 bucket replication repository
  1. Create a migration plan to migrate an application workload to OCP 4.1
  1. Migrate the application workload
  1. Verify the application is functional on OCP 4.1
