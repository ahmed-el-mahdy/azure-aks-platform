variable "cluster_name" {
  description = "Name of the AKS cluster"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "resource_group_name" {
  description = "Resource group name"
  type        = string
}

variable "vnet_subnet_id" {
  description = "Subnet ID for AKS nodes"
  type        = string
}

variable "node_size" {
  description = "VM size for default node pool"
  type        = string
  default     = "Standard_D4s_v5"
}

variable "node_count" {
  description = "Static node count (used when autoscaling disabled)"
  type        = number
  default     = 3
}

variable "enable_auto_scaling" {
  description = "Enable cluster autoscaler"
  type        = bool
  default     = true
}

variable "min_node_count" {
  description = "Minimum nodes when autoscaling enabled"
  type        = number
  default     = 1
}

variable "max_node_count" {
  description = "Maximum nodes when autoscaling enabled"
  type        = number
  default     = 7
}

variable "os_disk_size_gb" {
  description = "OS disk size in GB"
  type        = number
  default     = 128
}

variable "max_surge" {
  description = "Max surge for node upgrades"
  type        = string
  default     = "33%"
}

variable "enable_aad_rbac" {
  description = "Enable Azure AD RBAC integration"
  type        = bool
  default     = true
}

variable "admin_group_ids" {
  description = "AAD group object IDs for cluster admin"
  type        = list(string)
  default     = []
}

variable "dns_service_ip" {
  description = "DNS service IP for the cluster"
  type        = string
  default     = "10.1.0.10"
}

variable "service_cidr" {
  description = "Service CIDR for Kubernetes services"
  type        = string
  default     = "10.1.0.0/16"
}

variable "acr_id" {
  description = "ACR resource ID for AcrPull role assignment"
  type        = string
  default     = null
}

variable "keyvault_id" {
  description = "Key Vault resource ID for secrets access"
  type        = string
  default     = null
}

variable "tags" {
  description = "Resource tags"
  type        = map(string)
  default     = {}
}
