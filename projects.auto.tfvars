 projects = {
	alpha = {
		hostname    = "alpha"
		owner_email = "m.lynch@sydney.edu.au"
		owner_name  = "Mike Lynch"
		oidc_hide_local_login = false
		oidc_group  = "alpha-project-members" 
		oidc_roles_map = {
			alpha-project-admins = "global_admin"
			alpha-project-researchers = "editor"
		}
		omeka_project_title = "Alpha"
		omeka_admin_email = "admin@curated-collections.edu.au"
		omeka_s_image = "registry.rc.nectar.org.au/curated-collections/cc-omeka-s@sha256:2300ff113b48f0a0757264c22b296da373fed7abe2c6569d6959610440d83073"
		mariadb_image = "registry.rc.nectar.org.au/curated-collections/cc-mariadb@sha256:2cbce71ec413dd56f5a6e30850bfc90c07864a6b69f6a798d5e4fe8b83a05369"
	}

	beta = {
		hostname    = "beta"
		owner_email = "m.lynch@sydney.edu.au"
		owner_name = "Mike Lynch"
		oidc_hide_local_login = false
		oidc_group  = "beta-project-members" 
		oidc_roles_map = {
			beta-project-admins = "global_admin"
			beta-project-researchers = "editor"
		}
		omeka_project_title = "Beta"
		omeka_admin_email = "admin@curated-collections.edu.au"
		omeka_s_image = "registry.rc.nectar.org.au/curated-collections/cc-omeka-s@sha256:2300ff113b48f0a0757264c22b296da373fed7abe2c6569d6959610440d83073"
		mariadb_image = "registry.rc.nectar.org.au/curated-collections/cc-mariadb@sha256:2cbce71ec413dd56f5a6e30850bfc90c07864a6b69f6a798d5e4fe8b83a05369"
	}

	gamma = {
		hostname    = "gamma"
		owner_email = "m.lynch@sydney.edu.au"
		owner_name = "Mike Lynch"
		oidc_hide_local_login = false
		oidc_group  = "gamma-project-members" 
		oidc_roles_map = {
			gamma-project-admins = "global_admin"
			gamma-project-researchers = "editor"
		}
		omeka_project_title = "Gamma"
		omeka_admin_email = "admin@curated-collections.edu.au"
		omeka_s_image = "registry.rc.nectar.org.au/curated-collections/cc-omeka-s@sha256:2300ff113b48f0a0757264c22b296da373fed7abe2c6569d6959610440d83073"
		mariadb_image = "registry.rc.nectar.org.au/curated-collections/cc-mariadb@sha256:2cbce71ec413dd56f5a6e30850bfc90c07864a6b69f6a798d5e4fe8b83a05369"
	}
}

