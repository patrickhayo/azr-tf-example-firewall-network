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
