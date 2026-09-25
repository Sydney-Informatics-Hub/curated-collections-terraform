
# calculated values (like the full hostname and the completed
# docker-compose and caddyfile templates) and purely internal
# things like the temporary admin and site slugs

# Actual external configs (like the project ID, and the versions
# of the container images) are in project-variables.tf and
# variables.tf


locals {
    omeka_build_admin_email = "admin-tmp@curated-collections.edu.au"
    omeka_build_site_slug = "temp-site"
    cc_prefix = "cc-${var.cc_project_id}"
    hostname = "${var.cc_project_id}.${var.cc_domain}"
    base_url = "https://${local.hostname}"
    caddyfile_content = templatefile("${path.module}/templates/Caddyfile.tpl", {
	hostname = "${var.cc_project_id}.${var.cc_domain}"
    	tls_admin_email = "m.lynch@sydney.edu.au"
    })
    docker_compose_content = templatefile("${path.module}/templates/docker-compose.yml.tpl", {
    	omeka_s_image = "${var.omeka_s_image}"
        mariadb_image = "${var.mariadb_image}"
    })
    oidc_config_content = jsonencode({
    	oidc_base_url = "${local.base_url}"
  	oidc_idp_discovery_url = "${var.oidc_idp_discovery_url}"
        oidc_client_id = "${var.oidc_client_id}"
	oidc_client_secret = "${var.oidc_client_secret}"
        oidc_access_guard_claim = "isMemberOf"
        oidc_access_guard_value = "${var.cilogon_group}"
        oidc_hide_local_login = var.oidc_hide_local_login
        oidc_roles_map = var.oidc_roles_map
        oidc_roles_default = ""
    })
}

