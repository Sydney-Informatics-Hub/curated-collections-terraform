terraform {
    required_providers {
        openstack = {
            source = "terraform-provider-openstack/openstack"
            version = "3.4.0"
        }
    }
    required_version = ">= 0.13"
}

provider "openstack" {
    user_name = "${var.openstack_user}"
    tenant_id = "${var.nectar_project_id}"
    tenant_name = "${var.nectar_project_name}"
    password = "${var.openstack_password}"
    auth_url = "https://identity.rc.nectar.org.au/v3/"
}


