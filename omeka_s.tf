
# this resource copies the per-project config and secrets
# and starts docker compose for each of them

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

	# Setting the omeka UID:GID on the project's volume storage
        # is required so that the dockerised Omeka can write files 
        # there. 

	provisioner "remote-exec" {
		inline = [
			"sudo mkdir -p ${var.docker_dir}/${each.key}",
			"sudo chown ubuntu ${var.docker_dir}/${each.key}",
			"sudo mkdir -p ${var.docker_dir}/${each.key}/secrets",
			"sudo chown ubuntu:ubuntu ${var.docker_dir}/${each.key}/secrets",
			"sudo mkdir -p ${var.caddy_dir}/${each.key}",
			"sudo chown ubuntu ${var.caddy_dir}/${each.key}",
			"sudo mkdir -p ${var.volume_dir}/${each.key}/files",
			"sudo chown ubuntu:ubuntu ${var.volume_dir}/${each.key}/",
			"sudo chown ${var.omeka_uid}:${var.omeka_gid} ${var.volume_dir}/${each.key}/"
		]
	}

	provisioner "file" {
		content     = local.rendered[each.key].oidc_config
		destination = "${var.docker_dir}/${each.key}/secrets/oidc_config.json"
	}

	provisioner "file" {
		content     = random_password.mariadb_password[each.key].result
		destination = "${var.docker_dir}/${each.key}/secrets/mariadb_password.txt"
	}

	provisioner "file" {
		content     = random_password.mariadb_root_password[each.key].result
		destination = "${var.docker_dir}/${each.key}/secrets/mariadb_root_password.txt"
	}

	provisioner "file" {
		content     = random_password.omeka_admin_password[each.key].result
		destination = "${var.docker_dir}/${each.key}/secrets/omeka_admin_password.txt"
	}

	provisioner "file" {
		content     = var.omeka_build_admin_email
		destination = "${var.docker_dir}/${each.key}/secrets/omeka_build_admin_email.txt"
	}

	provisioner "file" {
		content     = var.omeka_build_site_slug
		destination = "${var.docker_dir}/${each.key}/secrets/omeka_build_site_slug.txt"
	}

	provisioner "file" {
		content     = var.projects[each.key].omeka_admin_email
		destination = "${var.docker_dir}/${each.key}/secrets/omeka_admin_email.txt"
	}

	provisioner "file" {
		content     = var.projects[each.key].omeka_admin_user
		destination = "${var.docker_dir}/${each.key}/secrets/omeka_admin_user.txt"
	}

	provisioner "file" {
		content     = var.projects[each.key].omeka_project_title
		destination = "${var.docker_dir}/${each.key}/secrets/omeka_project_title.txt"
	}

	provisioner "file" {
		content     = var.projects[each.key].omeka_site_slug
		destination = "${var.docker_dir}/${each.key}/secrets/omeka_site_slug.txt"
	}

	provisioner "file" {
		content     = var.projects[each.key].omeka_site_title
		destination = "${var.docker_dir}/${each.key}/secrets/omeka_site_title.txt"
	}

	provisioner "file" {
		content     = local.rendered[each.key].compose
		destination = "${var.docker_dir}/${each.key}/compose.yml"
	}

	provisioner "file" {
		content     = local.rendered[each.key].php_conf
		destination = "${var.docker_dir}/${each.key}/cc-omeka.ini"
	}

	provisioner "file" {
		content     = local.rendered[each.key].caddyfile
		destination = "${var.caddy_dir}/${each.key}/Caddyfile"
	}

	provisioner "remote-exec" {
		inline = [
			"chmod 700 ${var.docker_dir}/${each.key}/secrets",
			"chmod 600 ${var.docker_dir}/${each.key}/secrets/*",
			"cd ${var.docker_dir}/${each.key} && docker compose -p ${each.key} up -d",
			"docker exec caddy caddy reload --config ${var.proxy_caddyfile}",
		]
	}
}


