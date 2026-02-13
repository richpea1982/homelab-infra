resource "proxmox_virtual_environment_container" "vaultwarden" {
  node_name = var.node
  vm_id     = var.vmid
  unprivileged = false

  operating_system {
    template_file_id = var.template
    type             = "debian"
  }

  initialization {
    hostname = var.hostname

    user_account {
      password = var.root_password
    }

    ip_config {
      ipv4 {
        address = "${var.ip}/24"
        gateway = var.gateway
      }
    }
  }

  network_interface {
    name   = "eth0"
    bridge = var.bridge
  }

  cpu {
    cores = var.cores
  }

  memory {
    dedicated = var.memory
    swap      = 512
  }

  disk {
    datastore_id = var.storage
    size         = var.disk
  }

  features {
    nesting = false
  }

  start_on_boot = true
}
