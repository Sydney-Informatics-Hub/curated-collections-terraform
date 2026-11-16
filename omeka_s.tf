
resource "terraform_data" "omeka_s" {
	for_each = var.projects

	# Re-run whenever this project's rendered config changes
	triggers_replace = sha256(jsonencode(local.rendered[each.key]))

	connection {
		type        = "ssh"
		host        = openstack_networking_floatingip_v2.floatip.address
		user        = "ubuntu"
		private_key = file(var.ssh_private_key_path)
	}

	provisioner "remote-exec" {
		inline = [
			"sudo mkdir -p /srv/projects/${each.key}",
			"sudo chown ubuntu /srv/projects/${each.key}",
			"sudo mkdir -p /srv/projects/${each.key}/secrets",
			"sudo chown ubuntu /srv/projects/${each.key}/secrets",
			"sudo mkdir -p /srv/caddy/sites/${each.key}",
			"sudo chown ubuntu /srv/caddy/sites/${each.key}"
		]
	}

	provisioner "file" {
		content     = local.rendered[each.key].compose
		destination = "/srv/projects/${each.key}/compose.yml"
	}

	provisioner "file" {
		content     = local.rendered[each.key].oidc_config
		destination = "/srv/projects/${each.key}/secrets/oidc_config.json"
	}

	provisioner "file" {
		content     = random_password.mariadb_password[each.key].result
		destination = "/srv/projects/${each.key}/secrets/mariadb_password.txt"
	}

	provisioner "file" {
		content     = random_password.mariadb_root_password[name].result
		destination = "/srv/projects/${each.key}/secrets/mariadb_root_password.txt"
	}

	provisioner "file" {
		content     = random_password.omeka_admin_password[name].result
		destination = "/srv/projects/${each.key}/secrets/omeka_admin_password.txt"
	}

	provisioner "file" {
		content     = var.omeka_build_admin_email
		destination = "/srv/projects/${each.key}/secrets/omeka_build_admin_email.txt"
	}

	provisioner "file" {
		content     = var.omeka_build_site_slug
		destination = "/srv/projects/${each.key}/secrets/omeka_build_site_slug.txt"
	}

	provisioner "file" {
		content     = var.projects[each.key].omeka_admin_email
		destination = "/srv/projects/${each.key}/secrets/omeka_admin_email.txt"
	}

	provisioner "file" {
		content     = var.projects[each.key].omeka_admin_user
		destination = "/srv/projects/${each.key}/secrets/omeka_admin_user.txt"
	}

	provisioner "file" {
		content     = var.projects[each.key].omeka_project_title
		destination = "/srv/projects/${each.key}/secrets/omeka_project_title.txt"
	}

	provisioner "file" {
		content     = var.projects[each.key].omeka_site_slug
		destination = "/srv/projects/${each.key}/secrets/omeka_site_slug.txt"
	}

	provisioner "file" {
		content     = var.projects[each.key].omeka_site_title
		destination = "/srv/projects/${each.key}/secrets/omeka_site_title.txt"
	}

	provisioner "file" {
		content     = local.rendered[each.key].caddy
		destination = "/srv/caddy/sites/${each.key}.caddy"
	}

	provisioner "remote-exec" {
		inline = [
			"chmod 600 /srv/projects/${each.key}/.env",
			"cd /srv/projects/${each.key} && docker compose -p ${each.key} up -d",
			"docker exec caddy caddy reload --config /etc/caddy/Caddyfile",
		]
	}
}


