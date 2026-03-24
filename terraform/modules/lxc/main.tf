resource "proxmox_virtual_environment_container" "lxc" {
  node_name   = var.node
  vm_id       = var.vmid
  description = "${var.hostname} LXC"
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
    vlan_id = var.vlan_id
  }

  features {
    nesting = true
    keyctl  = var.keyctl
    fuse    = var.fuse
  }

  # Optional mount point — now correctly inside the resource
  dynamic "mount_point" {
    for_each = var.mount_mp != null && var.mount_source != null ? [1] : []
    content {
      mp      = var.mount_mp
      source  = var.mount_source
      type    = var.mount_type
      options = var.mount_options
    }
  }
}
