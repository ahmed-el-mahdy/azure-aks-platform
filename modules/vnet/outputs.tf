output "hub_vnet_id" {
  value = azurerm_virtual_network.hub.id
}

output "spoke_vnet_id" {
  value = azurerm_virtual_network.spoke.id
}

output "aks_subnet_id" {
  value = azurerm_subnet.aks.id
}

output "appgw_subnet_id" {
  value = azurerm_subnet.appgw.id
}

output "apim_subnet_id" {
  value = azurerm_subnet.apim.id
}

output "firewall_subnet_id" {
  value = azurerm_subnet.firewall.id
}

output "pe_subnet_id" {
  value = azurerm_subnet.private_endpoints.id
}
