resource "proxmox_virtual_environment_container" "smb" {
  node_name    = var.node
  vm_id        = var.vmid
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

  # Bind mounts for each folder
  # mount_point {
  #   volume = "/storage/Photos"
  #   path   = "/mnt/photos"
  # }
  #
  # mount_point {
  #   volume = "/storage/Music"
  #   path   = "/mnt/music"
  # }
  #
  # mount_point {
  #   volume = "/storage/DVDs"
  #   path   = "/mnt/dvds"
  # }
  #
  # mount_point {
  #   volume = "/storage/file-share"
  #   path   = "/mnt/share"
  # }

  features {
    nesting = false
  }

  start_on_boot = true
}
