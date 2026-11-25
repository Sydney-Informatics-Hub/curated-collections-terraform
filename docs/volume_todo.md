# Persistent volume mounting

## One-time jobs

Storage is now provisioned and attached with terraform, but formatting and mounting is manual

Steps - based on [this page](https://tutorials.rc.nectar.org.au/volume-storage/04-format-mount)

- format the disk
- mount it at /pvol
- set the permissions to ubuntu:ubuntu
- create a directory /pvol/projects/

This stuff all needs to happen once, when the storage is provisioned, so
should go in cloud-init.yaml, but I'm not automating it now.


