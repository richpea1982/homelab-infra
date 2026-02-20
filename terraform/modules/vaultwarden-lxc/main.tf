terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "0.94.0"
    }
  }
}

resource "proxmox_virtual_environment_container" "vaultwarden_lxc" {
  node_name   = var.node
  vm_id       = var.vmid
  description = "WordPress LXC - ${var.hostname}"
  started     = true
  unprivileged = true

  initialization {
    hostname = var.hostname

  user_account {
    password = var.root_password
    keys     = [var.ssh_public_key]
  }

    ip_config {
      ipv4 {
        address = "${var.ip}/24"
        gateway = var.gateway
      }
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
    bridge  = "vmbr0"
    vlan_id = 40
  }

  features {
    nesting = true
#    keyctl  = true
#    fuse    = true
  }
}
