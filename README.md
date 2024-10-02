# devops-azure-spoke-lz
<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 3.90.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azapi"></a> [azapi](#provider\_azapi) | 1.12.1 |
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 3.90.0 |
| <a name="provider_azurerm.platformconnectivity"></a> [azurerm.platformconnectivity](#provider\_azurerm.platformconnectivity) | 3.90.0 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.6.3 |
| <a name="provider_time"></a> [time](#provider\_time) | 0.12.1 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_app_insights"></a> [app\_insights](#module\_app\_insights) | ./modules/app_insights | n/a |
| <a name="module_app_service"></a> [app\_service](#module\_app\_service) | ./modules/app_service | n/a |
| <a name="module_app_service_plan"></a> [app\_service\_plan](#module\_app\_service\_plan) | ./modules/app_service_plan | n/a |
| <a name="module_keyvaults"></a> [keyvaults](#module\_keyvaults) | ./modules/keyvault | n/a |
| <a name="module_mysql"></a> [mysql](#module\_mysql) | ./modules/mysql | n/a |
| <a name="module_network"></a> [network](#module\_network) | ./modules/network | n/a |
| <a name="module_private_endpoints"></a> [private\_endpoints](#module\_private\_endpoints) | ./modules/private_endpoint | n/a |
| <a name="module_resourcegroups"></a> [resourcegroups](#module\_resourcegroups) | ./modules/resource_group | n/a |
| <a name="module_storage_account"></a> [storage\_account](#module\_storage\_account) | ./modules/storage_account | n/a |

## Resources

| Name | Type |
|------|------|
| [azapi_resource.peering](https://registry.terraform.io/providers/Azure/azapi/latest/docs/resources/resource) | resource |
| [azurerm_log_analytics_workspace.la_workspace](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/log_analytics_workspace) | resource |
| [azurerm_private_dns_zone_virtual_network_link.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_zone_virtual_network_link) | resource |
| [random_password.password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [time_offset.expiry_date](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/offset) | resource |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |
| [azurerm_private_dns_zone.dns_zone](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/private_dns_zone) | data source |
| [azurerm_virtual_network.connectivity](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/virtual_network) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_app_insights"></a> [app\_insights](#input\_app\_insights) | (Required) The details of app insights for the app services. | <pre>object({<br>    name   = string<br>    rg_key = string<br>  })</pre> | n/a | yes |
| <a name="input_app_service"></a> [app\_service](#input\_app\_service) | (Required) The details of filestore app service. | <pre>object({<br>    name                          = string<br>    rg_key                        = string<br>    vnet_key                      = string<br>    snet_key                      = string<br>    env                           = string<br>    docker_image_tag              = optional(string, "latest")<br>    require_assignment            = optional(bool, false)<br>    allowed_origins               = optional(list(string))<br>    public_network_access_enabled = optional(bool, false)<br>  })</pre> | n/a | yes |
| <a name="input_app_service_plan"></a> [app\_service\_plan](#input\_app\_service\_plan) | (Required) The details of the app service plan for the deployment. | <pre>object({<br>    name   = string<br>    rg_key = string<br>  })</pre> | n/a | yes |
| <a name="input_enable_keyvault"></a> [enable\_keyvault](#input\_enable\_keyvault) | deploy key vault resource. | `bool` | `false` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | (Required) Deployment environment i.e sandbox/dev/uat/prod | `string` | n/a | yes |
| <a name="input_keyvaults"></a> [keyvaults](#input\_keyvaults) | Complete details of keyvaults. | <pre>map(object({<br>    name                            = string<br>    sku_name                        = string<br>    bypass                          = string<br>    default_action                  = string<br>    rg_key                          = string<br>    subnet_ids                      = list(string)<br>    ip_rules                        = optional(list(string))<br>    enabled_for_disk_encryption     = optional(bool)<br>    enabled_for_deployment          = optional(bool)<br>    enabled_for_template_deployment = optional(bool)<br><br>    key_list = optional(map(object({<br>      key_name        = optional(string)<br>      expiration_date = optional(string)<br>    })), {})<br><br>    disk_encryption_set = optional(map(object({<br>      encryption_set_name = optional(string)<br>      key_index           = optional(string)<br>    })), {})<br>  }))</pre> | `{}` | no |
| <a name="input_landing_zone"></a> [landing\_zone](#input\_landing\_zone) | (Required) The Application Landing Zone the terraform is being used for in it's short form | `string` | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | Primary location of the resources | `string` | n/a | yes |
| <a name="input_log_analytics_workspace"></a> [log\_analytics\_workspace](#input\_log\_analytics\_workspace) | Details of log analytics workspace | <pre>object({<br>    name   = string<br>    rg_key = string<br>  })</pre> | n/a | yes |
| <a name="input_mysql"></a> [mysql](#input\_mysql) | Details of Mysql database. | <pre>map(object({<br>    name                = string<br>    rg_key              = string<br>    administrator_login = optional(string, "dbadmin")<br>    vnet_key            = optional(string, null)<br>    snet_key            = optional(string, null)<br>    nysql_databases     = optional(list(string))<br>    storage = optional(object({<br>      auto_grow_enabled  = optional(bool, true)<br>      io_scaling_enabled = optional(bool, false)<br>      iops               = optional(number, 360)<br>      size_gb            = optional(number, 20)<br>    }),{})<br>  }))</pre> | n/a | yes |
| <a name="input_private_endpoint"></a> [private\_endpoint](#input\_private\_endpoint) | Complete details of private\_endpoint. | <pre>map(object({<br>    name                 = string<br>    rg_key               = string<br>    vnet_key             = string<br>    snet_key             = string<br>    dns_key              = string<br>    resource             = string<br>    is_manual_connection = bool<br>    subresource_names    = list(string)<br>    request_message      = optional(string)<br>  }))</pre> | n/a | yes |
| <a name="input_resource_groups"></a> [resource\_groups](#input\_resource\_groups) | (Required) The list of resource groups for the deployment. Changing this forces a new Resource Group to be created. | <pre>map(object({<br>    prefix   = string<br>    location = string<br>  }))</pre> | n/a | yes |
| <a name="input_storage_profile"></a> [storage\_profile](#input\_storage\_profile) | Specifies the details of the Storage Account. | <pre>object({<br>    name                              = string<br>    rg_key                            = string<br>    account_kind                      = string<br>    account_tier                      = string<br>    account_replication_type          = string<br>    min_tls_version                   = string<br>    shared_access_key_enabled         = bool<br>    blob_soft_delete_retention_days   = optional(number, 7)<br>    container_delete_retention_days   = optional(number, 7)<br>    blob_restore_days                 = optional(number)<br>    enable_versioning                 = optional(bool, false)<br>    change_feed_enabled               = optional(bool, false)<br>    infrastructure_encryption_enabled = optional(bool, false)<br>    containers_list                   = optional(list(object({ name = string, access_type = string })), [])<br>  })</pre> | n/a | yes |
| <a name="input_vnet_profile"></a> [vnet\_profile](#input\_vnet\_profile) | (Required) Complete details of virtual network. | `any` | n/a | yes |
| <a name="input_worker_count"></a> [worker\_count](#input\_worker\_count) | (Optional) The number of Workers (instances) to be allocated. | `number` | `1` | no |
| <a name="input_zone_balancing_enabled"></a> [zone\_balancing\_enabled](#input\_zone\_balancing\_enabled) | (Optional) Should the Service Plan balance across Availability Zones in the region. Changing this forces a new resource to be created. | `bool` | `false` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->