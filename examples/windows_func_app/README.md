# windows_func_app

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~>3.113 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_resource_names"></a> [resource\_names](#module\_resource\_names) | terraform.registry.launch.nttdata.com/module_library/resource_name/launch | ~> 2.0 |
| <a name="module_resource_group"></a> [resource\_group](#module\_resource\_group) | terraform.registry.launch.nttdata.com/module_primitive/resource_group/azurerm | ~> 1.0 |
| <a name="module_storage_account"></a> [storage\_account](#module\_storage\_account) | terraform.registry.launch.nttdata.com/module_primitive/storage_account/azurerm | ~> 1.0 |
| <a name="module_app_service_plan"></a> [app\_service\_plan](#module\_app\_service\_plan) | terraform.registry.launch.nttdata.com/module_primitive/app_service_plan/azurerm | ~> 1.0 |
| <a name="module_function_app"></a> [function\_app](#module\_function\_app) | ../.. | n/a |
| <a name="module_role_assignment"></a> [role\_assignment](#module\_role\_assignment) | terraform.registry.launch.nttdata.com/module_primitive/role_assignment/azurerm | ~> 1.0 |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_resource_names_map"></a> [resource\_names\_map](#input\_resource\_names\_map) | A map of key to resource\_name that will be used by tf-launch-module\_library-resource\_name to generate resource names | <pre>map(object({<br>    name       = string<br>    max_length = optional(number, 60)<br>  }))</pre> | <pre>{<br>  "function_app": {<br>    "max_length": 60,<br>    "name": "func"<br>  },<br>  "resource_group": {<br>    "max_length": 60,<br>    "name": "rg"<br>  },<br>  "service_plan": {<br>    "max_length": 60,<br>    "name": "asp"<br>  },<br>  "storage_account": {<br>    "max_length": 24,<br>    "name": "sa"<br>  }<br>}</pre> | no |
| <a name="input_instance_env"></a> [instance\_env](#input\_instance\_env) | Number that represents the instance of the environment. | `number` | `0` | no |
| <a name="input_instance_resource"></a> [instance\_resource](#input\_instance\_resource) | Number that represents the instance of the resource. | `number` | `0` | no |
| <a name="input_logical_product_family"></a> [logical\_product\_family](#input\_logical\_product\_family) | (Required) Name of the product family for which the resource is created.<br>    Example: org\_name, department\_name. | `string` | `"launch"` | no |
| <a name="input_logical_product_service"></a> [logical\_product\_service](#input\_logical\_product\_service) | (Required) Name of the product service for which the resource is created.<br>    For example, backend, frontend, middleware etc. | `string` | `"func"` | no |
| <a name="input_class_env"></a> [class\_env](#input\_class\_env) | (Required) Environment where resource is going to be deployed. For example. dev, qa, uat | `string` | `"dev"` | no |
| <a name="input_location"></a> [location](#input\_location) | Location where the function app will be created | `string` | n/a | yes |
| <a name="input_storage_account_tier"></a> [storage\_account\_tier](#input\_storage\_account\_tier) | The Tier to use for this storage account | `string` | `"Standard"` | no |
| <a name="input_storage_account_replication_type"></a> [storage\_account\_replication\_type](#input\_storage\_account\_replication\_type) | The Replication Type to use for this storage account | `string` | `"LRS"` | no |
| <a name="input_sku"></a> [sku](#input\_sku) | The SKU for the function app hosting plan | `string` | `"Y1"` | no |
| <a name="input_app_settings"></a> [app\_settings](#input\_app\_settings) | Environment variables to set on the function app | `map(string)` | `{}` | no |
| <a name="input_functions_extension_version"></a> [functions\_extension\_version](#input\_functions\_extension\_version) | The version of the Azure Functions runtime to use | `string` | `"~4"` | no |
| <a name="input_https_only"></a> [https\_only](#input\_https\_only) | If true, the function app will only accept HTTPS requests | `bool` | `true` | no |
| <a name="input_public_network_access_enabled"></a> [public\_network\_access\_enabled](#input\_public\_network\_access\_enabled) | If true, the function app will be accessible from the public internet | `bool` | `true` | no |
| <a name="input_site_config"></a> [site\_config](#input\_site\_config) | object({<br>  always\_on        = If this Linux Web App is Always On enabled. Defaults to false.<br>  app\_command\_line = The App command line to launch.<br>  app\_scale\_limit  = The number of workers this function app can scale out to. Only applicable to apps on the Consumption and Premium plan.<br>  application\_stack = optional(object({<br>    docker = optional(object({<br>      image\_name        = The name of the Docker image to use.<br>      image\_tag         = The image tag of the image to use.<br>      registry\_url      = The URL of the docker registry.<br>      registry\_username = The username to use for connections to the registry.<br>      registry\_password = The password for the account to use to connect to the registry.<br>    }))<br>    dotnet\_version              = optional(string)<br>    use\_dotnet\_isolated\_runtime = optional(bool)<br>    java\_version                = optional(string)<br>    node\_version                = optional(string)<br>    python\_version              = optional(string)<br>    powershell\_core\_version     = optional(string)<br>    use\_custom\_runtime          = optional(bool)<br>  }))<br>  container\_registry\_managed\_identity\_client\_id = The Client ID of the Managed Service Identity to use for connections to the Azure Container Registry.<br>  container\_registry\_use\_managed\_identity       = Should connections for Azure Container Registry use Managed Identity.<br>  cors = optional(object({<br>    allowed\_origins     = list(string)<br>    support\_credentials = optional(bool)<br>  }))<br>  health\_check\_path = The path to be checked for this function app health.<br>  http2\_enabled     = Specifies if the HTTP2 protocol should be enabled. Defaults to false.<br>  ip\_restriction = optional(list(object({<br>    ip\_address = The CIDR notation of the IP or IP Range to match.<br>    action     = The action to take. Possible values are Allow or Deny. Defaults to Allow.<br>  })))<br>  minimum\_tls\_version = The configures the minimum version of TLS required for SSL requests. Defaults to '1.2'<br>}) | <pre>object({<br>    always_on        = optional(bool)<br>    app_command_line = optional(string)<br>    app_scale_limit  = optional(number)<br>    application_stack = optional(object({<br>      docker = optional(object({<br>        image_name        = string<br>        image_tag         = string<br>        registry_url      = optional(string)<br>        registry_username = optional(string)<br>        registry_password = optional(string)<br>      }))<br>      dotnet_version              = optional(string)<br>      use_dotnet_isolated_runtime = optional(bool)<br>      java_version                = optional(string)<br>      node_version                = optional(string)<br>      python_version              = optional(string)<br>      powershell_core_version     = optional(string)<br>      use_custom_runtime          = optional(bool)<br>    }))<br>    container_registry_managed_identity_client_id = optional(string)<br>    container_registry_use_managed_identity       = optional(bool)<br>    cors = optional(object({<br>      allowed_origins     = list(string)<br>      support_credentials = optional(bool)<br>    }))<br>    health_check_path = optional(string)<br>    http2_enabled     = optional(bool)<br>    ip_restriction = optional(list(object({<br>      ip_address = string<br>      action     = string<br>    })))<br>    minimum_tls_version = optional(string)<br>  })</pre> | `{}` | no |
| <a name="input_identity_ids"></a> [identity\_ids](#input\_identity\_ids) | Specifies a list of user managed identity ids to be assigned. | `list(string)` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | n/a | `map(string)` | `{}` | no |
| <a name="input_os_type"></a> [os\_type](#input\_os\_type) | The operating system type of the function app | `string` | `"Linux"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_default_hostname"></a> [default\_hostname](#output\_default\_hostname) | n/a |
| <a name="output_function_app_name"></a> [function\_app\_name](#output\_function\_app\_name) | n/a |
| <a name="output_function_app_id"></a> [function\_app\_id](#output\_function\_app\_id) | n/a |
| <a name="output_service_plan_name"></a> [service\_plan\_name](#output\_service\_plan\_name) | n/a |
| <a name="output_service_plan_id"></a> [service\_plan\_id](#output\_service\_plan\_id) | n/a |
| <a name="output_storage_account_id"></a> [storage\_account\_id](#output\_storage\_account\_id) | The id of the storage account |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
