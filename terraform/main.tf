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
  name      = var.ROUTER_NAME        # ← OK
  node_name = var.ROUTER_NODE        # ← node → node_name
  vm_id     = var.ROUTER_VMID        # ← vmid → vm_id

  agent {
    enabled = true                   # ← agent = 1 → agent block
  }

  cpu {
    cores = var.ROUTER_CORES         # ← cores → cpu.cores
  }

  memory {
    dedicated = var.ROUTER_MEMORY    # ← memory → memory.dedicated
  }

  disk {
    datastore_id = var.ROUTER_STORAGE
    file_format  = "qcow2"
    interface    = "scsi0" 
    size         = 8
  }

  scsihw = "virtio-scsi-single"

  network_device {
    bridge_id = "vmbr0"
    model     = "virtio"
  }

  network_device {
    bridge_id = "vmbr1"
    model     = "virtio"
  }

  cdrom {
    datastore_id = "local"
    file_id      = var.ROUTER_ISO
  }

  cloud_init {
    snippets = [var.ROUTER_SNIPPET]
  }

  start_after_create = true
}

