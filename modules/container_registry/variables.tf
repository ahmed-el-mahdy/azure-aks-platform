variable "project_name" { type = string }
variable "environment" { type = string }
variable "location" { type = string }
variable "resource_group_name" { type = string }

variable "sku" {
  type    = string
  default = "Standard"
}

variable "geo_replication_locations" {
  type    = list(string)
  default = []
}

variable "tags" {
  type    = map(string)
  default = {}
}
