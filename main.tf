# Get the current client configuration from the AzureRM provider.
# This is used to populate the root_parent_id variable with the
# current Tenant ID used as the ID for the "Tenant Root Group"
# Management Group.

# Declare the Azure landing zones Terraform module
# and provide a base configuration.

module "enterprise_scale" {
  source  = "Azure/caf-enterprise-scale/azurerm"
  version = ">= 5.0.3, < 5.1.0" # change this to your desired version, https://www.terraform.io/language/expressions/version-constraints

  default_location = local.location

  providers = {
    azurerm              = azurerm
    azurerm.connectivity = azurerm.connectivity
    azurerm.management   = azurerm.management
  }

  root_parent_id = data.azurerm_client_config.core.tenant_id
  root_id        = var.root_id
  root_name      = var.root_name

  deploy_core_landing_zones   = true
  deploy_corp_landing_zones   = false
  deploy_online_landing_zones = false
  deploy_sap_landing_zones    = false

  subscription_id_identity     = "05bca35e-0dfa-455a-a4eb-9f9ea72df723" # Quick Tests - Throwaways (10)
  subscription_id_management   = data.azurerm_client_config.management.subscription_id
  subscription_id_connectivity = data.azurerm_client_config.connectivity.subscription_id

  deploy_connectivity_resources = var.deploy_connectivity_resources
  deploy_identity_resources     = var.deploy_identity_resources

  configure_management_resources   = {}
  configure_identity_resources     = {}
  configure_connectivity_resources = local.configure_connectivity_resources

  disable_telemetry = true
}
