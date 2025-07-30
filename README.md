# VCD NSX-T Edgegateway Static Route Terraform Module

This Terraform module will deploy NSX-T edgegateway static route into an existing VMware Cloud Director (VCD) Environment. This module can be used to provision new static routes into [Rackspace Technology SDDC Flex](https://www.rackspace.com/cloud/private/software-defined-data-center-flex) VCD Data Center Regions.

## Requirements

| Name      | Version |
|-----------|---------|
| terraform | ~> 1.6  |
| vcd       | ~> 3.10 |

## Resources

| Name                                                                 | Type         |
|----------------------------------------------------------------------|--------------|
| [vcd_vdc_group](https://registry.terraform.io/providers/vmware/vcd/3.10.0/docs/data-sources/vdc_group) | data source |
| [vcd_nsxt_edgegateway](https://registry.terraform.io/providers/vmware/vcd/3.10.0/docs/data-sources/nsxt_edgegateway) | data source |
| [vcd_network_routed_v2](https://registry.terraform.io/providers/vmware/vcd/3.10.0/docs/data-sources/network_routed_v2) | data source |
| [vcd_external_network_v2](https://registry.terraform.io/providers/vmware/vcd/3.10.0/docs/data-sources/external_network_v2) | data source |
| [vcd_nsxt_edgegateway_static_route](https://registry.terraform.io/providers/vmware/vcd/3.10.0/docs/resources/nsxt_edgegateway_static_route)| resource |

## Inputs

| Name            | Description                                                      | Type | Default | Required |
|-----------------|------------------------------------------------------------------|------|---------|----------|
| vdc_org_name | The name of the Data Center Group Organization in VCD | string | `"Organization Name Format: <Account_Number>-<Region>-<Account_Name>"` | yes |
| vdc_group_name | The name of the Data Center Group in VCD | string | `"Data Center Group Name Format: <Account_Number>-<Region>-<Account_Name> <datacenter group>"` | yes |
| vdc_edge_name | The name of the NSX-T Edge Gateway in VCD | string | `"Edge Gateway Name Format: <Account_Number>-<Region>-<Edge_GW_Identifier>-<edge>"` | yes |
| name | Name for NSX-T Edge Gateway Static Route | string | N/A | yes |
| description | Description for NSX-T Edge Gateway Static Route | string | null | no |
| network_cidr | Specifies network prefix in CIDR format. Both IPv4 and IPv6 formats are supported | string | N/A | yes |
| next_hops | A set of next hops to use within the static route. At least one is required | list(object) | N/A | yes |
|ip_address|IP address for next hop gateway IP Address for the Static Route|string|N/A|yes|
|admin_distance|Admin distance is used to choose which route to use when there are multiple routes for a specific network. The lower the admin distance, the higher the preference for the route. Starts with 1|number|N/A|yes|
|network_name|ID of Org VDC network or segment backed external network|string|N/A|yes if scope is required, else no|
|network_type|Type of backing entity. In general this will be NETWORK but can become SYSTEM_OWNED if the Static Route is modified outside of VCD|string|N/A|yes if scope is required and networ_name is defined, else no|

## Outputs

| Name             | Description                              |
|------------------|------------------------------------------|
| static_route_id  | ID for static route that were creared    |

## Example Usage

This is an example of a `main.tf` file that uses the `"github.com/global-vmware/vcd_nsxt_edgegateway_static_route"` Module source to create NSX-T edgegateway static route in a VMware Cloud Director environment:

```terraform

module "vcd_nsxt_edgegateway_static_route" {
  source            = "github.com/global-vmware/vcd_nsxt_edgegateway_static_route.git?ref=v1.0.0"
  vdc_org_name      = "<VDC-ORG-NAME>"
  vdc_group_name    = "<VDC-GRP-NAME>"
  vdc_edge_name     = "<VDC-EDGE-NAME>"
  vcd_url = "<VCD-URL>"
  vdc_name = "<VDC-NAME>"
  name = "my-static-route"
  description = "My static Route"
  network_cidr = "10.0.0.0/8"
  next_hops = [
    {
      ip_address = "10.224.16.68"
      admin_distance = 1
      network_name = "internal-network"
      network_type = "NETWORK"
    },
    {
      ip_address = "10.224.16.69"
      admin_distance = 2
    }
  ]  
}
```

## Authors

This module is maintained by the [Global VMware Cloud Automation Services Team](https://github.com/global-vmware).