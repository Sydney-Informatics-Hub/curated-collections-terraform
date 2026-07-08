


locals {
    cc_prefix = "cc-${var.cc_project_id}"
    hostname = "${var.cc_project_id}.${var.cc_domain}"
    caddyfile_content = templatefile("${path.module}/templates/Caddyfile.tpl", {
	hostname = "${var.cc_project_id}.${var.cc_domain}"
    	tls_admin_email = "m.lynch@sydney.edu.au"
    })
    docker_compose_content = templatefile("${path.module}/templates/docker-compose.yml.tpl", {
    	omeka_s_image = "registry.rc.nectar.org.au/curated-collections/cc-omeka-s@sha256:54f1cffbd4d7370d70cdfdf48bff325b3b17792993f9e85d702e397a9cda3c54"
        mariadb_image = "registry.rc.nectar.org.au/curated-collections/cc-mariadb@sha256:229b104057cb01fda97422356cd1f8e0d7de2445066d4cba39d1b6873294424c"
    })
    omeka_admin_email = "m.lynch@sydney.edu.au"
    omeka_build_admin_email = "admin-tmp@curated-collections.edu.au"
    omeka_admin_user = "Mike Lynch"
    omeka_site_title = "Special Site"
    omeka_project_title = "Omeka Project Title"
    omeka_site_slug = "special"
    omeka_build_site_slug = "temp-site"
}
