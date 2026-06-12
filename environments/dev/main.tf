terraform {
  required_version = ">= 1.5.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.80"
    }
  }

  backend "azurerm" {
    # Configure per environment in backend.hcl
    # terraform init -backend-config=backend.hcl
  }
}

provider "azurerm" {
  features {
    key_vault {
      purge_soft_delete_on_destroy = false
    }
  }
}

locals {
  environment = var.environment
  project     = var.project_name

  common_tags = {
    Environment = local.environment
    Project     = local.project
    ManagedBy   = "terraform"
    Repository  = "azure-aks-platform"
  }
}

resource "azurerm_resource_group" "main" {
  name     = "${local.project}-${local.environment}-rg"
  location = var.location
  tags     = local.common_tags
}

# ─── Networking ───────────────────────────────────────────────
module "vnet" {
  source = "../../modules/vnet"

  project_name        = local.project
  environment         = local.environment
  location            = var.location
  resource_group_name = azurerm_resource_group.main.name
  hub_address_space   = var.hub_address_space
  spoke_address_space = var.spoke_address_space
  aks_subnet_cidr     = var.aks_subnet_cidr
  tags                = local.common_tags
}

# ─── Container Registry ──────────────────────────────────────
module "acr" {
  source = "../../modules/container_registry"

  project_name        = local.project
  environment         = local.environment
  location            = var.location
  resource_group_name = azurerm_resource_group.main.name
  sku                 = var.acr_sku
  tags                = local.common_tags
}

# ─── Key Vault ────────────────────────────────────────────────
module "keyvault" {
  source = "../../modules/keyvault"

  project_name            = local.project
  environment             = local.environment
  location                = var.location
  resource_group_name     = azurerm_resource_group.main.name
  tenant_id               = var.tenant_id
  allowed_subnet_ids      = [module.vnet.aks_subnet_id]
  enable_private_endpoint = var.enable_private_endpoints
  pe_subnet_id            = module.vnet.pe_subnet_id
  tags                    = local.common_tags
}

# ─── AKS Cluster ─────────────────────────────────────────────
module "aks" {
  source = "../../modules/aks"

  cluster_name        = "${local.project}-${local.environment}-aks"
  location            = var.location
  resource_group_name = azurerm_resource_group.main.name
  vnet_subnet_id      = module.vnet.aks_subnet_id

  node_size           = var.aks_node_size
  enable_auto_scaling = var.aks_enable_autoscaling
  min_node_count      = var.aks_min_nodes
  max_node_count      = var.aks_max_nodes

  enable_aad_rbac = var.enable_aad_rbac
  admin_group_ids = var.aks_admin_group_ids

  acr_id      = module.acr.acr_id
  keyvault_id = module.keyvault.keyvault_id

  tags = local.common_tags
}

# ─── API Management ──────────────────────────────────────────
module "apim" {
  source = "../../modules/api_management"

  project_name        = local.project
  environment         = local.environment
  location            = var.location
  resource_group_name = azurerm_resource_group.main.name
  publisher_name      = var.apim_publisher_name
  publisher_email     = var.apim_publisher_email
  sku_name            = var.apim_sku
  vnet_type           = var.apim_vnet_type
  apim_subnet_id      = module.vnet.apim_subnet_id
  tags                = local.common_tags
}
