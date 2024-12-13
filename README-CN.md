Terraform module to build east-west security traffic network for Alibaba Cloud

terraform-alicloud-east-west-security-traffic
======================================

[English](https://github.com/alibabacloud-automation/terraform-alicloud-east-west-security-traffic/blob/main/README.md) | 简体中文

在传统数据中心网络中的做法都是部署大量的安全设备组建一个安全域来实现企业系统的安全防护和访问控制，网络流量需要按照业务逻辑和安全防护等级穿过安全域内的不同设备，这就是所谓的服务链（Service Chain）。如今在公共云上部署的实例、容器或微服务之间的互访流量也需要延续相同的安全策略，比如同一个区域的不同VPC之间，VPC和IDC之间等，流量通过安全产品实现基于规则的检测和防护，降低企业内网安全威胁。  
操作流程简介：
- 创建业务VPC*2和安全VPC以及配置相关VSW和路由表
- 创建云企业网CEN实例以及转发路由器TR
- 配置TR的VPC连接，并通过TR多路由表实现向安全VPC的引流和回注路由配置

架构图:

![image](https://raw.githubusercontent.com/alibabacloud-automation/terraform-alicloud-east-west-security-traffic/main/scripts/diagram-CN.png)


## 用法


```hcl
provider "alicloud" {
  region = "cn-hangzhou"
}

module "complete" {
  source = alibabacloud-automation/east-west-security-traffic/alicloud

  vpcs = [
    {
      vpc_name   = "vpc1",
      cidr_block = "172.16.0.0/24"
      vswitches = [{
        subnet  = "172.16.0.0/25"
        zone_id = "cn-hangzhou-j"
        }, {
        subnet  = "172.16.0.128/25"
        zone_id = "cn-hangzhou-k"
      }]
    },
    {
      vpc_name   = "vpc2",
      cidr_block = "192.168.0.0/24"
      vswitches = [{
        subnet  = "192.168.0.0/25"
        zone_id = "cn-hangzhou-j"
        }, {
        subnet  = "192.168.0.128/25"
        zone_id = "cn-hangzhou-k"
      }]
    }
  ]

  firewall_vpc = {
    cidr_block = "10.0.0.0/23"
    firewall_vswitch = {
      subnet  = "10.0.1.0/24"
      zone_id = "cn-hangzhou-j"
    }
    tr_vswitches = [{
      subnet  = "10.0.0.0/25"
      zone_id = "cn-hangzhou-j"
      }, {
      subnet  = "10.0.0.128/25"
      zone_id = "cn-hangzhou-k"
    }]
  }
}
```

## 示例

* [完整示例](https://github.com/alibabacloud-automation/terraform-alicloud-east-west-security-traffic/tree/main/examples/complete)

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_alicloud"></a> [alicloud](#provider\_alicloud) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_vpc"></a> [vpc](#module\_vpc) | ./modules/vpc | n/a |

## Resources

| Name | Type |
|------|------|
| [alicloud_cen_instance.this](https://registry.terraform.io/providers/hashicorp/alicloud/latest/docs/resources/cen_instance) | resource |
| [alicloud_cen_transit_router.this](https://registry.terraform.io/providers/hashicorp/alicloud/latest/docs/resources/cen_transit_router) | resource |
| [alicloud_cen_transit_router_route_entry.untrust](https://registry.terraform.io/providers/hashicorp/alicloud/latest/docs/resources/cen_transit_router_route_entry) | resource |
| [alicloud_cen_transit_router_route_table.trust](https://registry.terraform.io/providers/hashicorp/alicloud/latest/docs/resources/cen_transit_router_route_table) | resource |
| [alicloud_cen_transit_router_route_table.untrust](https://registry.terraform.io/providers/hashicorp/alicloud/latest/docs/resources/cen_transit_router_route_table) | resource |
| [alicloud_cen_transit_router_route_table_association.trust](https://registry.terraform.io/providers/hashicorp/alicloud/latest/docs/resources/cen_transit_router_route_table_association) | resource |
| [alicloud_cen_transit_router_route_table_association.untrust](https://registry.terraform.io/providers/hashicorp/alicloud/latest/docs/resources/cen_transit_router_route_table_association) | resource |
| [alicloud_cen_transit_router_route_table_propagation.trust1](https://registry.terraform.io/providers/hashicorp/alicloud/latest/docs/resources/cen_transit_router_route_table_propagation) | resource |
| [alicloud_cen_transit_router_vpc_attachment.firewall_vpc](https://registry.terraform.io/providers/hashicorp/alicloud/latest/docs/resources/cen_transit_router_vpc_attachment) | resource |
| [alicloud_route_entry.firewall_vpc_outbound_route](https://registry.terraform.io/providers/hashicorp/alicloud/latest/docs/resources/route_entry) | resource |
| [alicloud_route_entry.vpc_default_route](https://registry.terraform.io/providers/hashicorp/alicloud/latest/docs/resources/route_entry) | resource |
| [alicloud_route_table.firewall_vpc_inbound_route](https://registry.terraform.io/providers/hashicorp/alicloud/latest/docs/resources/route_table) | resource |
| [alicloud_route_table.firewall_vpc_outbound_route](https://registry.terraform.io/providers/hashicorp/alicloud/latest/docs/resources/route_table) | resource |
| [alicloud_route_table_attachment.inbound](https://registry.terraform.io/providers/hashicorp/alicloud/latest/docs/resources/route_table_attachment) | resource |
| [alicloud_route_table_attachment.outbound](https://registry.terraform.io/providers/hashicorp/alicloud/latest/docs/resources/route_table_attachment) | resource |
| [alicloud_vpc.firewall_vpc](https://registry.terraform.io/providers/hashicorp/alicloud/latest/docs/resources/vpc) | resource |
| [alicloud_vswitch.firewall_vswitch](https://registry.terraform.io/providers/hashicorp/alicloud/latest/docs/resources/vswitch) | resource |
| [alicloud_vswitch.tr_vswitches](https://registry.terraform.io/providers/hashicorp/alicloud/latest/docs/resources/vswitch) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cen_instance_config"></a> [cen\_instance\_config](#input\_cen\_instance\_config) | The parameters of cen instance. | <pre>object({<br>    name        = optional(string, "east-west-cen")<br>    description = optional(string, "east-west-cen")<br>  })</pre> | `{}` | no |
| <a name="input_cen_instance_id"></a> [cen\_instance\_id](#input\_cen\_instance\_id) | The id of an exsiting cen instance. | `string` | `null` | no |
| <a name="input_cen_transit_router_id"></a> [cen\_transit\_router\_id](#input\_cen\_transit\_router\_id) | The transit router id of an existing transit router. | `string` | `null` | no |
| <a name="input_create_cen_instance"></a> [create\_cen\_instance](#input\_create\_cen\_instance) | Whether to create cen instance. If false, you can specify an existing cen instance by setting 'cen\_instance\_id'. Default to 'true' | `bool` | `true` | no |
| <a name="input_create_cen_transit_router"></a> [create\_cen\_transit\_router](#input\_create\_cen\_transit\_router) | Whether to create transit router. If false, you can specify an existing transit router by setting 'cen\_transit\_router\_id'. Default to 'true' | `bool` | `true` | no |
| <a name="input_firewall_vpc"></a> [firewall\_vpc](#input\_firewall\_vpc) | The parameters of firewall vpc. | <pre>object({<br>    vpc_name   = optional(string, "firewall-vpc")<br>    cidr_block = string<br>    firewall_vswitch = object({<br>      subnet  = string<br>      zone_id = string<br>    })<br>    tr_vswitches = list(object({<br>      subnet  = string<br>      zone_id = string<br>    }))<br>    inbound_route_table_name  = optional(string, "inbound")<br>    outbound_route_table_name = optional(string, "outbound")<br>  })</pre> | <pre>{<br>  "cidr_block": null,<br>  "firewall_vswitch": {<br>    "subnet": null,<br>    "zone_id": null<br>  },<br>  "tr_vswitches": [<br>    {<br>      "subnet": null,<br>      "zone_id": null<br>    },<br>    {<br>      "subnet": null,<br>      "zone_id": null<br>    }<br>  ]<br>}</pre> | no |
| <a name="input_tr_config"></a> [tr\_config](#input\_tr\_config) | The parameters of transit router. | <pre>object({<br>    name                            = optional(string, "east-west-tr")<br>    untrust_route_table_name        = optional(string, "untrust")<br>    untrust_route_table_description = optional(string, "untrust")<br>    trust_route_table_name          = optional(string, "trust")<br>    trust_route_table_description   = optional(string, "trust")<br>  })</pre> | `{}` | no |
| <a name="input_vpcs"></a> [vpcs](#input\_vpcs) | The parameters of vpc. The attribute 'cidr\_block' is required. | <pre>list(object({<br>    vpc_name   = optional(string, null)<br>    cidr_block = string<br>    vswitches = list(object({<br>      subnet  = string<br>      zone_id = string<br>    }))<br>  }))</pre> | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_business_tr_vpc_attachment_id"></a> [business\_tr\_vpc\_attachment\_id](#output\_business\_tr\_vpc\_attachment\_id) | The id of attachment between TR and business VPC. |
| <a name="output_business_vpc_id"></a> [business\_vpc\_id](#output\_business\_vpc\_id) | The ids of business vpc. |
| <a name="output_business_vpc_route_table_id"></a> [business\_vpc\_route\_table\_id](#output\_business\_vpc\_route\_table\_id) | The route table id of business vpc. |
| <a name="output_business_vswitch_ids"></a> [business\_vswitch\_ids](#output\_business\_vswitch\_ids) | The ids of business vswitches. |
| <a name="output_cen_instance_id"></a> [cen\_instance\_id](#output\_cen\_instance\_id) | The id of CEN instance. |
| <a name="output_cen_transit_router_id"></a> [cen\_transit\_router\_id](#output\_cen\_transit\_router\_id) | The id of CEN transit router. |
| <a name="output_firewall_tr_vpc_attachment_id"></a> [firewall\_tr\_vpc\_attachment\_id](#output\_firewall\_tr\_vpc\_attachment\_id) | The id of attachment between TR and firewall VPC. |
| <a name="output_firewall_tr_vswitch_ids"></a> [firewall\_tr\_vswitch\_ids](#output\_firewall\_tr\_vswitch\_ids) | The ids of firewall vswitches. |
| <a name="output_firewall_vpc_id"></a> [firewall\_vpc\_id](#output\_firewall\_vpc\_id) | The ids of firewall vpc. |
| <a name="output_firewall_vswitch_id"></a> [firewall\_vswitch\_id](#output\_firewall\_vswitch\_id) | The route table id of firewall vpc. |
| <a name="output_inbound_route_table_id"></a> [inbound\_route\_table\_id](#output\_inbound\_route\_table\_id) | The id of inbound route table of firewall VPC. |
| <a name="output_outbound_route_table_id"></a> [outbound\_route\_table\_id](#output\_outbound\_route\_table\_id) | The id of outbound route table of firewall VPC. |
| <a name="output_trust_route_table_id"></a> [trust\_route\_table\_id](#output\_trust\_route\_table\_id) | The id of trust route table of transit router. |
| <a name="output_untrust_route_table_id"></a> [untrust\_route\_table\_id](#output\_untrust\_route\_table\_id) | The id of untrust route table of transit router. |
<!-- END_TF_DOCS -->

## 提交问题

如果在使用该 Terraform Module 的过程中有任何问题，可以直接创建一个 [Provider Issue](https://github.com/aliyun/terraform-provider-alicloud/issues/new)，我们将根据问题描述提供解决方案。

**注意:** 不建议在该 Module 仓库中直接提交 Issue。

## 作者

Created and maintained by Alibaba Cloud Terraform Team(terraform@alibabacloud.com).

## 许可

MIT Licensed. See LICENSE for full details.

## 参考

* [Terraform-Provider-Alicloud Github](https://github.com/aliyun/terraform-provider-alicloud)
* [Terraform-Provider-Alicloud Release](https://releases.hashicorp.com/terraform-provider-alicloud/)
* [Terraform-Provider-Alicloud Docs](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs)
