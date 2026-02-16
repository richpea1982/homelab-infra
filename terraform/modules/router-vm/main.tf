terraform {
  required_providers {
    proxmox = {
      source  = "Telmate/proxmox"
      version = "2.9.14"
    }
  }
}

resource "proxmox_vm_qemu" "router" {
  name        = var.router_name
  target_node = var.proxmox_node

  cores  = var.router_cores
  memory = var.router_memory

  onboot = true
  agent  = 1

  disk {
    type    = "scsi"
    storage = var.router_storage
    size    = "8G"
  }

  scsihw = "virtio-scsi-pci"

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
