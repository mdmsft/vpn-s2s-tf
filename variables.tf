variable "project" {
  type    = string
  default = "contoso"
}

variable "location" {
  type = object({
    name = string
    code = string
  })
  default = {
    name = "westeurope"
    code = "weu"
  }
}

variable "environment" {
  type    = string
  default = "dev"
}

variable "tenant_id" {
  type = string
}

variable "subscription_id" {
  type = string
}

variable "virtual_network_address_space" {
  type    = string
  default = "172.16.0.0/16"
}

variable "subnet_bits" {
  type    = number
  default = 8
}

variable "bastion_scale_units" {
  type    = number
  default = 2
}

variable "jumphost_computer_name" {
  type    = string
  default = "jumphost"
}

variable "jumphost_admin_username" {
  type    = string
  default = "azure"
}

variable "jumphost_size" {
  type    = string
  default = "Standard_B4ms"
}

variable "jumphost_image_reference" {
  type    = string
  default = "Canonical:0001-com-ubuntu-server-jammy:22_04-lts-gen2:latest"
}

variable "public_key_path" {
  type = string
}

variable "gateway_sku" {
  type    = string
  default = "VpnGw2"
}

variable "gateway_active_active" {
  type    = bool
  default = false
}

variable "gateway_enable_bgp" {
  type    = bool
  default = false
}

variable "gateway_generation" {
  type    = string
  default = "Generation2"
}

variable "gateway_address" {
  type    = string
  default = "1.2.3.4"
}

variable "local_network_address_space" {
  type    = string
  default = "192.168.255.0/24"
}

variable "connection_shared_key" {
  type     = string
  nullable = true
  validation {
    condition     = length(var.connection_shared_key) >= 1 && length(var.connection_shared_key) <= 128
    error_message = "Shared key must be 1..128 ASCII characters long"
  }
}
