# Production environment — full security + HA
project_name = "myplatform"
environment  = "prod"
location     = "uaenorth"

# Networking
hub_address_space        = "10.0.0.0/16"
spoke_address_space      = "10.1.0.0/16"
aks_subnet_cidr          = "10.1.0.0/20"
enable_private_endpoints = true

# AKS — production capacity
aks_node_size          = "Standard_D8s_v5"
aks_enable_autoscaling = true
aks_min_nodes          = 3
aks_max_nodes          = 10
enable_aad_rbac        = true

# ACR — Premium for geo-replication
acr_sku = "Premium"

# APIM — Internal mode behind App Gateway
apim_publisher_name  = "Platform Team"
apim_publisher_email = "platform@example.com"
apim_sku             = "Premium_1"
apim_vnet_type       = "Internal"
