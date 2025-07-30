# Create the Datacenter Group data source
data "vcd_vdc_group" "dcgroup" {
  org   = var.vdc_org_name
  name  = var.vdc_group_name
}

# Create the NSX-T Edge Gateway data source
data "vcd_nsxt_edgegateway" "egw" {
  org      = var.vdc_org_name
  owner_id = data.vcd_vdc_group.dcgroup.id
  name     = var.vdc_edge_name
}

# Create the routed organisation network data source for next_hop scope
data "vcd_network_routed_v2" "routed_net" {
  for_each = {
    for nh in var.next_hops : nh.network_name => nh
    if (try(nh.network_type, null) == "NETWORK")
  }
  name = each.value.network_name
  org = var.vdc_org_name
  edge_gateway_id = data.vcd_nsxt_edgegateway.egw.id
}

# Create the external network data source for next_hop scope
data "vcd_external_network_v2" "ext_net" {
  for_each = {
    for nh in var.next_hops : nh.network_name => nh
    if (try(nh.network_type, null) == "SYSTEM_OWNED")
  }
  name = each.value.network_name
}

resource "vcd_nsxt_edgegateway_static_route" "static_route" {
  edge_gateway_id = data.vcd_nsxt_edgegateway.egw.id
  name = var.name
  network_cidr = var.network_cidr
  description = var.description
  dynamic "next_hop" {
    for_each = local.final_next_hops
    content {
      ip_address = next_hop.value.ip_address
      admin_distance = next_hop.value.admin_distance

      dynamic "scope" {
        for_each = next_hop.value.scope != null ? [1] : []
        content {
          id = next_hop.value.scope.id
          type = next_hop.value.scope.type
        }
      }
    }
  }
}