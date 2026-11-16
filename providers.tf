terraform {
    required_providers {
        openstack = {
            source = "terraform-provider-openstack/openstack"
            version = "3.4.0"
        }
    }
    required_version = ">= 0.13"

    backend "s3" {
        bucket = "cc-tfstate"
        key    = "cc-tfstate/terraform.tfstate"
        region = "us-east-1"
        endpoints = {
            s3 = "https://object-store.rc.nectar.org.au"
    	}
    	use_path_style              = true
    	skip_credentials_validation = true   # no AWS STS
    	skip_region_validation      = true
    	skip_requesting_account_id  = true
    	skip_metadata_api_check     = true
    	skip_s3_checksum            = true   # avoid AWS-specific checksum/chunked uploads
    }
}

provider "openstack" {
    user_name = "${var.openstack_user}"
    tenant_id = "${var.nectar_project_id}"
    tenant_name = "${var.nectar_project_name}"
    password = "${var.openstack_password}"
    auth_url = "https://identity.rc.nectar.org.au/v3/"
}


