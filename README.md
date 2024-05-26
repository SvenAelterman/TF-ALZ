# Sample Terraform code for Azure Landing Zone deployment

> **NOTE**: This repo is not meant to be cloned or forked and used for ALZ deployments. It's meant only to be a reference for Terraform HCL syntax and using the CAF ALZ module's outputs.
>
> For sample code, see <https://github.com/Azure/terraform-azurerm-caf-enterprise-scale/wiki>

## What's here?

- Multi-subscription support through multiple `azurerm` provider definitions.
- Sample connectivity settings to deploy a hub network, VPN gateway, and DNS zones.
- Sample Local Network Gateway and VPN Connection resources (outside of ALZ Deployment).
