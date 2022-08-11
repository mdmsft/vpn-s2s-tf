resource "random_string" "shared_key" {
  length  = 128
  special = false
}

locals {
  connection_shared_key = coalesce(var.connection_shared_key, random_string.shared_key.result)
}

resource "azurerm_public_ip" "gateway" {
  name                = "pip-${local.resource_suffix}-vgw"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  allocation_method   = "Static"
  sku                 = "Standard"
  public_ip_prefix_id = azurerm_public_ip_prefix.main.id
}

resource "azurerm_virtual_network_gateway" "main" {
  name                = "vgw-${local.resource_suffix}"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  sku                 = var.gateway_sku
  type                = "Vpn"
  vpn_type            = "RouteBased"
  active_active       = var.gateway_active_active
  enable_bgp          = var.gateway_enable_bgp
  generation          = var.gateway_generation

  ip_configuration {
    name                          = "default"
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.gateway.id
    subnet_id                     = azurerm_subnet.gateway.id
  }

  timeouts {
    create = "60m"
  }
}

resource "azurerm_local_network_gateway" "main" {
  name                = "lgw-${local.resource_suffix}"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  gateway_address     = var.gateway_address
  address_space       = [var.local_network_address_space]
}

resource "azurerm_virtual_network_gateway_connection" "main" {
  name                       = "con-${local.resource_suffix}"
  location                   = azurerm_resource_group.main.location
  resource_group_name        = azurerm_resource_group.main.name
  type                       = "IPsec"
  virtual_network_gateway_id = azurerm_virtual_network_gateway.main.id
  local_network_gateway_id   = azurerm_local_network_gateway.main.id
  shared_key                 = local.connection_shared_key
}
