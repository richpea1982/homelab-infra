variable "node" {
  type    = string
  default = "proxmox-srv"
}

variable "hostname" {
  type = string
}

variable "vmid" {
  type = number
}

variable "ip" {
  type = string
}

variable "gateway" {
  type    = string
  default = "10.20.0.1"
}

variable "cores" {
  type    = number
  default = 1
}

variable "memory" {
  type    = number
  default = 1024
}

variable "disk_size" {
  type    = number
  default = 10
}

variable "storage" {
  type    = string
  default = "local"
}

variable "template" {
  type    = string
  default = "local:vztmpl/debian-12-standard_12.7-1_amd64.tar.zst"
}
