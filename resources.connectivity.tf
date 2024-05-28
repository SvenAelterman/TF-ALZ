# Sample file to define additional connectivity resources, such as a VPN connection and local network gateway
# This is not part of the ALZ deployment, but is an example of how to extend the deployment with additional resources.

resource "azurerm_local_network_gateway" "lng" {
  # Specifying an aliased provider with each resource is critical, otherwise it will default to the unaliased provider.bgp_settings {
  provider = azurerm.connectivity

  name                = "${var.root_id}-Datacenter-prod-lng-${lower(var.default_location)}-01"
  resource_group_name = local.virtual_network_by_location[local.location].resource_group_name
  location            = local.location
  gateway_address     = "12.13.14.15"
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_virtual_network_gateway_connection" "datacenter_connection" {
  provider = azurerm.connectivity

  name                = "${var.root_id}-Datacenter-prod-conn-${lower(var.default_location)}-01"
  location            = local.location
  resource_group_name = local.virtual_network_gateway_by_location[local.location].resource_group_name

  type                       = "IPsec"
  virtual_network_gateway_id = local.virtual_network_gateway_by_location[local.location].id
  local_network_gateway_id   = azurerm_local_network_gateway.lng.id

  shared_key = azurerm_key_vault_secret.vpn_shared_key.value

  # Define IPsec settings in ipsec_policy block
}

# Create a resource group for the Key Vault
resource "azurerm_resource_group" "security" {
  provider = azurerm.connectivity

  name     = "${var.root_id}-security"
  location = local.location
}


# Create an Azure Key Vault to store the shared key
resource "azurerm_key_vault" "connectivity_kv" {
  provider = azurerm.connectivity

  name     = "Contoso-DC-prd-kv-eus-1"
  location = local.location

  # Create a new resource group for this
  resource_group_name = azurerm_resource_group.security.name
  tenant_id           = data.azurerm_client_config.connectivity.tenant_id

  # For demo purposes only. For production, always enable purge protection and set retention to 90 days (or more).
  purge_protection_enabled   = true
  soft_delete_retention_days = 90

  enable_rbac_authorization = true
  sku_name                  = "standard"
}

# Create an RBAC role assignment to access the Key Vault by the user running the script
resource "azurerm_role_assignment" "kv_rbac" {
  scope                = azurerm_key_vault.connectivity_kv.id
  role_definition_name = "Key Vault Administrator"
  principal_id         = data.azurerm_client_config.connectivity.object_id
}

# Generate a random VPN shared key
resource "random_password" "vpn_shared_key" {
  length      = 20
  special     = true
  min_special = 2
  min_upper   = 2
  min_lower   = 2
  min_numeric = 2
}

# Store the VPN connection's sample shared key
resource "azurerm_key_vault_secret" "vpn_shared_key" {
  provider = azurerm.connectivity

  name         = "vpn-shared-key"
  value        = random_password.vpn_shared_key.result
  key_vault_id = azurerm_key_vault.connectivity_kv.id

  expiration_date = "2034-12-31T23:59:59Z"

  depends_on = [azurerm_role_assignment.kv_rbac]
}

locals {
  # Perform a friendly mapping of virtual network resources by location, per 
  # https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/wiki/%5BUser-Guide%5D-Module-Outputs#re-mapping-with-friendly-keys
  virtual_network_by_location = { for k, v in module.enterprise_scale.azurerm_virtual_network.connectivity :
    v.location => v
  }

  virtual_network_gateway_by_location = { for k, v in module.enterprise_scale.azurerm_virtual_network_gateway.connectivity :
    v.location => v
  }
}
