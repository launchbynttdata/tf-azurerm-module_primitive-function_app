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
  value       = lower(var.os_type) == "linux" ? azurerm_linux_function_app.func[0].default_hostname : azurerm_windows_function_app.windows_func[0].default_hostname
}

output "function_app_name" {
  description = "The name of the function app"
  value       = lower(var.os_type) == "linux" ? azurerm_linux_function_app.func[0].name : azurerm_windows_function_app.windows_func[0].name
}

output "function_app_id" {
  description = "The ID of the function app"
  value       = lower(var.os_type) == "linux" ? azurerm_linux_function_app.func[0].id : azurerm_windows_function_app.windows_func[0].id
}

output "principal_id" {
  description = "The principal ID of the function app"
  value       = lower(var.os_type) == "linux" ? (can(azurerm_linux_function_app.func[0].identity[0].principal_id) ? azurerm_linux_function_app.func[0].identity[0].principal_id : null) : (can(azurerm_windows_function_app.windows_func[0].identity[0].principal_id) ? azurerm_windows_function_app.windows_func[0].identity[0].principal_id : null)
}
