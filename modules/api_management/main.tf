resource "azurerm_api_management" "main" {
  name                = "${var.project_name}-${var.environment}-apim"
  location            = var.location
  resource_group_name = var.resource_group_name
  publisher_name      = var.publisher_name
  publisher_email     = var.publisher_email
  sku_name            = var.sku_name

  virtual_network_type = var.vnet_type

  dynamic "virtual_network_configuration" {
    for_each = var.vnet_type != "None" ? [1] : []
    content {
      subnet_id = var.apim_subnet_id
    }
  }

  identity {
    type = "SystemAssigned"
  }

  tags = var.tags
}

# Global policy — rate limiting + JWT validation
resource "azurerm_api_management_policy" "global" {
  api_management_id = azurerm_api_management.main.id
  xml_content       = <<XML
<policies>
  <inbound>
    <rate-limit calls="${var.rate_limit_calls}" renewal-period="${var.rate_limit_period}" />
    <cors>
      <allowed-origins>
        <origin>*</origin>
      </allowed-origins>
      <allowed-methods preflight-result-max-age="300">
        <method>GET</method>
        <method>POST</method>
        <method>PUT</method>
        <method>DELETE</method>
        <method>PATCH</method>
      </allowed-methods>
      <allowed-headers>
        <header>*</header>
      </allowed-headers>
    </cors>
  </inbound>
  <backend>
    <forward-request />
  </backend>
  <outbound />
  <on-error />
</policies>
XML
}
