resource "azurerm_resource_group" "this" {
  name     = uuid()
  location = "westeurope"
}
