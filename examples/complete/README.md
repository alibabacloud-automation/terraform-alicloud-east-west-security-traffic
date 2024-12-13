
# Complete

Configuration in this directory create CEN, TR and 2 business VPCs and 1 security VPC.

## Usage

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Note that this example may create resources which cost money. Run `terraform destroy` when you don't need these resources.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_complete"></a> [complete](#module\_complete) | ../.. | n/a |

## Resources

No resources.

## Inputs

No inputs.

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