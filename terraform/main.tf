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
  name      = var.ROUTER_NAME
  node_name = var.ROUTER_NODE
  vm_id     = var.ROUTER_VMID
  started   = true

  agent { enabled = true }
  cpu { cores = var.ROUTER_CORES }
  memory { dedicated = var.ROUTER_MEMORY }

  disk {
    datastore_id = var.ROUTER_STORAGE
    file_format  = "qcow2"
    interface    = "scsi0"
    size         = 8
  }

  # WAN: ISP router via VLAN10
  network_device {
    model   = "virtio"
    bridge  = "vmbr0"
    vlan_id = 10
  }

  # LAN: Homelab trunk (native VLAN10)
  network_device {
    model  = "virtio"
    bridge = "vmbr1"
  }

  # Boot from CDROM first (installer), then disk
  boot_order = ["ide2", "scsi0"]

  # ATTACH ISO - This is what you wanted
  cdrom {
    file_id   = var.ROUTER_ISO  # images:iso/vyos-2025.11-generic-amd64.iso
    interface = "ide2"
  }
}
