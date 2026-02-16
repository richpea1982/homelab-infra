terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "0.94.0"
    }
  }
}

resource "proxmox_vm_qemu" "router" {
  name        = var.router_name
  vmid        = var.router_vmid
  node        = var.proxmox_node

  cores       = var.router_cores
  memory      = var.router_memory

  onboot      = true
  agent       = 1

  scsihw      = "virtio-scsi-pci"

  disk {
    slot    = 0
    size    = "8G"
    type    = "scsi"
    storage = var.router_storage
  }

  # WAN NIC (home LAN)
  network {
    model  = "virtio"
    bridge = var.wan_bridge
  }

  # LAN trunk NIC
  network {
    model  = "virtio"
    bridge = var.lan_bridge
  }

  cdrom   = "${var.iso_storage}:iso/${var.router_iso}"
  os_type = "cloud-init"

  cicustom = "user=${var.snippet_storage}:snippets/${var.vyos_user_data}"
}
