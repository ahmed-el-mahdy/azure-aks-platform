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

variable "hub_address_space" {
  type    = string
  default = "10.0.0.0/16"
}

variable "spoke_address_space" {
  type    = string
  default = "10.1.0.0/16"
}

variable "firewall_subnet_cidr" {
  type    = string
  default = "10.0.1.0/24"
}

variable "appgw_subnet_cidr" {
  type    = string
  default = "10.0.2.0/24"
}

variable "apim_subnet_cidr" {
  type    = string
  default = "10.0.3.0/24"
}

variable "aks_subnet_cidr" {
  type    = string
  default = "10.1.0.0/20"
}

variable "pe_subnet_cidr" {
  type    = string
  default = "10.1.16.0/24"
}

variable "tags" {
  type    = map(string)
  default = {}
}
