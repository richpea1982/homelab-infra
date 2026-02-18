terraform {
  required_version = ">= 1.6.0"

  backend "s3" {
    bucket   = "terraform-state"
    key      = "homelab/terraform.tfstate"
    region   = "us-east-1"
    endpoints = {
      s3 = "http://docker-srv:9000"
    }
    skip_credentials_validation = true
    skip_metadata_api_check     = true
    skip_region_validation      = true
    skip_requesting_account_id  = true
    use_path_style              = true
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

  # -------------------------
  # BOOT / CDROM
  # -------------------------
  # NORMAL OPERATION — boot from disk only
  boot_order = ["scsi0"]
  cdrom {
    file_id   = "none"
    interface = "ide2"
  }

  # REBUILD MODE — uncomment below and comment out the two lines above
  # boot_order = ["ide2", "scsi0"]
  # cdrom {
  #   file_id   = var.ROUTER_ISO  # images:iso/vyos-2025.11-generic-amd64.iso
  #   interface = "ide2"
  # }

  lifecycle {
    ignore_changes = [
      cdrom,
      boot_order,
      agent,
    ]
  }
}

# -------------------------
# WordPress LXCs - VLAN20
# -------------------------
module "richweb" {
  source    = "./modules/wp-lxc"
  hostname  = "richweb"
  vmid      = 210
  ip        = "10.20.0.10"
}

module "petitsanglais" {
  source    = "./modules/wp-lxc"
  hostname  = "petitsanglais"
  vmid      = 211
  ip        = "10.20.0.11"
}

module "esperance" {
  source    = "./modules/wp-lxc"
  hostname  = "esperance"
  vmid      = 212
  ip        = "10.20.0.12"
}
