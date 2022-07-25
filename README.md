# azr-tf-example-firewall-network

[Terraform](https://www.terraform.io) Example to build a **Virtual Network Setup with an Azure Firewall**

- Virutal Network (VNET)
- NAT Gateway
- Private DNS Zone
- Network Security Group
- Route Table
- Bastion Host

<!-- BEGIN_TF_DOCS -->
## Prerequisites

- [Terraform](https://releases.hashicorp.com/terraform/) v0.12+

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | >=3.0.0 |

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >=3.0.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_bastion_host"></a> [bastion\_host](#module\_bastion\_host) | github.com/N3tLiX/tf-modules//bastionhost | n/a |
| <a name="module_firewall"></a> [firewall](#module\_firewall) | github.com/N3tLiX/tf-modules//firewall | n/a |
| <a name="module_network"></a> [network](#module\_network) | github.com/N3tLiX/modules//vnet | n/a |
| <a name="module_nsg"></a> [nsg](#module\_nsg) | github.com/N3tLiX/modules//nsg | n/a |
| <a name="module_privatednszone"></a> [privatednszone](#module\_privatednszone) | github.com/N3tLiX/modules//privatednszone | n/a |
| <a name="module_rt"></a> [rt](#module\_rt) | github.com/N3tLiX/modules//rt | n/a |
| <a name="module_rules_AzureBastionSubnet"></a> [rules\_AzureBastionSubnet](#module\_rules\_AzureBastionSubnet) | github.com/N3tLiX/tf-modules//nsg | n/a |

## Resources

| Name | Type |
|------|------|
| [azurerm_firewall_policy_rule_collection_group.azure_policy](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/firewall_policy_rule_collection_group) | resource |
| [azurerm_firewall_policy_rule_collection_group.sn-endpoint](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/firewall_policy_rule_collection_group) | resource |
| [azurerm_resource_group.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [azurerm_client_config.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |
| [azurerm_resource_group.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) | data source |

## Inputs

No inputs.

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_basion"></a> [basion](#output\_basion) | Basiton Host Module Settings (deployed). |
| <a name="output_nat"></a> [nat](#output\_nat) | NAT Gateway Module Settings (deployed). |
| <a name="output_network"></a> [network](#output\_network) | VNET Module Settings (deployed). |
| <a name="output_nsgs"></a> [nsgs](#output\_nsgs) | NSG Module Settings (deployed). |
| <a name="output_privatednszone"></a> [privatednszone](#output\_privatednszone) | Private DNZ Zone Module Settings (deployed). |
| <a name="output_route_tables"></a> [route\_tables](#output\_route\_tables) | Route Table Module Settings (deployed). |

## Variables

```hcl
locals {
  resource_group_name      = "rg-example-network"
  location                 = "westeurope"
  vnet_name                = "vn-example"
  address_space            = ["10.1.255.0/24", "192.168.255.0/24"]
  dns_servers              = ["192.168.255.4"]
  private_dns_zone_name    = "example.azure.novonordisk.com"
  firewall_name            = "fw-example"
  firewall_public_ip_count = 2
  bastion_host_name        = "bh-example"
  subnets = [
    {
      name : "AzureFirewallSubnet"
      address_prefixes : ["192.168.255.0/26"]
      enforce_private_link_endpoint_network_policies : true
      enforce_private_link_service_network_policies : false
      service_endpoints : null
      deligation : {
        name : null
        service_delegation : {
          actions : null
          name : null
        }
      }
    },
    {
      name : "AzureFirewallManagementSubnet"
      address_prefixes : ["192.168.255.64/26"]
      enforce_private_link_endpoint_network_policies : true
      enforce_private_link_service_network_policies : false
      service_endpoints : null
      deligation : {
        name : null
        service_delegation : {
          actions : null
          name : null
        }
      }
    },
    {
      name : "AzureBastionSubnet"
      address_prefixes : ["192.168.255.128/26"]
      enforce_private_link_endpoint_network_policies : true
      enforce_private_link_service_network_policies : false
      service_endpoints : null
      deligation : {
        name : null
        service_delegation : {
          actions : null
          name : null
        }
      }
    },
    {
      name : "sn-webapp"
      address_prefixes : ["10.1.255.0/26"]
      enforce_private_link_endpoint_network_policies : false
      enforce_private_link_service_network_policies : false
      service_endpoints : [
        "Microsoft.AzureActiveDirectory",
        "Microsoft.Storage",
        "Microsoft.Web",
      ]
      deligation : {
        name : "serverfarmsdelegation"
        service_delegation : {
          actions : ["Microsoft.Network/virtualNetworks/subnets/join/action"]
          name : "Microsoft.Web/serverFarms"
        }
      }
    },
    {
      name : "sn-endpoint"
      address_prefixes : ["10.1.255.64/26"]
      enforce_private_link_endpoint_network_policies : true
      enforce_private_link_service_network_policies : false
      service_endpoints : [
        "Microsoft.AzureActiveDirectory",
        "Microsoft.Storage",
        "Microsoft.Web",
      ]
      deligation : {
        name : null
        service_delegation : {
          actions : null
          name : null
        }
      }
    },
    {
      name : "sn-connector"
      address_prefixes : ["10.1.255.128/26"]
      enforce_private_link_endpoint_network_policies : true
      enforce_private_link_service_network_policies : false
      service_endpoints : [
        "Microsoft.AzureActiveDirectory",
        "Microsoft.Storage",
        "Microsoft.Web",
      ]
      deligation : {
        name : null
        service_delegation : {
          actions : null
          name : null
        }
      }
    }
  ]
}
```


<!-- END_TF_DOCS -->
## Authors

Originally created by [Patrick Hayo](http://github.com/patrickhayo)

## License

[MIT](LICENSE) License - Copyright (c) 2022 by the Author.
