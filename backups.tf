# sets up a container in the Swift object store for backups, and
# an application credential which can only write things to that 
# container

resource "openstack_objectstorage_container_v1" "backup" {
	name = "${var.cc_prefix}-backup"
}


resource "openstack_identity_application_credential_v3" "backup" {
  	name        = "${var.cc_prefix}-backup-cred"

  	access_rules {
    		path    = "/v1/AUTH_${var.nectar_project_id}/${openstack_objectstorage_container_v1.backup.name}/**"
    		service = "object-store"
    		method  = "PUT"
  	}


	access_rules {
		path    = "/v1/AUTH_${var.nectar_project_id}/${openstack_objectstorage_container_v1.backup.name}"
		service = "object-store"
		method  = "HEAD"
	}

	access_rules {
		path    = "/v1/AUTH_${var.nectar_project_id}/${openstack_objectstorage_container_v1.backup.name}/**"
		service = "object-store"
		method  = "HEAD"
	}

}

# make the credential's id and secret available as outputs

output "backup_credential_id" {
	value = openstack_identity_application_credential_v3.backup.id
}

output "backup_credential_secret" {
	value = openstack_identity_application_credential_v3.backup.secret
	sensitive = true
}
