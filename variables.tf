# Use variables to customize the deployment

variable "root_id" {
  type    = string
  default = "Contoso-TF"
}

variable "root_name" {
  type    = string
  default = "Contoso Terraform LZ"
}

variable "deploy_connectivity_resources" {
  type    = bool
  default = true
}

variable "deploy_identity_resources" {
  type    = bool
  default = false
}

# This would be the primary location.
# Additional (secondary) lcoations can be specified as additional variables.
variable "default_location" {
  type    = string
  default = "eastus"
}

variable "connectivity_resources_tags" {
  type = map(string)
  default = {
  }
}
