
# calculated values (like the full hostname and the completed
# docker-compose and caddyfile templates) and purely internal
# things like the temporary admin and site slugs

# Actual external configs (like the project ID, and the versions
# of the container images) are in project-variables.tf and
# variables.tf


locals {
    omeka_build_admin_email = "admin-tmp@curated-collections.edu.au"
    omeka_build_site_slug = "temp-site"
    hostname = var.cc_prefix

    # project_rendered has the config files for each project, as rendered with values
    # from var.projects

    caddyfile_top = templatefile("${path.module}/templates/Caddyfile.tpl", {
    })

    rendered = {
	for name, p in var.projects: name => {

    	    hostname = "${name}.${var.cc_domain}"
            base_url = "https://${name}.${var.cc_domain}"

	    compose = templatefile("${path.module}/templates/docker-compose.yml.tpl", {
                omeka_s_image = "${p.omeka_s_image}"
                mariadb_image = "${p.mariadb_image}"
            })

            env = templatefile("${path.module}/templates/env", {
		mariadb_password = random_password.mariadb_password[name].result
        	mariadb_root_password = random_password.mariadb_root_password[name].result
        	omeka_admin_password = random_password.omeka_admin_password[name].result
        	omeka_build_admin_email = local.omeka_build_admin_email
		omeka_build_site_slug = local.omeka_build_site_slug
        	omeka_admin_email = p.omeka_admin_email
       		omeka_admin_user = p.omeka_admin_user
		omeka_project_title = p.omeka_project_title
        	omeka_site_slug = p.omeka_site_slug
        	omeka_site_title = p.omeka_site_title
            })

     	    oidc_config = jsonencode({
    	        oidc_base_url = "${p.base_url}"
  		oidc_idp_discovery_url = "${var.oidc_idp_discovery_url}"
        	oidc_client_id = "${var.oidc_client_id}"
		oidc_client_secret = "${var.oidc_client_secret}"
        	oidc_access_guard_claim = "isMemberOf"
        	oidc_access_guard_value = "${p.oidc_group}"
        	oidc_hide_local_login = p.oidc_hide_local_login
        	oidc_roles_map = p.oidc_roles_map
        	oidc_roles_default = ""
    	    })

            caddyfile = templatefile("${path.module}/templates/instance_Caddyfile.tpl", {
		hostname = "${name}.${var.cc_domain}"
    		tls_admin_email = var.tls_admin_email
    	    })

	}
    }
}

