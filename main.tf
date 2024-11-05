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
  count = lower(var.os_type) == "linux" ? 1 : 0

  name                = var.function_app_name
  resource_group_name = var.resource_group_name
  location            = var.location

  tags = var.tags

  dynamic "identity" {
    iterator = identity
    for_each = try(var.identity[*], [])
    content {
      type         = identity.value.type
      identity_ids = lookup(identity.value, "identity_ids", null)
    }
  }
  key_vault_reference_identity_id = var.key_vault_reference_identity_id

  app_settings = var.app_settings

  functions_extension_version = var.functions_extension_version

  https_only = var.https_only

  service_plan_id               = data.azurerm_service_plan.asp.id
  public_network_access_enabled = var.public_network_access_enabled

  storage_account_name          = data.azurerm_storage_account.sa.name
  storage_uses_managed_identity = var.storage_account_access_key == null ? true : null
  storage_account_access_key    = var.storage_account_access_key == null ? null : var.storage_account_access_key
  virtual_network_subnet_id     = var.virtual_network_subnet_id == null ? null : var.virtual_network_subnet_id

  site_config {
    always_on                                     = lookup(var.site_config, "always_on", null)
    app_command_line                              = lookup(var.site_config, "app_command_line", null)
    app_scale_limit                               = lookup(var.site_config, "app_scale_limit", null)
    application_insights_connection_string        = lookup(var.site_config, "application_insights_connection_string", null)
    application_insights_key                      = lookup(var.site_config, "application_insights_key", null)
    container_registry_use_managed_identity       = lookup(var.site_config, "container_registry_use_managed_identity", null)
    container_registry_managed_identity_client_id = lookup(var.site_config, "container_registry_managed_identity_client_id", null)
    health_check_path                             = lookup(var.site_config, "health_check_path", null)
    http2_enabled                                 = lookup(var.site_config, "http2_enabled", null)
    minimum_tls_version                           = lookup(var.site_config, "minimum_tls_version", null)
    ip_restriction_default_action                 = lookup(var.site_config, "ip_restriction_default_action", null)
    scm_use_main_ip_restriction                   = lookup(var.site_config, "scm_use_main_ip_restriction", null)

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
      iterator = ip_restriction
      for_each = try(var.site_config.ip_restriction[*], [])
      content {
        action                    = lookup(ip_restriction.value, "action", null)
        ip_address                = lookup(ip_restriction.value, "ip_address", null)
        name                      = lookup(ip_restriction.value, "name", null)
        priority                  = lookup(ip_restriction.value, "priority", null)
        service_tag               = lookup(ip_restriction.value, "service_tag", null)
        virtual_network_subnet_id = lookup(ip_restriction.value, "virtual_network_subnet_id", null)
        dynamic "headers" {
          iterator = headers
          for_each = try(ip_restriction.value["headers"][*], [])
          content {
            x_azure_fdid      = lookup(headers.value, "x_azure_fdid", null)
            x_fd_health_probe = lookup(headers.value, "x_fd_health_probe", null)
            x_forwarded_for   = lookup(headers.value, "x_forwarded_for", null)
            x_forwarded_host  = lookup(headers.value, "x_forwarded_host", null)
          }
        }
      }
    }
  }
  lifecycle {
    ignore_changes = [app_settings]
  }
}

resource "azurerm_windows_function_app" "windows_func" {

  count = lower(var.os_type) == "windows" ? 1 : 0

  location            = var.location
  name                = var.function_app_name
  resource_group_name = var.resource_group_name

  storage_account_name          = data.azurerm_storage_account.sa.name
  storage_uses_managed_identity = var.storage_account_access_key == null ? true : null
  storage_account_access_key    = var.storage_account_access_key == null ? null : var.storage_account_access_key
  virtual_network_subnet_id     = var.virtual_network_subnet_id == null ? null : var.virtual_network_subnet_id

  tags = var.tags

  dynamic "identity" {
    iterator = identity
    for_each = try(var.identity[*], [])
    content {
      type         = identity.value.type
      identity_ids = lookup(identity.value, "identity_ids", null)
    }
  }
  key_vault_reference_identity_id = var.key_vault_reference_identity_id

  app_settings = var.app_settings

  functions_extension_version = var.functions_extension_version

  https_only = var.https_only

  service_plan_id               = data.azurerm_service_plan.asp.id
  public_network_access_enabled = var.public_network_access_enabled

  site_config {

    always_on                              = lookup(var.site_config, "always_on", null)
    app_command_line                       = lookup(var.site_config, "app_command_line", null)
    app_scale_limit                        = lookup(var.site_config, "app_scale_limit", null)
    application_insights_connection_string = lookup(var.site_config, "application_insights_connection_string", null)
    application_insights_key               = lookup(var.site_config, "application_insights_key", null)
    health_check_path                      = lookup(var.site_config, "health_check_path", null)
    http2_enabled                          = lookup(var.site_config, "http2_enabled", null)
    minimum_tls_version                    = lookup(var.site_config, "minimum_tls_version", null)
    ip_restriction_default_action          = lookup(var.site_config, "ip_restriction_default_action", null)
    scm_use_main_ip_restriction            = lookup(var.site_config, "scm_use_main_ip_restriction", null)
    vnet_route_all_enabled                 = lookup(var.site_config, "vnet_route_all_enabled", null)

    dynamic "application_stack" {
      for_each = (lookup(var.site_config, "application_stack", null) != null) ? ["application_stack"] : []
      content {
        dotnet_version              = lookup(var.site_config.application_stack, "dotnet_version", null)
        use_dotnet_isolated_runtime = lookup(var.site_config.application_stack, "use_dotnet_isolated_runtime", null)
        java_version                = lookup(var.site_config.application_stack, "java_version", null)
        node_version                = lookup(var.site_config.application_stack, "node_version", null)
        powershell_core_version     = lookup(var.site_config.application_stack, "powershell_core_version", null)
        use_custom_runtime          = lookup(var.site_config.application_stack, "use_custom_runtime", null)
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
      iterator = ip_restriction
      for_each = try(var.site_config.ip_restriction[*], [])
      content {
        action                    = lookup(ip_restriction.value, "action", null)
        ip_address                = lookup(ip_restriction.value, "ip_address", null)
        name                      = lookup(ip_restriction.value, "name", null)
        priority                  = lookup(ip_restriction.value, "priority", null)
        service_tag               = lookup(ip_restriction.value, "service_tag", null)
        virtual_network_subnet_id = lookup(ip_restriction.value, "virtual_network_subnet_id", null)
        dynamic "headers" {
          iterator = headers
          for_each = try(ip_restriction.value["headers"][*], [])
          content {
            x_azure_fdid      = lookup(headers.value, "x_azure_fdid", null)
            x_fd_health_probe = lookup(headers.value, "x_fd_health_probe", null)
            x_forwarded_for   = lookup(headers.value, "x_forwarded_for", null)
            x_forwarded_host  = lookup(headers.value, "x_forwarded_host", null)
          }
        }
      }
    }
  }
  lifecycle {
    ignore_changes = [app_settings]
  }
}
