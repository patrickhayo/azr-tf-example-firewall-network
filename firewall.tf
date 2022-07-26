module "firewall" {
  source               = "github.com/patrickhayo/modules//firewall"
  name                 = local.firewall_name
  resource_group_name  = data.azurerm_resource_group.this.name
  location             = data.azurerm_resource_group.this.location
  public_ip_count      = local.firewall_public_ip_count
  subnet_id            = "/subscriptions/${data.azurerm_client_config.this.subscription_id}/resourceGroups/${data.azurerm_resource_group.this.name}/providers/Microsoft.Network/virtualNetworks/vn-example/subnets/AzureFirewallSubnet"           # module.network.subnet_ids["AzureFirewallSubnet"]
  management_subnet_id = "/subscriptions/${data.azurerm_client_config.this.subscription_id}/resourceGroups/${data.azurerm_resource_group.this.name}/providers/Microsoft.Network/virtualNetworks/vn-example/subnets/AzureFirewallManagementSubnet" # module.network.subnet_ids["AzureFirewallManagementSubnet"]
  proxy_enabled        = true

  depends_on = [
    module.network
  ]
}

# data "http" "storage_westeurope" {
#   url = "https://azrservicetags.azurewebsites.net/Storage.WestEurope.txt"
#   request_headers = {
#     Accept = "application/json"
#   }
# }
