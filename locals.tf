


locals {
    cc_prefix = "cc-${var.cc_project_id}"
    hostname = "${var.cc_project_id}.${var.cc_domain}"
    caddyfile_content = templatefile("${path.module}/templates/Caddyfile.tpl", {
	hostname = "${var.cc_project_id}.${var.cc_domain}"
    	tls_admin_email = "m.lynch@sydney.edu.au"
    })
    docker_compose_content = templatefile("${path.module}/templates/docker-compose.yml.tpl", {
    	omeka_s_image = "registry.rc.nectar.org.au/curated-collections/cc-omeka-s@sha256:deda963608fd34aa4c8caa803e39473f275510a88297bbdb063ca854199c4ecb"
    })
    init_db_content = file("${path.module}/assets/init-db.sql")

    omeka_admin_email = "m.lynch@sydney.edu.au"
    omeka_build_admin_email = "admin-tmp@curated-collections.edu.au"
    omeka_admin_user = "Mike Lynch"
    omeka_site_title = "Special Site"
    omeka_project_title = "Omeka Project Title"
    omeka_site_slug = "special"
    omeka_build_site_slug = "temp-site"
}
