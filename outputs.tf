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

output "default_hostname" {
  description = "The default hostname for the function app"
  value       = azurerm_linux_function_app.func.default_hostname
}

output "function_app_name" {
  description = "The name of the function app"
  value       = azurerm_linux_function_app.func.name
}

output "function_app_id" {
  description = "The ID of the function app"
  value       = azurerm_linux_function_app.func.id
}

output "principal_id" {
  description = "The principal ID of the function app"
  value       = azurerm_linux_function_app.func.identity[0].principal_id
}

output "service_plan_name" {
  description = "The name of the service plan"
  value       = azurerm_service_plan.asp.name
}

output "service_plan_id" {
  description = "The ID of the service plan"
  value       = azurerm_service_plan.asp.id
}

output "storage_account_name" {
  description = "The name of the storage account"
  value       = azurerm_storage_account.sa.name
}

output "storage_account_id" {
  description = "The ID of the storage account"
  value       = azurerm_storage_account.sa.id
}
