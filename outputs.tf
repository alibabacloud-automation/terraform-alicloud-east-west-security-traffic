# CEN
output "cen_instance_id" {
  description = "The id of CEN instance."
  value       = local.cen_instance_id
}

# TR
output "cen_transit_router_id" {
  description = "The id of CEN transit router."
  value       = local.cen_transit_router_id
}

# Business VPC
output "business_vpc_id" {
  value       = module.vpc[*].vpc_id
  description = "The ids of business vpc."
}

output "business_vpc_route_table_id" {
  value       = module.vpc[*].vpc_route_table_id
  description = "The route table id of business vpc."
}

output "business_vswitch_ids" {
  value       = module.vpc[*].vswitch_ids
  description = "The ids of business vswitches."
}

output "business_tr_vpc_attachment_id" {
  value       = module.vpc[*].tr_vpc_attachment_id
  description = "The id of attachment between TR and business VPC."
}


# Firewall VPC
output "firewall_vpc_id" {
  value       = alicloud_vpc.firewall_vpc.id
  description = "The ids of firewall vpc."
}

output "firewall_vswitch_id" {
  value       = alicloud_vswitch.firewall_vswitch.id
  description = "The route table id of firewall vpc."
}

output "firewall_tr_vswitch_ids" {
  value       = [for vsw in alicloud_vswitch.tr_vswitches : vsw.id]
  description = "The ids of firewall vswitches."
}

output "firewall_tr_vpc_attachment_id" {
  value       = alicloud_cen_transit_router_vpc_attachment.firewall_vpc.transit_router_attachment_id
  description = "The id of attachment between TR and firewall VPC."
}


# Firewall VPC Route Table
output "inbound_route_table_id" {
  value       = alicloud_route_table.firewall_vpc_inbound_route.id
  description = "The id of inbound route table of firewall VPC."
}

output "outbound_route_table_id" {
  value       = alicloud_route_table.firewall_vpc_outbound_route.id
  description = "The id of outbound route table of firewall VPC."
}

# TR Route Table
output "untrust_route_table_id" {
  value       = alicloud_cen_transit_router_route_table.untrust.transit_router_route_table_id
  description = "The id of untrust route table of transit router."
}

output "trust_route_table_id" {
  value       = alicloud_cen_transit_router_route_table.trust.transit_router_route_table_id
  description = "The id of trust route table of transit router."
}
