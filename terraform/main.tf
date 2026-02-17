terraform {
  required_version = ">= 1.6.0"

backend "s3" {
    bucket   = "terraform-state"
    key      = "homelab/router/terraform.tfstate"
    region   = "us-east-1"

    endpoints = {
      s3 = "http://docker-srv:9000"
    }

    skip_credentials_validation  = true
    skip_metadata_api_check      = true
    skip_region_validation       = true
    skip_requesting_account_id   = true
    force_path_style             = true
  }

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

  # VyOS does not ship with qemu-guest-agent
  agent { enabled = false }

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

  # To rebuild: set file_id back to var.ROUTER_ISO and add "ide2" to boot_order
  boot_order = ["scsi0"]

  cdrom {
    file_id   = "none"
    interface = "ide2"
  }

  lifecycle {
    ignore_changes = [
      cdrom,
      boot_order,
      agent,
    ]
  }
}
