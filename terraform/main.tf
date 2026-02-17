terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "0.94.0"
    }
  }
}

provider "proxmox" {
  endpoint  = var.PM_API_URL
  api_token = "${var.PM_API_TOKEN_ID}=${var.PM_API_TOKEN_SECRET}"
  insecure  = true
}

# -------------------------
# Router VM (VyOS)
# -------------------------
resource "proxmox_virtual_environment_vm" "router" {
  name  = var.ROUTER_NAME
  node_name = var.ROUTER_NODE
  vm_id = var.ROUTER_VMID

  agent { enabled = true }

  cpu { cores = var.ROUTER_CORES }

  memory { dedicated = var.ROUTER_MEMORY }

  disk {
    datastore_id = var.ROUTER_STORAGE
    file_format  = "qcow2"
    interface    = "scsi0"
    size         = 8
  }

  network_device {
    model = "virtio"
    bridge = "vmbr0"
  }

  network_device {
    model = "virtio"
    bridge = "vmbr1"
  }

   # Boot order (CDROM first)
  boot_order = ["cdrom", "scsi0"]
  }

  cdrom {
    file_id = var.ROUTER_ISO
    interface = "ide3"
  }
}

