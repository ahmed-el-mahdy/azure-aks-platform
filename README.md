# Azure AKS Platform — Terraform Modules

Production-grade Terraform modules for deploying a complete Azure Kubernetes platform with APIM, Key Vault, networking, and observability.

![Terraform](https://img.shields.io/badge/Terraform-1.5+-623CE4?logo=terraform)
![Azure](https://img.shields.io/badge/Azure-AKS%20%7C%20APIM%20%7C%20KV-0078D4?logo=microsoftazure)
![License](https://img.shields.io/badge/License-MIT-green)

## Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                        Azure Subscription                        │
├──────────────────────────────────────┬──────────────────────────┤
│  Hub VNet (10.0.0.0/16)             │  Spoke VNet (10.1.0.0/16)│
│  ┌──────────┐  ┌──────────────┐    │  ┌─────────────────────┐ │
│  │ Firewall │  │ App Gateway  │    │  │  AKS Cluster        │ │
│  │ Subnet   │  │ + WAF v2     │    │  │  ├─ System Pool     │ │
│  └──────────┘  └──────────────┘    │  │  └─ User Pool       │ │
│                                      │  └─────────────────────┘ │
│  ┌──────────────────────────────┐   │  ┌──────────┐  ┌───────┐│
│  │  Azure API Management       │   │  │ Key Vault│  │ ACR   ││
│  │  (internal + external GW)   │   │  └──────────┘  └───────┘│
│  └──────────────────────────────┘   │                          │
├─────────────────────────────────────┴──────────────────────────┤
│  Observability: Log Analytics → App Insights → Grafana          │
└─────────────────────────────────────────────────────────────────┘
```

## Module Structure

```
modules/
├── aks/                    # AKS cluster with autoscaling + RBAC
├── api_management/         # APIM instance + policies
├── application_gateway/    # App Gateway with WAF v2
├── container_registry/     # ACR with geo-replication
├── firewall/              # Azure Firewall with rules
├── keyvault/              # Key Vault + access policies
├── network_security_group/ # NSG rules for each subnet
├── observability/         # Log Analytics + App Insights
├── redis/                 # Azure Cache for Redis
├── storage_account/       # Storage for Terraform state
└── vnet/                  # Hub-spoke VNet peering
```

## Quick Start

```bash
# 1. Initialize backend
cd environments/dev
terraform init

# 2. Plan
terraform plan -var-file="terraform.tfvars"

# 3. Apply
terraform apply -var-file="terraform.tfvars"
```

## Environments

| Environment | Purpose | Node Size | Autoscaling |
|------------|---------|-----------|-------------|
| `dev` | Development & testing | Standard_B4ms | 1-3 nodes |
| `qa` | QA validation | Standard_D4s_v5 | 2-5 nodes |
| `staging` | Pre-production | Standard_D4s_v5 | 2-5 nodes |
| `prod` | Production | Standard_D8s_v5 | 3-10 nodes |

## Features

- **AKS**: OIDC issuer, Key Vault CSI, Calico network policy, autoscaling
- **Networking**: Hub-spoke topology, VNet peering, private endpoints
- **Security**: Azure Firewall, WAF v2, NSG rules, managed identity
- **APIM**: Internal mode + App Gateway frontend, rate limiting, JWT validation
- **Observability**: Log Analytics, App Insights, Prometheus metrics
- **State**: Remote state in Azure Storage with locking

## Usage Example

```hcl
module "aks" {
  source = "./modules/aks"

  cluster_name        = "myplatform-${var.environment}-aks"
  location            = var.location
  resource_group_name = azurerm_resource_group.main.name
  vnet_subnet_id      = module.vnet.aks_subnet_id

  node_size           = var.aks_node_size
  enable_auto_scaling = true
  min_node_count      = var.aks_min_nodes
  max_node_count      = var.aks_max_nodes

  enable_aad_rbac     = true
  admin_group_ids     = [var.aks_admin_group_id]
}
```

## Prerequisites

- Terraform >= 1.5
- Azure CLI >= 2.50
- Azure subscription with Contributor + User Access Administrator
- Service Principal or Managed Identity for CI/CD

## License

MIT
