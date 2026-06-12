variable "project_name" { type = string }
variable "environment" { type = string }
variable "location" { type = string }
variable "resource_group_name" { type = string }
variable "publisher_name" { type = string }
variable "publisher_email" { type = string }

variable "sku_name" {
  type    = string
  default = "Developer_1"
}

variable "vnet_type" {
  description = "None, External, or Internal"
  type        = string
  default     = "Internal"
}

variable "apim_subnet_id" {
  type    = string
  default = null
}

variable "rate_limit_calls" {
  type    = number
  default = 100
}

variable "rate_limit_period" {
  type    = number
  default = 60
}

variable "tags" {
  type    = map(string)
  default = {}
}
