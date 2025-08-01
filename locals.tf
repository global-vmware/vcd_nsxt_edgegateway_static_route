locals {
  final_next_hops = [
    for nh in var.next_hops : {
        ip_address = nh.ip_address
        admin_distance = nh.admin_distance
        scope = (
            try(nh.network_type, null) == "NETWORK" ?
            {
                id = data.vcd_network_routed_v2.routed_net[nh.network_name].id
                type = "NETWORK"
            } :
            try(nh.network_type, null) == "SYSTEM_OWNED" ?
            {
                id = data.vcd_external_network_v2.ext_net[nh.network_name].id
                type = "SYSTEM_OWNED"
            } : null
        )
    }
  ]
}