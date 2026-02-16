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
resource "proxmox_vm_qemu" "router" {
  name        = var.ROUTER_NAME
  vmid        = var.ROUTER_VMID
  node        = var.ROUTER_NODE
  onboot      = true
  agent       = 1

  cores       = var.ROUTER_CORES
  memory      = var.ROUTER_MEMORY

  scsihw      = "virtio-scsi-pci"

  disk {
    slot    = 0
    size    = "8G"
    type    = "scsi"
    storage = var.ROUTER_STORAGE
  }

  # WAN NIC (home LAN)
  network {
    model  = "virtio"
    bridge = "vmbr0"
  }

  # LAN trunk NIC (VLANs)
  network {
    model  = "virtio"
    bridge = "vmbr1"
  }

  # Boot from VyOS ISO
  cdrom = "local:iso/${var.ROUTER_ISO}"

  # Cloud-init snippet
  cicustom = "user=local:snippets/${var.ROUTER_SNIPPET}"

  os_type = "cloud-init"
}

# -------------------------
# Vaultwarden LXC
# -------------------------
module "vaultwarden" {
  source = "./modules/vaultwarden-lxc"

  node          = "proxmox-srv"
  hostname      = "vaultwarden"
  vmid          = 210
  template      = "local:vztmpl/debian-13-standard_13.1-2_amd64.tar.zst"
  storage       = "local"

  ip            = "192.168.1.210"
  gateway       = "192.168.1.1"
  root_password = var.VAULTWARDEN_ROOT_PASSWORD
}

# -------------------------
# SMB LXC
# -------------------------
module "smb" {
  source = "./modules/smb-lxc"

  node          = "proxmox-srv"
  hostname      = "smb-share"
  vmid          = 211
  template      = "local:vztmpl/debian-13-standard_13.1-2_amd64.tar.zst"
  storage       = "local"

  ip            = "192.168.1.211"
  gateway       = "192.168.1.1"
  root_password = var.VAULTWARDEN_ROOT_PASSWORD
}
