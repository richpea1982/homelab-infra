resource "proxmox_virtual_environment_container" "wp_lxc" {
  node_name   = var.node
  vm_id       = var.vmid
  description = "WordPress LXC - ${var.hostname}"

  initialization {
    hostname = var.hostname

    network_interface {
      name     = "eth0"
      address  = "${var.ip}/24"
      gateway  = var.gateway
      vlan_id  = 20
    }
  }

  cpu {
    cores = var.cores
  }

  memory {
    dedicated = var.memory
  }

  disk {
    datastore_id = var.storage
    size         = var.disk_size
  }

  operating_system {
    template_file_id = var.template
    type             = "debian"
  }

  network_interface {
    name    = "eth0"
    bridge  = "vmbr1"
    vlan_id = 20
  }

  features {
    nesting = true
  }

  started = true
}
