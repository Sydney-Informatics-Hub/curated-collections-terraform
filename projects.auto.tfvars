 

projects = {
	testbed1 = {
		hostname    = "testbed1"
		owner_email = "m.lynch@sydney.edu.au"
		owner_name  = "Mike Lynch"
		oidc_group  = "testbed1" 
		oidc_roles_map = {
			admin = "global_admin"
			user = "editor"
		}
		omeka_admin_email = "admin@curated-collections.edu.au"
		omeka_s_image = "registry.rc.nectar.org.au/curated-collections/cc-omeka-s@sha256:2300ff113b48f0a0757264c22b296da373fed7abe2c6569d6959610440d83073"
		mariadb_image = "registry.rc.nectar.org.au/curated-collections/cc-mariadb@sha256:2cbce71ec413dd56f5a6e30850bfc90c07864a6b69f6a798d5e4fe8b83a05369"
	}

	testbed2 = {
		hostname    = "testbed2"
		owner_email = "m.lynch@sydney.edu.au"
		owner_name = "Mike Lynch"
		oidc_group  = "testbed2" 
		oidc_roles_map = {
			admin = "global_admin"
			user = "editor"
		}
		omeka_admin_email = "admin@curated-collections.edu.au"
		omeka_s_image = "registry.rc.nectar.org.au/curated-collections/cc-omeka-s@sha256:2300ff113b48f0a0757264c22b296da373fed7abe2c6569d6959610440d83073"
		mariadb_image = "registry.rc.nectar.org.au/curated-collections/cc-mariadb@sha256:2cbce71ec413dd56f5a6e30850bfc90c07864a6b69f6a798d5e4fe8b83a05369"
	}
}

