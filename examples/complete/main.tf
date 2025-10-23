provider "alicloud" {
  region = "cn-zhangjiakou"
}

module "complete" {
  source = "../.."

  vpcs = [
    {
      vpc_name   = "vpc1",
      cidr_block = "172.16.0.0/24"
      vswitches = [{
        subnet  = "172.16.0.0/25"
        zone_id = "cn-zhangjiakou-a"
        }, {
        subnet  = "172.16.0.128/25"
        zone_id = "cn-zhangjiakou-b"
      }]
    },
    {
      vpc_name   = "vpc2",
      cidr_block = "192.168.0.0/24"
      vswitches = [{
        subnet  = "192.168.0.0/25"
        zone_id = "cn-zhangjiakou-a"
        }, {
        subnet  = "192.168.0.128/25"
        zone_id = "cn-zhangjiakou-b"
      }]
    }
  ]

  firewall_vpc = {
    cidr_block = "10.0.0.0/23"
    firewall_vswitch = {
      subnet  = "10.0.1.0/24"
      zone_id = "cn-zhangjiakou-a"
    }
    tr_vswitches = [{
      subnet  = "10.0.0.0/25"
      zone_id = "cn-zhangjiakou-a"
      }, {
      subnet  = "10.0.0.128/25"
      zone_id = "cn-zhangjiakou-b"
    }]
  }
}
