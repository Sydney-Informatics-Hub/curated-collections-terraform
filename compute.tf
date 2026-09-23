

resource "openstack_compute_instance_v2" "instance" {
    depends_on = [openstack_networking_router_interface_v2.attach]
    name = "${local.cc_prefix}-network-instance"
    image_name = "NeCTAR Ubuntu 22.04 LTS (Jammy) amd64 (with Docker)"
    flavor_name = "m3.small"
    key_pair = "Curated-Collections-SIH"
    security_groups = ["default", "ssh"]
    network {
        uuid = openstack_networking_network_v2.private_network.id
    }
    availability_zone = "ardc-syd-1"
    user_data = templatefile("${path.module}/templates/cloud-init.yaml.tpl", {
        hostname = local.hostname
        mariadb_password = random_password.mariadb_password.result
        mariadb_root_password = random_password.mariadb_root_password.result
        omeka_admin_password = random_password.omeka_admin_password.result
        omeka_build_admin_email = local.omeka_build_admin_email
	omeka_build_site_slug = local.omeka_build_site_slug
        caddyfile_content = local.caddyfile_content
        docker_compose_content = local.docker_compose_content
	oidc_config_content = local.oidc_config_content
        omeka_admin_email = var.omeka_admin_email
        omeka_admin_user = var.omeka_admin_user
	omeka_project_title = var.omeka_project_title
        omeka_site_slug = var.omeka_site_slug
        omeka_site_title = var.omeka_site_title
    })
}


#------- Floating IP------------------------------------
data "openstack_networking_port_v2" "port" {
  device_id = openstack_compute_instance_v2.instance.id
}
resource "openstack_networking_floatingip_v2" "floatip" {
  pool = "ardc-syd"
  port_id = data.openstack_networking_port_v2.port.port_id
}


