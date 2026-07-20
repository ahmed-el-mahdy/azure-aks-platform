resource "azurerm_log_analytics_workspace" "aks" {
  name                = "${var.cluster_name}-law"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "PerGB2018"
  retention_in_days   = 30

  tags = var.tags
}

resource "azurerm_kubernetes_cluster" "main" {
  name                = var.cluster_name
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_prefix          = replace(var.cluster_name, "-", "")
  oidc_issuer_enabled = true

  default_node_pool {
    name                        = "system"
    temporary_name_for_rotation = "systemrot"
    node_count                  = var.enable_auto_scaling ? null : var.node_count
    vm_size                     = var.node_size
    vnet_subnet_id              = var.vnet_subnet_id
    os_disk_size_gb             = var.os_disk_size_gb

    enable_auto_scaling = var.enable_auto_scaling
    min_count           = var.enable_auto_scaling ? var.min_node_count : null
    max_count           = var.enable_auto_scaling ? var.max_node_count : null

    upgrade_settings {
      max_surge                     = var.max_surge
      drain_timeout_in_minutes      = 10
      node_soak_duration_in_minutes = 0
    }

    tags = var.tags
  }

  lifecycle {
    ignore_changes = [
      default_node_pool[0].node_count
    ]
  }

  identity {
    type = "SystemAssigned"
  }

  dynamic "azure_active_directory_role_based_access_control" {
    for_each = var.enable_aad_rbac ? [1] : []
    content {
      azure_rbac_enabled     = true
      admin_group_object_ids = var.admin_group_ids
    }
  }

  key_vault_secrets_provider {
    secret_rotation_enabled  = true
    secret_rotation_interval = "2m"
  }

  network_profile {
    network_plugin = "azure"
    network_policy = "calico"
    dns_service_ip = var.dns_service_ip
    service_cidr   = var.service_cidr
  }

  monitor_metrics {
    annotations_allowed = null
    labels_allowed      = null
  }

  oms_agent {
    log_analytics_workspace_id = azurerm_log_analytics_workspace.aks.id
  }

  tags = var.tags
}

# Role assignment for ACR pull
resource "azurerm_role_assignment" "aks_acr_pull" {
  count                = var.acr_id != null ? 1 : 0
  principal_id         = azurerm_kubernetes_cluster.main.kubelet_identity[0].object_id
  role_definition_name = "AcrPull"
  scope                = var.acr_id
}

# Role assignment for Key Vault Secrets User
resource "azurerm_role_assignment" "aks_kv_secrets" {
  count                = var.keyvault_id != null ? 1 : 0
  principal_id         = azurerm_kubernetes_cluster.main.key_vault_secrets_provider[0].secret_identity[0].object_id
  role_definition_name = "Key Vault Secrets User"
  scope                = var.keyvault_id
}
