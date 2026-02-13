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
  description = "Container VMID"
}

variable "template" {
  type        = string
  description = "Template file ID (e.g. local:vztmpl/debian_12_standard_12.2-1_amd64.tar.zst)"
}

variable "storage" {
  type        = string
  description = "Storage for rootfs (e.g. local)"
}

#variable "host_storage" {
#  type        = string
#  description = "Storage pool for bind mount (e.g. media-storage)"
#}


variable "bridge" {
  type    = string
  default = "vmbr0"
}

variable "ip" {
  type        = string
  description = "Static IP without CIDR"
}

variable "gateway" {
  type        = string
  description = "Gateway IP"
}

variable "cores" {
  type    = number
  default = 2
}

variable "memory" {
  type    = number
  default = 4096
}

variable "disk" {
  type    = number
  default = 8
}

variable "root_password" {
  type      = string
  sensitive = true
}
