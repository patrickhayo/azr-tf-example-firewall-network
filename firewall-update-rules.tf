resource "azurerm_firewall_policy_rule_collection_group" "sn-endpoint" {
  name               = "EgressRuleCollegionGroup"
  firewall_policy_id = module.firewall.policy_id
  priority           = 620

  application_rule_collection {
    name     = "ApplicationRules"
    priority = 500
    action   = "Allow"

    rule {
      name             = "AllowOsUpdates"
      source_addresses = ["10.1.255.64/26"]
      destination_fqdns = [
        "*.archive.ubuntu.com",
      ]

      protocols {
        port = "443"
        type = "Https"
      }

      protocols {
        port = "80"
        type = "Http"
      }

    }
  }
  depends_on = [
    module.firewall
  ]
}
