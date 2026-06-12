output "apim_id" {
  value = azurerm_api_management.main.id
}

output "apim_gateway_url" {
  value = azurerm_api_management.main.gateway_url
}

output "apim_private_ip" {
  value = azurerm_api_management.main.private_ip_addresses
}

output "apim_identity_principal_id" {
  value = azurerm_api_management.main.identity[0].principal_id
}
