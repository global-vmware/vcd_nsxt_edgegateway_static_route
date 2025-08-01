terraform {
  required_version = "~> 1.5.7"

  required_providers {
    vcd = {
      source  = "vmware/vcd"
      version = "~> 3.10"
    }
  }
}