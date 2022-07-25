# azr-tf-module-template

[Terraform](https://www.terraform.io) Module to create **[NAME]** in Azure

<!-- BEGIN_TF_DOCS -->
## Prerequisites

- [Terraform](https://releases.hashicorp.com/terraform/) v0.12+

## Providers

No providers.

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >=0.14.9 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >=2.36.0 |

## Modules

No modules.

## Resources

No resources.

## Inputs

No inputs.

## Outputs

No outputs.

## Example

```hcl
resource "azurerm_resource_group" "this" {
  name     = uuid()
  location = "westeurope"
}
```


<!-- END_TF_DOCS -->
## Authors

Originally created by [Patrick Hayo](http://github.com/patrickhayo)

## License

[MIT](LICENSE) License - Copyright (c) 2022 by the Author.
