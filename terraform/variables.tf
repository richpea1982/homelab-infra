variable "PM_API_URL" {
  type = string
}

variable "PM_API_TOKEN_ID" {
  type = string
}

variable "PM_API_TOKEN_SECRET" {
  type      = string
  sensitive = true
}

variable "PM_API_PASSWORD" {
  type      = string
  sensitive = true
}

# -------------------------
# Router VM variables
# -------------------------

variable "ROUTER_NODE" {
  type    = string
  default = "proxmox-srv"
}

variable "ROUTER_NAME" {
  type    = string
  default = "router-vm"
}

variable "ROUTER_VMID" {
  type    = number
  default = 101
}

variable "ROUTER_ISO" {
  type    = string
  default = "vyos-1.5.iso"
}

variable "ROUTER_MEMORY" {
  type    = number
  default = 1024
}

variable "ROUTER_CORES" {
  type    = number
  default = 1
}

variable "ROUTER_STORAGE" {
  type    = string
  default = "local"
}

variable "ROUTER_SNIPPET" {
  type    = string
  default = "vyos-user-data.yaml"
}
