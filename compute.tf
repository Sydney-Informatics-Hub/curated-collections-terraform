

resource "openstack_compute_instance_v2" "instance" {
    depends_on = [openstack_networking_router_interface_v2.attach]
    name = "${var.cc_prefix}-network-instance"
    image_name = var.vm_image
    flavor_name = var.vm_flavor
    key_pair = "Curated-Collections-SIH"
    security_groups = ["default", "ssh"]
    network {
        uuid = openstack_networking_network_v2.private_network.id
    }
    availability_zone = var.availability_zone
    user_data = templatefile("${path.module}/templates/cloud-init.yaml.tpl", {
        hostname = local.hostname
	proxy_caddyfile = var.proxy_caddyfile
        proxy_caddyfile_content = local.proxy_caddyfile_content
	proxy_docker = var.proxy_docker
        proxy_docker_content = local.proxy_docker_content
    })
}


#------- Floating IP------------------------------------
data "openstack_networking_port_v2" "port" {
  device_id = openstack_compute_instance_v2.instance.id
}
resource "openstack_networking_floatingip_v2" "floatip" {
  pool = var.ip_pool
  port_id = data.openstack_networking_port_v2.port.port_id
}

# Storage - note that this will still need to be formatted to be
# useful

resource "openstack_blockstorage_volume_v3" "volume" {
    name = "${var.cc_prefix}-storage"
    size = var.volume_size
    availability_zone = var.availability_zone
}

resource "openstack_compute_volume_attach_v2" "volume" {
    instance_id = openstack_compute_instance_v2.instance.id
    volume_id = openstack_blockstorage_volume_v3.volume.id
}
