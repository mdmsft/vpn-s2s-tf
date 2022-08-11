output "gateway_address" {
  value = azurerm_public_ip.gateway.ip_address
}

output "local_network_address_space" {
  value = var.virtual_network_address_space
}

output "connection_shared_key" {
  value = local.connection_shared_key
}
