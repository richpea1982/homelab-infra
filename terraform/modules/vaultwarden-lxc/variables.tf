variable "node" {
  type    = string
  default = "proxmox-srv"
}

variable "hostname" {
  type = string
}

variable "root_password" {
  type      = string
  sensitive = true
}

variable "ssh_public_key" {
  type      = string
  sensitive = true
}

variable "vmid" {
  type = number
}

variable "ip" {
  type = string
}

variable "gateway" {
  type    = string
  default = "10.40.0.1"
}

variable "cores" {
  type    = number
  default = 2
}

variable "memory" {
  type    = number
  default = 2048
}

variable "disk_size" {
  type    = number
  default = 15
}

variable "storage" {
  type    = string
  default = "local"
}

variable "template" {
  type    = string
  default = "local:vztmpl/debian-13-standard_13.1-2_amd64.tar.zst"
}
