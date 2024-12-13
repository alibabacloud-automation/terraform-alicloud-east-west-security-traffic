# CEN
variable "cen_instance_id" {
  description = "The id of cen instance."
  type        = string
  default     = null
}

# TR
variable "cen_transit_router_id" {
  description = "The id of cen transit router."
  type        = string
  default     = null
}


# VPC
variable "vpc" {
  description = "The parameters of vpc. The attribute 'cidr_block' is required."
  type = object({
    vpc_name   = optional(string, null)
    cidr_block = string
    vswitches = list(object({
      subnet  = string
      zone_id = string
    }))
  })
  default = {
    cidr_block = null
    vswitches  = []
  }
}

variable "tr_vpc_attachment_name" {
  description = "The name of the attachment between TR and VPC."
  type        = string
  default     = null
}


variable "resource_group_id" {
  description = "The ID of the resource group."
  type        = string
  default     = null
}

variable "tags" {
  description = "The tags of the resource."
  type        = any
  default     = {}
}
