// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

data "azurerm_storage_account" "sa" {
  name                = var.storage_account_name
  resource_group_name = var.resource_group_name
}

data "azurerm_service_plan" "asp" {
  name                = var.service_plan_name
  resource_group_name = var.resource_group_name
}

resource "azurerm_linux_function_app" "func" {
  name                = var.function_app_name
  resource_group_name = var.resource_group_name
  location            = var.location

  tags = var.tags

  identity {
    type         = var.identity_ids != null ? "UserAssigned" : "SystemAssigned"
    identity_ids = var.identity_ids
  }

  app_settings = var.app_settings

  functions_extension_version = var.functions_extension_version

  https_only = var.https_only

  service_plan_id = data.azurerm_service_plan.asp.id

  storage_account_name          = data.azurerm_storage_account.sa.name
  storage_uses_managed_identity = true

  site_config {
    always_on                                     = lookup(var.site_config, "always_on", null)
    app_command_line                              = lookup(var.site_config, "app_command_line", null)
    app_scale_limit                               = lookup(var.site_config, "app_scale_limit", null)
    container_registry_use_managed_identity       = lookup(var.site_config, "container_registry_use_managed_identity", null)
    container_registry_managed_identity_client_id = lookup(var.site_config, "container_registry_managed_identity_client_id", null)
    health_check_path                             = lookup(var.site_config, "health_check_path", null)
    http2_enabled                                 = lookup(var.site_config, "http2_enabled", null)
    minimum_tls_version                           = lookup(var.site_config, "minimum_tls_version", null)

    dynamic "application_stack" {
      for_each = (lookup(var.site_config, "application_stack", null) != null) ? ["application_stack"] : []
      content {
        dotnet_version              = lookup(var.site_config.application_stack, "dotnet_version", null)
        use_dotnet_isolated_runtime = lookup(var.site_config.application_stack, "use_dotnet_isolated_runtime", null)

        java_version            = lookup(var.site_config.application_stack, "java_version", null)
        node_version            = lookup(var.site_config.application_stack, "node_version", null)
        python_version          = lookup(var.site_config.application_stack, "python_version", null)
        powershell_core_version = lookup(var.site_config.application_stack, "powershell_core_version", null)

        use_custom_runtime = lookup(var.site_config.application_stack, "use_custom_runtime", null)

        dynamic "docker" {
          for_each = (lookup(var.site_config.application_stack, "docker", null) != null) ? ["docker"] : []
          content {
            image_name        = var.site_config.application_stack.docker.image_name
            image_tag         = var.site_config.application_stack.docker.image_tag
            registry_url      = lookup(var.site_config.application_stack.docker, "registry_url", null)
            registry_username = lookup(var.site_config.application_stack.docker, "registry_username", null)
            registry_password = lookup(var.site_config.application_stack.docker, "registry_password", null)
          }
        }
      }
    }

    dynamic "cors" {
      for_each = (lookup(var.site_config, "cors", null) != null) ? ["cors"] : []
      content {
        allowed_origins     = var.site_config.cors.allowed_origins
        support_credentials = lookup(var.site_config.cors, "support_credentials", null)
      }
    }

    dynamic "ip_restriction" {
      for_each = (lookup(var.site_config, "ip_restriction", null) != null) ? ["ip_restriction"] : []
      content {
        ip_address = var.site_config.ip_restriction.ip_address
        action     = var.site_config.ip_restriction.action
      }
    }
  }
}
