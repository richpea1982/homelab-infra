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

variable "VAULTWARDEN_ROOT_PASSWORD" {
  type      = string
  sensitive = true
}
