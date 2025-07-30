variable "vdc_org_name" {}

variable "vdc_edge_name" {}

variable "vdc_group_name" {}

variable "name" {
  type = string
  description = "Static route name"
}

variable "description" {
  type = string
  description = "Description for static route"
  default = ""
}

variable "network_cidr" {
  type = string
  description = "Destination network (CIDR)"
}

variable "next_hops" {
  description = "List of next hop objects with optional scope object"
  type = list(object({
    ip_address = string
    admin_distance = number
    network_name = optional(string)
    network_type = optional(string) #Must be defined if network_name is given
  }))
}