
# this assumes that we only have one zone

data "openstack_dns_zone_v2" "zone" {}

resource "openstack_dns_recordset_v2" "dns_a_record" {
  zone_id = data.openstack_dns_zone_v2.zone.id
  name = "${local.hostname}."
  type = "A"
  ttl = 300
  records = [openstack_networking_floatingip_v2.floatip.address]
}
