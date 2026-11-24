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

	sounding-solidarity = {
		hostname    = "sounding-solidarity"
		owner_email = "wesley.watkins@sydney.edu.au"
		owner_name = "Wesley Watkins"
		oidc_hide_local_login = true
		oidc_group  = "project-sounding-solidarity-members" 
		oidc_roles_map = {
			project-sounding-solidarity-admins = "global_admin"
			project-sounding-solidarity-researchers = "editor"
		}
		omeka_project_title = "Sounding Solidarity"
		omeka_admin_email = "admin@curated-collections.edu.au"
		omeka_s_image = "registry.rc.nectar.org.au/curated-collections/cc-omeka-s@sha256:26b4cbae70dbf52e844a838b352fc7b30d54574339866520eec10ff60c554781"
		mariadb_image = "registry.rc.nectar.org.au/curated-collections/cc-mariadb@sha256:81072b4434c2691b7fd6ee80a3d1a30ef7119dd8b0c6d86cef9e3a0b1cb9e393"
	}
        
	carceral-archipelago = {
		hostname    = "carceral-staging"
		owner_email = "dashiell.moore@sydney.edu.au"
		owner_name = "Dashiell Moore"
		oidc_hide_local_login = true
		oidc_group  = "project-carceral-archipelago-members" 
		oidc_roles_map = {
			project-carceral-archipelago-admins = "global_admin"
			project-carceral-archipelago-researchers = "editor"
		}
		omeka_project_title = "Archipelagic Connections"
		omeka_admin_email = "admin@curated-collections.edu.au"
		omeka_s_image = "registry.rc.nectar.org.au/curated-collections/cc-omeka-s@sha256:26b4cbae70dbf52e844a838b352fc7b30d54574339866520eec10ff60c554781"
		mariadb_image = "registry.rc.nectar.org.au/curated-collections/cc-mariadb@sha256:81072b4434c2691b7fd6ee80a3d1a30ef7119dd8b0c6d86cef9e3a0b1cb9e393"
	}
}
