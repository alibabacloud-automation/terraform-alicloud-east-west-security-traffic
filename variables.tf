
# CEN
variable "create_cen_instance" {
  description = "Whether to create cen instance. If false, you can specify an existing cen instance by setting 'cen_instance_id'. Default to 'true'"
  type        = bool
  default     = true
}

variable "cen_instance_id" {
  description = "The id of an exsiting cen instance."
  type        = string
  default     = null
}

variable "cen_instance_config" {
  description = "The parameters of cen instance."
  type = object({
    name        = optional(string, "east-west-cen")
    description = optional(string, "east-west-cen")
  })
  default = {}
}

# TR
variable "create_cen_transit_router" {
  description = "Whether to create transit router. If false, you can specify an existing transit router by setting 'cen_transit_router_id'. Default to 'true'"
  type        = bool
  default     = true
}

variable "cen_transit_router_id" {
  description = "The transit router id of an existing transit router."
  type        = string
  default     = null
}

variable "tr_config" {
  description = "The parameters of transit router."
  type = object({
    name                            = optional(string, "east-west-tr")
    untrust_route_table_description = optional(string, "untrust")
    trust_route_table_description   = optional(string, "trust")
  })
  default = {}
}


# VPC
variable "vpcs" {
  description = "The parameters of vpc. The attribute 'cidr_block' is required."
  type = list(object({
    vpc_name   = optional(string, null)
    cidr_block = string
    vswitches = list(object({
      subnet  = string
      zone_id = string
    }))
  }))
  default = []
}


variable "firewall_vpc" {
  description = "The parameters of firewall vpc."
  type = object({
    vpc_name   = optional(string, "firewall-vpc")
    cidr_block = string
    firewall_vswitch = object({
      subnet  = string
      zone_id = string
    })
    tr_vswitches = list(object({
      subnet  = string
      zone_id = string
    }))
    inbound_route_table_name  = optional(string, "inbound")
    outbound_route_table_name = optional(string, "outbound")
  })
  default = {
    cidr_block = null
    firewall_vswitch = {
      subnet  = null
      zone_id = null
    }
    tr_vswitches = [{
      subnet  = null
      zone_id = null
      }, {
      subnet  = null
      zone_id = null
    }]
  }

  validation {
    condition     = length(var.firewall_vpc.tr_vswitches) == 2
    error_message = "The number of tr_vswitches must be 2"
  }
}

