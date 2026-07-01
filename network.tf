


# Network
resource "openstack_networking_network_v2" "private_network" {
  name = "${local.cc_prefix}-network"
}

# Subnet
resource "openstack_networking_subnet_v2" "subnet" {
  name       = "${local.cc_prefix}-subnet"
  network_id = openstack_networking_network_v2.private_network.id
  cidr       = "192.168.0.0/24"
  ip_version = 4
}

# Router
data "openstack_networking_network_v2" "external_network" {
  name = "ardc-syd"
}

resource "openstack_networking_router_v2" "router" {
  name                = "${local.cc_prefix}-router"
  external_network_id = data.openstack_networking_network_v2.external_network.id
}

resource "openstack_networking_router_interface_v2" "attach" {
  router_id = openstack_networking_router_v2.router.id
  subnet_id = openstack_networking_subnet_v2.subnet.id
}

