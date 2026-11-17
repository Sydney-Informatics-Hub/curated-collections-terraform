
# this assumes that we only have one zone

data "openstack_dns_zone_v2" "zone" {}

# Each project gets an A record pointing to the instance's
# IP - the caddy proxy then routes requests to the correct
# Omeka S

# note the trailing '.' on the hostname, this is not a typo

resource "openstack_dns_recordset_v2" "dns_a_record" {
  for_each = var.projects
  zone_id = data.openstack_dns_zone_v2.zone.id
  name = "${local.rendered[each.key].full_domain}."
  type = "A"
  ttl = 300
  records = [openstack_networking_floatingip_v2.floatip.address]
}


