variable "node" {
  type        = string
  description = "Proxmox node name"
}

variable "hostname" {
  type        = string
  description = "LXC hostname"
}

variable "vmid" {
  type        = number
  description = "210"
}

variable "template" {
  type        = string
  description = "LXC template path (e.g. local:vztmpl/...)"
}

variable "storage" {
  type        = string
  description = "Proxmox storage name for rootfs"
}

variable "bridge" {
  type    = string
  default = "vmbr0"
}

variable "ip" {
  type        = string
  description = "Static IP address (without /24)"
}

variable "gateway" {
  type        = string
  description = "Gateway IP"
}

variable "cores" {
  type    = number
  default = 1
}

variable "memory" {
  type    = number
  default = 2048
}

variable "disk" {
  type    = number
  default = 15
}

variable "root_password" {
  type      = string
  sensitive = true
}
