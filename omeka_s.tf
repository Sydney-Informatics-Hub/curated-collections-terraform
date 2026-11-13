
resource "terraform_data" "project" {
  for_each = var.projects

  # Re-run whenever this project's rendered config changes
  triggers_replace = sha256(jsonencode(local.rendered[each.key]))

  connection {
    type        = "ssh"
    host        = openstack_networking_floatingip_v2.vm.address
    user        = "ubuntu"
    private_key = file(var.ssh_private_key_path)
  }


  provisioner "remote-exec" {
    inline = [
	"sudo mkdir -p /srv/projects/${each.key}",
        "sudo chown ubuntu /srv/projects/${each.key}",
	"sudo mkdir -p /srv/caddy/sites/${each.key}",
        "sudo chown ubuntu /srv/caddy/sites/${each.key}"
	]
  }
  provisioner "file" {
    content     = local.rendered[each.key].compose
    destination = "/srv/projects/${each.key}/compose.yml"
  }
  provisioner "file" {
    content     = local.rendered[each.key].env
    destination = "/srv/projects/${each.key}/.env"
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
