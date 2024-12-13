resource "alicloud_vpc" "this" {
  cidr_block        = var.vpc.cidr_block
  vpc_name          = var.vpc.vpc_name
  resource_group_id = var.resource_group_id
  tags              = var.tags
}


resource "alicloud_vswitch" "this" {
  count = length(var.vpc.vswitches)

  vpc_id       = alicloud_vpc.this.id
  zone_id      = var.vpc.vswitches[count.index].zone_id
  cidr_block   = var.vpc.vswitches[count.index].subnet
  vswitch_name = "${var.vpc.vpc_name}_VSW${count.index + 1}"
  tags         = var.tags
}

resource "alicloud_cen_transit_router_vpc_attachment" "this" {
  cen_id            = var.cen_instance_id
  transit_router_id = var.cen_transit_router_id
  vpc_id            = alicloud_vpc.this.id
  dynamic "zone_mappings" {
    for_each = alicloud_vswitch.this
    content {
      zone_id    = zone_mappings.value.zone_id
      vswitch_id = zone_mappings.value.id
    }
  }
  transit_router_vpc_attachment_name = var.tr_vpc_attachment_name
  auto_publish_route_enabled         = false
  tags                               = var.tags
}

