# tf-azurerm-module_primitive-function_app

[![License](https://img.shields.io/badge/License-Apache_2.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)
[![License: CC BY-NC-ND 4.0](https://img.shields.io/badge/License-CC_BY--NC--ND_4.0-lightgrey.svg)](https://creativecommons.org/licenses/by-nc-nd/4.0/)

## Overview

This terraform module provisions an Azure Function App with additional pre-requisite resources

## Pre-Commit hooks

[.pre-commit-config.yaml](.pre-commit-config.yaml) file defines certain `pre-commit` hooks that are relevant to terraform, golang and common linting tasks. There are no custom hooks added.

`commitlint` hook enforces commit message in certain format. The commit contains the following structural elements, to communicate intent to the consumers of your commit messages:

- **fix**: a commit of the type `fix` patches a bug in your codebase (this correlates with PATCH in Semantic Versioning).
- **feat**: a commit of the type `feat` introduces a new feature to the codebase (this correlates with MINOR in Semantic Versioning).
- **BREAKING CHANGE**: a commit that has a footer `BREAKING CHANGE:`, or appends a `!` after the type/scope, introduces a breaking API change (correlating with MAJOR in Semantic Versioning). A BREAKING CHANGE can be part of commits of any type.
footers other than BREAKING CHANGE: <description> may be provided and follow a convention similar to git trailer format.
- **build**: a commit of the type `build` adds changes that affect the build system or external dependencies (example scopes: gulp, broccoli, npm)
- **chore**: a commit of the type `chore` adds changes that don't modify src or test files
- **ci**: a commit of the type `ci` adds changes to our CI configuration files and scripts (example scopes: Travis, Circle, BrowserStack, SauceLabs)
- **docs**: a commit of the type `docs` adds documentation only changes
- **perf**: a commit of the type `perf` adds code change that improves performance
- **refactor**: a commit of the type `refactor` adds code change that neither fixes a bug nor adds a feature
- **revert**: a commit of the type `revert` reverts a previous commit
- **style**: a commit of the type `style` adds code changes that do not affect the meaning of the code (white-space, formatting, missing semi-colons, etc)
- **test**: a commit of the type `test` adds missing tests or correcting existing tests

Base configuration used for this project is [commitlint-config-conventional (based on the Angular convention)](https://github.com/conventional-changelog/commitlint/tree/master/@commitlint/config-conventional#type-enum)

If you are a developer using vscode, [this](https://marketplace.visualstudio.com/items?itemName=joshbolduc.commitlint) plugin may be helpful.

`detect-secrets-hook` prevents new secrets from being introduced into the baseline. TODO: INSERT DOC LINK ABOUT HOOKS

In order for `pre-commit` hooks to work properly

- You need to have the pre-commit package manager installed. [Here](https://pre-commit.com/#install) are the installation instructions.
- `pre-commit` would install all the hooks when commit message is added by default except for `commitlint` hook. `commitlint` hook would need to be installed manually using the command below

```
pre-commit install --hook-type commit-msg
```

## To test the resource group module locally

1. For development/enhancements to this module locally, you'll need to install all of its components. This is controlled by the `configure` target in the project's [`Makefile`](./Makefile). Before you can run `configure`, familiarize yourself with the variables in the `Makefile` and ensure they're pointing to the right places.

```
make configure
```

This adds in several files and directories that are ignored by `git`. They expose many new Make targets.

2. _THIS STEP APPLIES ONLY TO MICROSOFT AZURE. IF YOU ARE USING A DIFFERENT PLATFORM PLEASE SKIP THIS STEP._ The first target you care about is `env`. This is the common interface for setting up environment variables. The values of the environment variables will be used to authenticate with cloud provider from local development workstation.

`make configure` command will bring down `azure_env.sh` file on local workstation. Devloper would need to modify this file, replace the environment variable values with relevant values.

These environment variables are used by `terratest` integration suit.

Service principle used for authentication(value of ARM_CLIENT_ID) should have below privileges on resource group within the subscription.

```
"Microsoft.Resources/subscriptions/resourceGroups/write"
"Microsoft.Resources/subscriptions/resourceGroups/read"
"Microsoft.Resources/subscriptions/resourceGroups/delete"
```

Then run this make target to set the environment variables on developer workstation.

```
make env
```

3. The first target you care about is `check`.

**Pre-requisites**
Before running this target it is important to ensure that, developer has created files mentioned below on local workstation under root directory of git repository that contains code for primitives/segments. Note that these files are `azure` specific. If primitive/segment under development uses any other cloud provider than azure, this section may not be relevant.

- A file named `provider.tf` with contents below

```
provider "azurerm" {
  features {}
}
```

- A file named `terraform.tfvars` which contains key value pair of variables used.

Note that since these files are added in `gitignore` they would not be checked in into primitive/segment's git repo.

After creating these files, for running tests associated with the primitive/segment, run

```
make check
```

If `make check` target is successful, developer is good to commit the code to primitive/segment's git repo.

`make check` target

- runs `terraform commands` to `lint`,`validate` and `plan` terraform code.
- runs `conftests`. `conftests` make sure `policy` checks are successful.
- runs `terratest`. This is integration test suit.
- runs `opa` tests
<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~>3.113 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 3.116.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_linux_function_app.func](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_function_app) | resource |
| [azurerm_windows_function_app.windows_func](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/windows_function_app) | resource |
| [azurerm_service_plan.asp](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/service_plan) | data source |
| [azurerm_storage_account.sa](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/storage_account) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_function_app_name"></a> [function\_app\_name](#input\_function\_app\_name) | Name of the function app to create | `string` | n/a | yes |
| <a name="input_service_plan_name"></a> [service\_plan\_name](#input\_service\_plan\_name) | Name of the service plan to create | `string` | n/a | yes |
| <a name="input_storage_account_name"></a> [storage\_account\_name](#input\_storage\_account\_name) | Name of the storage account to create | `string` | n/a | yes |
| <a name="input_storage_account_access_key"></a> [storage\_account\_access\_key](#input\_storage\_account\_access\_key) | Access key for the storage account | `string` | `null` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | name of the resource group where the function app will be created | `string` | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | Location where the function app will be created | `string` | n/a | yes |
| <a name="input_app_settings"></a> [app\_settings](#input\_app\_settings) | Environment variables to set on the function app | `map(string)` | `{}` | no |
| <a name="input_functions_extension_version"></a> [functions\_extension\_version](#input\_functions\_extension\_version) | The version of the Azure Functions runtime to use | `string` | `"~4"` | no |
| <a name="input_https_only"></a> [https\_only](#input\_https\_only) | If true, the function app will only accept HTTPS requests | `bool` | `true` | no |
| <a name="input_public_network_access_enabled"></a> [public\_network\_access\_enabled](#input\_public\_network\_access\_enabled) | If true, the function app will be accessible from the public internet | `bool` | `true` | no |
| <a name="input_site_config"></a> [site\_config](#input\_site\_config) | object({<br>  always\_on        = If this Linux Web App is Always On enabled. Defaults to false.<br>  app\_command\_line = The App command line to launch.<br>  app\_scale\_limit  = The number of workers this function app can scale out to. Only applicable to apps on the Consumption and Premium plan.<br>  application\_insights\_connection\_string = The connection string of the Application Insights instance to use.<br>  application\_insights\_key               = The key of the Application Insights instance to use.<br>  application\_stack = optional(object({<br>    docker = optional(object({<br>      image\_name        = The name of the Docker image to use.<br>      image\_tag         = The image tag of the image to use.<br>      registry\_url      = The URL of the docker registry.<br>      registry\_username = The username to use for connections to the registry.<br>      registry\_password = The password for the account to use to connect to the registry.<br>    }))<br>    dotnet\_version              = optional(string)<br>    use\_dotnet\_isolated\_runtime = optional(bool)<br>    java\_version                = optional(string)<br>    node\_version                = optional(string)<br>    python\_version              = optional(string)<br>    powershell\_core\_version     = optional(string)<br>    use\_custom\_runtime          = optional(bool)<br>  }))<br>  container\_registry\_managed\_identity\_client\_id = The Client ID of the Managed Service Identity to use for connections to the Azure Container Registry.<br>  container\_registry\_use\_managed\_identity       = Should connections for Azure Container Registry use Managed Identity.<br>  cors = optional(object({<br>    allowed\_origins     = list(string)<br>    support\_credentials = optional(bool)<br>  }))<br>  health\_check\_path = The path to be checked for this function app health.<br>  http2\_enabled     = Specifies if the HTTP2 protocol should be enabled. Defaults to false.<br>  ip\_restriction = optional(list(object({<br>    ip\_address = The CIDR notation of the IP or IP Range to match.<br>    action     = The action to take. Possible values are Allow or Deny. Defaults to Allow.<br>  })))<br>  minimum\_tls\_version = The configures the minimum version of TLS required for SSL requests. Defaults to '1.2'<br>}) | <pre>object({<br>    always_on                              = optional(bool)<br>    app_command_line                       = optional(string)<br>    app_scale_limit                        = optional(number)<br>    application_insights_connection_string = optional(string)<br>    application_insights_key               = optional(string)<br>    application_stack = optional(object({<br>      docker = optional(object({<br>        image_name        = string<br>        image_tag         = string<br>        registry_url      = optional(string)<br>        registry_username = optional(string)<br>        registry_password = optional(string)<br>      }))<br>      dotnet_version              = optional(string)<br>      use_dotnet_isolated_runtime = optional(bool)<br>      java_version                = optional(string)<br>      node_version                = optional(string)<br>      python_version              = optional(string)<br>      powershell_core_version     = optional(string)<br>      use_custom_runtime          = optional(bool)<br>    }))<br>    container_registry_managed_identity_client_id = optional(string)<br>    container_registry_use_managed_identity       = optional(bool)<br>    cors = optional(object({<br>      allowed_origins     = list(string)<br>      support_credentials = optional(bool)<br>    }))<br>    health_check_path = optional(string)<br>    http2_enabled     = optional(bool)<br>    ip_restriction = optional(list(object({<br>      ip_address = string<br>      action     = string<br>    })))<br>    minimum_tls_version = optional(string)<br>  })</pre> | `{}` | no |
| <a name="input_identity"></a> [identity](#input\_identity) | (Optional) An identity block. | <pre>object({<br>    type         = string<br>    identity_ids = optional(list(string))<br>  })</pre> | `null` | no |
| <a name="input_key_vault_reference_identity_id"></a> [key\_vault\_reference\_identity\_id](#input\_key\_vault\_reference\_identity\_id) | (Optional) The identity ID of the Key Vault reference. Required when identity.type is set to UserAssigned or SystemAssigned, UserAssigned. | `string` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | n/a | `map(string)` | `{}` | no |
| <a name="input_os_type"></a> [os\_type](#input\_os\_type) | The operating system type of the function app | `string` | `"Linux"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_default_hostname"></a> [default\_hostname](#output\_default\_hostname) | The default hostname for the function app |
| <a name="output_function_app_name"></a> [function\_app\_name](#output\_function\_app\_name) | The name of the function app |
| <a name="output_function_app_id"></a> [function\_app\_id](#output\_function\_app\_id) | The ID of the function app |
| <a name="output_principal_id"></a> [principal\_id](#output\_principal\_id) | The principal ID of the function app |
<!-- END_TF_DOCS -->
