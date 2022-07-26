resource "azurerm_firewall_policy_rule_collection_group" "azure_policy" {
  name               = "MicrosoftEgressRuleCollegionGroup"
  firewall_policy_id = module.firewall.policy_id
  priority           = 500

  application_rule_collection {
    name     = "ApplicationRules"
    priority = 500
    action   = "Allow"

    rule {
      name             = "AllowAzureServiceFqdns"
      source_addresses = ["*"]
      destination_fqdns = [
        "*.aadcdn.microsoftonline-p.com",
        "*.aka.ms",
        "*.applicationinsights.io",
        "*.azure.com",
        "*.azure.net",
        "*.azure-api.net",
        "*.azuredatalakestore.net",
        "*.azureedge.net",
        "*.loganalytics.io",
        "*.microsoft.com",
        "*.microsoftonline.com",
        "*.microsoftonline-p.com",
        "*.msauth.net",
        "*.msftauth.net",
        "*.trafficmanager.net",
        "*.visualstudio.com",
        "*.asazure.windows.net",
        "*.core.windows.net",
        "*.database.windows.net",
        "*.graph.windows.net",
        "*.kusto.windows.net",
        "*.search.windows.net",
        "*.servicebus.windows.net",
      ]

      protocols {
        port = "80"
        type = "Http"
      }

      protocols {
        port = "443"
        type = "Https"
      }
    }
  }

  network_rule_collection {
    name     = "NetworkRules"
    priority = 400
    action   = "Allow"

    rule {
      name              = "AllowAzureServiceTags"
      source_addresses  = ["*"]
      destination_ports = ["*"]
      destination_addresses = [
        "AzureActiveDirectory",
      ]
      protocols = ["Any"]
    }

    rule {
      name              = "AllowStorageWestEurope"
      source_addresses  = ["*"]
      destination_ports = ["*"]
      destination_addresses = [
        "Storage.WestEurope"
      ]
      protocols = ["Any"]
    }

  }
  depends_on = [
    module.firewall
  ]
}
