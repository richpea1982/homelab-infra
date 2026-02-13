terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "0.94.0"
    }
  }
}

provider "proxmox" {
  endpoint   = var.PM_API_URL
#  username   = "root@pam"
#  password   = var.PM_API_PASSWORD
  api_token  = "${var.PM_API_TOKEN_ID}=${var.PM_API_TOKEN_SECRET}"
  insecure   = true
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

#  host_storage  = "media-storage"

  ip            = "192.168.1.211"
  gateway       = "192.168.1.1"
  root_password = var.VAULTWARDEN_ROOT_PASSWORD
}
