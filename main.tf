locals {
  cen_instance_id       = var.create_cen_instance ? alicloud_cen_instance.this[0].id : var.cen_instance_id
  cen_transit_router_id = var.create_cen_transit_router ? alicloud_cen_transit_router.this[0].transit_router_id : var.cen_transit_router_id
}

# CEN
resource "alicloud_cen_instance" "this" {
  count = var.create_cen_instance ? 1 : 0

  cen_instance_name = var.cen_instance_config.name
  description       = var.cen_instance_config.description
}

# TR
resource "alicloud_cen_transit_router" "this" {
  count = var.create_cen_transit_router ? 1 : 0

  transit_router_name = var.tr_config.name
  cen_id              = local.cen_instance_id
}


# VPCs
module "vpc" {
  source = "./modules/vpc"
  count  = length(var.vpcs)

  cen_instance_id       = local.cen_instance_id
  cen_transit_router_id = local.cen_transit_router_id

  vpc = var.vpcs[count.index]
}


# Firewall VPC
resource "alicloud_vpc" "firewall_vpc" {
  vpc_name   = var.firewall_vpc.vpc_name
  cidr_block = var.firewall_vpc.cidr_block
}

resource "alicloud_vswitch" "firewall_vswitch" {
  vpc_id     = alicloud_vpc.firewall_vpc.id
  cidr_block = var.firewall_vpc.firewall_vswitch.subnet
  zone_id    = var.firewall_vpc.firewall_vswitch.zone_id
}

resource "alicloud_vswitch" "tr_vswitches" {
  for_each = { for i, vsw in var.firewall_vpc.tr_vswitches : vsw.subnet => vsw }

  vpc_id     = alicloud_vpc.firewall_vpc.id
  cidr_block = each.key
  zone_id    = each.value.zone_id
}

resource "alicloud_cen_transit_router_vpc_attachment" "firewall_vpc" {
  cen_id                     = local.cen_instance_id
  transit_router_id          = local.cen_transit_router_id
  vpc_id                     = alicloud_vpc.firewall_vpc.id
  auto_publish_route_enabled = false

  dynamic "zone_mappings" {
    for_each = alicloud_vswitch.tr_vswitches
    content {
      zone_id    = zone_mappings.value.zone_id
      vswitch_id = zone_mappings.value.id
    }
  }
}

# inbound & outbound route table
resource "alicloud_route_table" "firewall_vpc_inbound_route" {
  vpc_id           = alicloud_vpc.firewall_vpc.id
  route_table_name = var.firewall_vpc.inbound_route_table_name
}
resource "alicloud_route_table" "firewall_vpc_outbound_route" {
  vpc_id           = alicloud_vpc.firewall_vpc.id
  route_table_name = var.firewall_vpc.outbound_route_table_name
}

resource "alicloud_route_table_attachment" "inbound" {
  for_each = alicloud_vswitch.tr_vswitches

  vswitch_id     = each.value.id
  route_table_id = alicloud_route_table.firewall_vpc_inbound_route.id
}

resource "alicloud_route_table_attachment" "outbound" {
  vswitch_id     = alicloud_vswitch.firewall_vswitch.id
  route_table_id = alicloud_route_table.firewall_vpc_outbound_route.id
}



# VPC to TR
resource "alicloud_route_entry" "vpc_default_route" {
  count = length(module.vpc)

  route_table_id        = module.vpc[count.index].vpc_route_table_id
  destination_cidrblock = "0.0.0.0/0"
  nexthop_type          = "Attachment"
  nexthop_id            = module.vpc[count.index].tr_vpc_attachment_id
}


# firewall VPC route
resource "alicloud_route_entry" "firewall_vpc_outbound_route" {
  route_table_id        = alicloud_vpc.firewall_vpc.route_table_id
  destination_cidrblock = "0.0.0.0/0"
  nexthop_type          = "Attachment"
  nexthop_id            = alicloud_cen_transit_router_vpc_attachment.firewall_vpc.transit_router_attachment_id
}

# TR untrust route table
resource "alicloud_cen_transit_router_route_table" "untrust" {
  transit_router_id                      = local.cen_transit_router_id
  transit_router_route_table_description = var.tr_config.untrust_route_table_description
}
resource "alicloud_cen_transit_router_route_table_association" "untrust" {
  count = length(module.vpc)

  transit_router_route_table_id = alicloud_cen_transit_router_route_table.untrust.transit_router_route_table_id
  transit_router_attachment_id  = module.vpc[count.index].tr_vpc_attachment_id
}

resource "alicloud_cen_transit_router_route_entry" "untrust" {
  transit_router_route_table_id                     = alicloud_cen_transit_router_route_table.untrust.transit_router_route_table_id
  transit_router_route_entry_destination_cidr_block = "0.0.0.0/0"
  transit_router_route_entry_next_hop_type          = "Attachment"
  transit_router_route_entry_next_hop_id            = alicloud_cen_transit_router_vpc_attachment.firewall_vpc.transit_router_attachment_id
}

# TR trust route table
resource "alicloud_cen_transit_router_route_table" "trust" {
  transit_router_id                      = local.cen_transit_router_id
  transit_router_route_table_description = var.tr_config.trust_route_table_description
}

resource "alicloud_cen_transit_router_route_table_association" "trust" {
  transit_router_route_table_id = alicloud_cen_transit_router_route_table.trust.transit_router_route_table_id
  transit_router_attachment_id  = alicloud_cen_transit_router_vpc_attachment.firewall_vpc.transit_router_attachment_id
}

resource "alicloud_cen_transit_router_route_table_propagation" "trust1" {
  count = length(module.vpc)

  transit_router_route_table_id = alicloud_cen_transit_router_route_table.trust.transit_router_route_table_id
  transit_router_attachment_id  = module.vpc[count.index].tr_vpc_attachment_id
}
