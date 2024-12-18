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

variable "function_app_name" {
  description = "Name of the function app to create"
  type        = string
}

variable "service_plan_name" {
  description = "Name of the service plan to create"
  type        = string
}

variable "storage_account_name" {
  description = "Name of the storage account to create"
  type        = string
}

variable "storage_account_access_key" {
  description = "Access key for the storage account"
  type        = string
  default     = null
}

variable "resource_group_name" {
  description = "name of the resource group where the function app will be created"
  type        = string
}

variable "location" {
  description = "Location where the function app will be created"
  type        = string
}

variable "app_settings" {
  description = "Environment variables to set on the function app"
  type        = map(string)
  default     = {}
}

variable "functions_extension_version" {
  description = "The version of the Azure Functions runtime to use"
  type        = string
  default     = "~4"
}

variable "https_only" {
  description = "If true, the function app will only accept HTTPS requests"
  type        = bool
  default     = true
}

variable "public_network_access_enabled" {
  description = "If true, the function app will be accessible from the public internet"
  type        = bool
  default     = true
}

variable "site_config" {
  description = <<-EOF
    object({
      always_on        = If this Linux Web App is Always On enabled. Defaults to false.
      app_command_line = The App command line to launch.
      app_scale_limit  = The number of workers this function app can scale out to. Only applicable to apps on the Consumption and Premium plan.
      application_insights_connection_string = The connection string of the Application Insights instance to use.
      application_insights_key               = The key of the Application Insights instance to use.
      application_stack = optional(object({
        docker = optional(object({
          image_name        = The name of the Docker image to use.
          image_tag         = The image tag of the image to use.
          registry_url      = The URL of the docker registry.
          registry_username = The username to use for connections to the registry.
          registry_password = The password for the account to use to connect to the registry.
        }))
        dotnet_version              = optional(string)
        use_dotnet_isolated_runtime = optional(bool)
        java_version                = optional(string)
        node_version                = optional(string)
        python_version              = optional(string)
        powershell_core_version     = optional(string)
        use_custom_runtime          = optional(bool)
      }))
      container_registry_managed_identity_client_id = The Client ID of the Managed Service Identity to use for connections to the Azure Container Registry.
      container_registry_use_managed_identity       = Should connections for Azure Container Registry use Managed Identity.
      cors = optional(object({
        allowed_origins     = list(string)
        support_credentials = optional(bool)
      }))
      health_check_path = The path to be checked for this function app health.
      http2_enabled     = Specifies if the HTTP2 protocol should be enabled. Defaults to false.
      ip_restriction = optional(list(object({
        ip_address = The CIDR notation of the IP or IP Range to match.
        action     = The action to take. Possible values are Allow or Deny. Defaults to Allow.
      })))
      minimum_tls_version = The configures the minimum version of TLS required for SSL requests. Defaults to '1.2'
    })
  EOF
  type = object({
    always_on                              = optional(bool)
    app_command_line                       = optional(string)
    app_scale_limit                        = optional(number)
    application_insights_connection_string = optional(string)
    application_insights_key               = optional(string)
    application_stack = optional(object({
      docker = optional(object({
        image_name        = string
        image_tag         = string
        registry_url      = optional(string)
        registry_username = optional(string)
        registry_password = optional(string)
      }))
      dotnet_version              = optional(string)
      use_dotnet_isolated_runtime = optional(bool)
      java_version                = optional(string)
      node_version                = optional(string)
      python_version              = optional(string)
      powershell_core_version     = optional(string)
      use_custom_runtime          = optional(bool)
    }))
    container_registry_managed_identity_client_id = optional(string)
    container_registry_use_managed_identity       = optional(bool)
    cors = optional(object({
      allowed_origins     = list(string)
      support_credentials = optional(bool)
    }))
    health_check_path             = optional(string)
    http2_enabled                 = optional(bool)
    ip_restriction_default_action = optional(string)
    scm_use_main_ip_restriction   = optional(bool)
    vnet_route_all_enabled        = optional(bool)
    ip_restriction = optional(list(object({
      ip_address                = optional(string)
      action                    = string
      name                      = optional(string)
      priority                  = optional(number)
      service_tag               = optional(string)
      virtual_network_subnet_id = optional(string)
      headers = optional(list(object({
        x_forwarded_for   = optional(string)
        x_forwarded_host  = optional(string)
        x_fd_health_probe = optional(string)
        x_azure_fdid      = optional(list(string))
      })))
    })))
    minimum_tls_version = optional(string)
  })
  default = {}
}

variable "identity" {
  description = "(Optional) An identity block."
  type = object({
    type         = string
    identity_ids = optional(list(string))
  })
  default = null
  validation {
    condition     = var.identity == null || can(contains(["SystemAssigned", "UserAssigned", "SystemAssigned, UserAssigned"], var.identity.type))
    error_message = "identity.type must be one of SystemAssigned, UserAssigned, or SystemAssigned, UserAssigned."
  }
}

variable "key_vault_reference_identity_id" {
  description = "(Optional) The identity ID of the Key Vault reference. Required when identity.type is set to UserAssigned or SystemAssigned, UserAssigned."
  type        = string
  default     = null
  validation {
    condition     = var.key_vault_reference_identity_id == null || can(regex("^[a-zA-Z0-9-/.]{2,255}$", var.key_vault_reference_identity_id))
    error_message = "key_vault_reference_identity_id must be a valid azure resource identifier."
  }
}

variable "virtual_network_subnet_id" {
  description = "(Optional) The ID of the subnet to place the function app in."
  type        = string
  default     = null
}
variable "tags" {
  type    = map(string)
  default = {}
}

variable "os_type" {
  description = "The operating system type of the function app"
  type        = string
  default     = "Linux"
}
