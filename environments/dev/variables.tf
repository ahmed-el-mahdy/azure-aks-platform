variable "project_name" {
  type    = string
  default = "myplatform"
}

variable "environment" {
  type    = string
  default = "dev"
}

variable "location" {
  type    = string
  default = "uaenorth"
}

variable "tenant_id" {
  type        = string
  description = "Azure AD Tenant ID"
}

# Networking
variable "hub_address_space" {
  type    = string
  default = "10.0.0.0/16"
}

variable "spoke_address_space" {
  type    = string
  default = "10.1.0.0/16"
}

variable "aks_subnet_cidr" {
  type    = string
  default = "10.1.0.0/20"
}

variable "enable_private_endpoints" {
  type    = bool
  default = false
}

# AKS
variable "aks_node_size" {
  type    = string
  default = "Standard_B4ms"
}

variable "aks_enable_autoscaling" {
  type    = bool
  default = true
}

variable "aks_min_nodes" {
  type    = number
  default = 1
}

variable "aks_max_nodes" {
  type    = number
  default = 3
}

variable "enable_aad_rbac" {
  type    = bool
  default = true
}

variable "aks_admin_group_ids" {
  type    = list(string)
  default = []
}

# ACR
variable "acr_sku" {
  type    = string
  default = "Standard"
}

# APIM
variable "apim_publisher_name" {
  type    = string
  default = "Platform Team"
}

variable "apim_publisher_email" {
  type    = string
  default = "platform@example.com"
}

variable "apim_sku" {
  type    = string
  default = "Developer_1"
}

variable "apim_vnet_type" {
  type    = string
  default = "None"
}
