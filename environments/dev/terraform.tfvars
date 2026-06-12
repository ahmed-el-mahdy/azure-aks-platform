# Dev environment — cost-optimized
project_name = "myplatform"
environment  = "dev"
location     = "uaenorth"

# Networking
hub_address_space        = "10.0.0.0/16"
spoke_address_space      = "10.1.0.0/16"
aks_subnet_cidr          = "10.1.0.0/20"
enable_private_endpoints = false

# AKS — minimal for dev
aks_node_size          = "Standard_B4ms"
aks_enable_autoscaling = true
aks_min_nodes          = 1
aks_max_nodes          = 3
enable_aad_rbac        = true

# ACR
acr_sku = "Standard"

# APIM — dev uses external (no VNet integration)
apim_publisher_name  = "Platform Team"
apim_publisher_email = "platform@example.com"
apim_sku             = "Developer_1"
apim_vnet_type       = "None"
