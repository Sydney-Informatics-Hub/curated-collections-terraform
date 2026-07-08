# Curated Collections Deploy Scripts

This is a Terraform module to install the Curated Collections distribution
of Omeka S to Nectar via its OpenStack API.

## Configuration

Values which should be set in project-config.tf as follows:

- cc_project_id - a unique string for this project in Curated Collections, will be used as the hostname as in  ${cc_project_id}.curated-collections.cloud.edu,au
- omeka_admin_email - email address for the local admin account
- omeka_admin_user - username for the local admin account
- omeka_project_title - the installation title
- omeka_site_title - the default public site title
- omeka_site_slug - the default public site's slug (url path)


## What the module does

The module creates the following on Nectar:

- a network
- a subnet
- a router
- a compute instance
- a fixed IP attached to the compute instance
- a DNS record for cc_project_id pointing at the fixed IP

The module then pulls the Omeka S and database images from the Nectar
container registry, runs docker compose, and resets the database's user
and root password, and the Omeka S admin account password, to random
values.

You can get the Omeka S admin password with the command

    > terraform output -raw omeka_admin_password

You shouldn't need to use the db passwords, but you can get them using the
same command with db_password or db_root_password as the second argument.
