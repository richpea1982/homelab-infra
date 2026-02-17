kterraform {
  required_version = ">= 1.6.0"
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

  # WAN: untagged uplink to ISP router (192.168.1.0/24)
  # No vlan_id here — ISP router does not speak 802.1Q
  network_device {
    model       = "virtio"
    bridge      = "vmbr0"
    mac_address = "BC:24:11:3E:4C:87"
  }

  # LAN: VLAN trunk to internal homelab (vmbr1 must have bridge-vlan-aware yes)
  # VyOS will create sub-interfaces: eth1.10, eth1.20, eth1.30, eth1.40
  network_device {
    model       = "virtio"
    bridge      = "vmbr1"
    mac_address = "BC:24:11:DB:87:71"
  }

  # Boot from ISO first, then disk
  # After VyOS is installed: set enabled = false and re-apply
  boot_order = ["ide2", "scsi0"]

  cdrom {
    enabled   = true
    file_id   = var.ROUTER_ISO # e.g. images:iso/vyos-2025.11-generic-amd64.iso
    interface = "ide2"
  }

  # Prevents Terraform from destroying/recreating the VM
  # after VyOS installs and changes internal state (boot order,
  # agent fingerprint, etc.)
  lifecycle {
    ignore_changes = [
      cdrom,
      boot_order,
      agent,
    ]
  }
}
