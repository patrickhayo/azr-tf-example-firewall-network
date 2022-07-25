module "bastion_host" {
  source = "github.com/N3tLiX/tf-modules//bastionhost"

  name                = local.bastion_host_name
  location            = data.azurerm_resource_group.this.location
  resource_group_name = data.azurerm_resource_group.this.name
  subnet_id           = module.network.subnet_ids["AzureBastionSubnet"]
  depends_on = [
    module.rules_AzureBastionSubnet,
  ]
}

module "rules_AzureBastionSubnet" {
  source              = "github.com/N3tLiX/tf-modules//nsg"
  name                = "nsg-${local.bastion_host_name}"
  resource_group_name = data.azurerm_resource_group.this.name
  location            = data.azurerm_resource_group.this.location
  associate_subnet_id = module.network.subnet_ids["AzureBastionSubnet"]
  rules = [
    {
      name        = "AllowHttpsInbound"
      description = "Allow Internet HTTPS to Bastion Host"
      protocol    = "Tcp"
      access      = "Allow"
      priority    = 120
      direction   = "Inbound"
      source = {
        port_range                     = "*"
        port_ranges                    = null
        address_prefix                 = "Internet"
        address_prefixes               = null
        application_security_group_ids = null
      }
      destination = {
        port_range                     = "443"
        port_ranges                    = null
        address_prefix                 = "*"
        address_prefixes               = null
        application_security_group_ids = null
      }
    },
    {
      name        = "AllowGatewayManagerInbound"
      description = "Allow GatewayManager HTTPS to Basion Host"
      protocol    = "Tcp"
      access      = "Allow"
      priority    = 130
      direction   = "Inbound"
      source = {
        port_range                     = "*"
        port_ranges                    = null
        address_prefix                 = "GatewayManager"
        address_prefixes               = null
        application_security_group_ids = null
      }
      destination = {
        port_range                     = null
        port_ranges                    = ["443", "4443"]
        address_prefix                 = "*"
        address_prefixes               = null
        application_security_group_ids = null
      }
    },
    {
      name        = "AllowLoadBalancerInbound"
      description = "Allow Loadbalancer HTTPS to Basion Host"
      protocol    = "Tcp"
      access      = "Allow"
      priority    = 140
      direction   = "Inbound"
      source = {
        port_range                     = "*"
        port_ranges                    = null
        address_prefix                 = "AzureLoadBalancer"
        address_prefixes               = null
        application_security_group_ids = null
      }
      destination = {
        port_range                     = "443"
        port_ranges                    = null
        address_prefix                 = "*"
        address_prefixes               = null
        application_security_group_ids = null
      }
    },
    {
      name        = "AllowLBasionHostComunication"
      description = "Allow Basstion Host Communication"
      protocol    = "*"
      access      = "Allow"
      priority    = 150
      direction   = "Inbound"
      source = {
        port_range                     = "*"
        port_ranges                    = null
        address_prefix                 = "VirtualNetwork"
        address_prefixes               = null
        application_security_group_ids = null
      }
      destination = {
        port_range                     = null
        port_ranges                    = ["8080", "5701"]
        address_prefix                 = "VirtualNetwork"
        address_prefixes               = null
        application_security_group_ids = null
      }
    },
    # {
    #   name        = "DenyAnyInbound"
    #   description = "Deny Any other Traffic"
    #   protocol    = "*"
    #   access      = "Deny"
    #   priority    = 160
    #   direction   = "Inbound"
    #   source = {
    #     port_range                     = "*"
    #     port_ranges                    = null
    #     address_prefix                 = "*"
    #     address_prefixes               = null
    #     application_security_group_ids = null
    #   }
    #   destination = {
    #     port_range                     = "*"
    #     port_ranges                    = null
    #     address_prefix                 = "*"
    #     address_prefixes               = null
    #     application_security_group_ids = null
    #   }
    # },
    {
      name        = "AllowSshRdpOutbound"
      description = "Allow SSH and RDP outbound"
      protocol    = "*"
      access      = "Allow"
      priority    = 100
      direction   = "Outbound"
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
        address_prefix                 = "VirtualNetwork"
        address_prefixes               = null
        application_security_group_ids = null
      }
    },
    {
      name        = "AllowAzureCloudOutbound"
      description = "Allow Azure Cloud outbound"
      protocol    = "Tcp"
      access      = "Allow"
      priority    = 110
      direction   = "Outbound"
      source = {
        port_range                     = "*"
        port_ranges                    = null
        address_prefix                 = "*"
        address_prefixes               = null
        application_security_group_ids = null
      }
      destination = {
        port_range                     = "443"
        port_ranges                    = null
        address_prefix                 = "AzureCloud"
        address_prefixes               = null
        application_security_group_ids = null
      }
    },
    {
      name        = "AllowBastionComunicationOutbound"
      description = "Allow Bastion Host to Azure Cloud outbound"
      protocol    = "*"
      access      = "Allow"
      priority    = 120
      direction   = "Outbound"
      source = {
        port_range                     = "*"
        port_ranges                    = null
        address_prefix                 = "VirtualNetwork"
        address_prefixes               = null
        application_security_group_ids = null
      }
      destination = {
        port_range                     = null
        port_ranges                    = ["8080", "5701"]
        address_prefix                 = "VirtualNetwork"
        address_prefixes               = null
        application_security_group_ids = null
      }
    },
    {
      name        = "AllowGetSessionInformationOutbound"
      description = "Allow Bastion Host get Session Information outbound"
      protocol    = "*"
      access      = "Allow"
      priority    = 130
      direction   = "Outbound"
      source = {
        port_range                     = "*"
        port_ranges                    = null
        address_prefix                 = "*"
        address_prefixes               = null
        application_security_group_ids = null
      }
      destination = {
        port_range                     = "80"
        port_ranges                    = null
        address_prefix                 = "Internet"
        address_prefixes               = null
        application_security_group_ids = null
      }
    },
    # {
    #   name        = "DenyAnyOutbound"
    #   description = "Deny anything else outbound"
    #   protocol    = "*"
    #   access      = "Deny"
    #   priority    = 140
    #   direction   = "Outbound"
    #   source = {
    #     port_range                     = "*"
    #     port_ranges                    = null
    #     address_prefix                 = "*"
    #     address_prefixes               = null
    #     application_security_group_ids = null
    #   }
    #   destination = {
    #     port_range                     = "*"
    #     port_ranges                    = null
    #     address_prefix                 = "*"
    #     address_prefixes               = null
    #     application_security_group_ids = null
    #   }
    # },
  ]
  depends_on = [
    module.network,
  ]
}
