

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
}


#------- Floating IP------------------------------------
data "openstack_networking_port_v2" "port" {
  device_id = openstack_compute_instance_v2.instance.id
}
resource "openstack_networking_floatingip_v2" "floatip" {
  pool = "ardc-syd"
  port_id = data.openstack_networking_port_v2.port.port_id
}

