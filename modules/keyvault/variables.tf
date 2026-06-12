variable "project_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "location" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "tenant_id" {
  type = string
}

variable "allowed_subnet_ids" {
  type    = list(string)
  default = []
}

variable "enable_private_endpoint" {
  type    = bool
  default = true
}

variable "pe_subnet_id" {
  type    = string
  default = null
}

variable "tags" {
  type    = map(string)
  default = {}
}
