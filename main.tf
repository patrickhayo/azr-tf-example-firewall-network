data "azurerm_client_config" "this" {}

resource "azurerm_resource_group" "this" {
  name     = local.resource_group_name
  location = local.location
}

data "azurerm_resource_group" "this" {
  name = azurerm_resource_group.this.name
}

module "network" {
  source              = "github.com/patrickhayo/modules//vnet"
  vnet_name           = local.vnet_name
  resource_group_name = data.azurerm_resource_group.this.name
  location            = data.azurerm_resource_group.this.location
  address_space       = local.address_space
  dns_servers         = local.dns_servers
  subnets             = local.subnets
}

module "privatednszone" {
  source               = "github.com/patrickhayo/modules//privatednszone"
  name                 = local.private_dns_zone_name
  resource_group_name  = data.azurerm_resource_group.this.name
  registration_enabled = true
  virtual_networks_to_link = {
    (local.vnet_name) = {
      subscription_id     = data.azurerm_client_config.this.subscription_id
      resource_group_name = data.azurerm_resource_group.this.name
    }
  }
}

module "nsg" {
  source              = "github.com/patrickhayo/modules//nsg"
  for_each            = toset(module.network.subnet_names)
  name                = "nsg-${each.key}"
  resource_group_name = data.azurerm_resource_group.this.name
  location            = data.azurerm_resource_group.this.location
  associate_subnet_id = module.network.subnet_ids[each.key]
  rules = contains(module.network.subnet_names_services, "AzureBastionSubnet") ? [] : [
    {
      name        = "AllowRemoteAzureBastionSubnetInbound"
      description = "Allow SSH and RDP from AzureBastionSubnet Inbound."
      protocol    = "*"
      access      = "Allow"
      priority    = 100
      direction   = "Inbound"
      source = {
        port_range                     = "*"
        port_ranges                    = null
        address_prefix                 = join("", module.network.subnet_address_prefixes["AzureBastionSubnet"])
        address_prefixes               = null
        application_security_group_ids = null
      }
      destination = {
        port_range                     = null
        port_ranges                    = ["22", "3389"]
        address_prefix                 = join("", module.network.subnet_address_prefixes[each.key])
        address_prefixes               = null
        application_security_group_ids = null
      }
    },
    {
      name        = "DenyRemoteAnyInbound"
      description = "Deny SSH and RDP from Any Inbound."
      protocol    = "*"
      access      = "Allow"
      priority    = 200
      direction   = "Inbound"
      source = {
        port_range                     = "*"
        port_ranges                    = null
        address_prefix                 = "*"
        address_prefixes               = null
        application_security_group_ids = null
      }
      destination = {
        port_range                     = null
        port_ranges                    = ["22", "3389"]
        address_prefix                 = join("", module.network.subnet_address_prefixes[each.key])
        address_prefixes               = null
        application_security_group_ids = null
      }
    },

  ]
  depends_on = [
    module.network
  ]
}

module "rt" {
  source                              = "github.com/patrickhayo/modules//rt"
  for_each                            = toset(module.network.subnet_names)
  name                                = "rt-${each.key}"
  resource_group_name                 = data.azurerm_resource_group.this.name
  location                            = data.azurerm_resource_group.this.location
  disable_bgp_route_propagation       = false
  subscription_id                     = data.azurerm_client_config.this.subscription_id
  virtual_network_name                = local.vnet_name
  virtual_network_resource_group_name = data.azurerm_resource_group.this.name
  subnets_to_associate                = [each.key]
  routes = [
    {
      name                   = "default"
      address_prefix         = "0.0.0.0/0"
      next_hop_type          = "VirtualAppliance"
      next_hop_in_ip_address = module.firewall.private_ip_address
    }
  ]
  depends_on = [
    module.network,
    module.firewall
  ]
}
